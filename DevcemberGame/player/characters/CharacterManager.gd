extends Node

#onready var RoundTimer = $RoundTimer
onready var RoundTimer = $Timer
onready var EndTourButton = $EndTour

export var starting_character_index = 0
export var moveTourTime = 5

var tour_is_active = false
var children: Array
var active_index: int = starting_character_index
var active_child: Character
var list_moved_characters: Array
var number_of_ready_characters = 0
var tour = "move"

func _ready():
	for x in get_children():
		if x is Character:
			children.append(x)
	active_child=children[active_index]
	active_child.change_main_status("stop")

func _physics_process(_delta):
	if(!tour_is_active):
		choose_character()

	if(list_moved_characters.size() == children.size()):
		tour = "shoot"
		EndTourButton.visible = false
	if(number_of_ready_characters == children.size() ):
		tour = "end_of_tour"
		EndTourButton.visible = true
		
	if(tour == "shoot" or tour == "end_of_tour"):
		if(Input.is_action_just_pressed("shoot")):
			if(not active_child.is_ready):
				active_child.change_main_status("ready")
				number_of_ready_characters += 1
		if(Input.is_action_just_pressed("cancel_shoot")):
			if(active_child.is_ready):
				active_child.change_main_status("aim")
				number_of_ready_characters -= 1
			
func _on_Timer_timer_out():
	active_child.change_main_status("stop")
	tour_is_active = false
	
func choose_character():
	if(get_input()):
		if(tour == "move" and !list_moved_characters.has(active_child)):
			move_tour()
		elif(tour  == "shoot"):
			shoot_tour()

func move_tour():
	RoundTimer.start_counting(moveTourTime)
	active_child.change_main_status("move")
	tour_is_active = true
	list_moved_characters.append(active_child)
	
func shoot_tour():
	active_child.change_main_status("aim")
	
func get_input():
	if(Input.is_action_just_pressed("nextcharacter")):
		change_character(1)
	elif(Input.is_action_just_pressed("prevcharacter")):
		change_character(-1)
	if(Input.is_action_just_pressed("accept")):
		return true

func change_character(input):
	active_child.change_main_status("not_active")
	active_index=(active_index-input) % children.size()
	active_child = children[active_index]
	
	
	if(tour == "move"):
		active_child.change_main_status("stop")
	else:
		if(active_child.is_ready):
			active_child.change_main_status("ready")
		else:
			active_child.change_main_status("aim")

func _on_EndTour_mouse_entered():
	for it in children:
		it.shoot_is_visible = true


func _on_EndTour_mouse_exited():
	for it in children:
		it.shoot_is_visible = false
