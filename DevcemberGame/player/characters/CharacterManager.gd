extends Node

onready var RoundTimer = $RoundTimer

export var starting_character_index = 0
export var moveTourTime = 5

var tour_is_active = false
var last_children
var children: Array
var active_index: int = starting_character_index
var list_moved_characters: Array
var tour = "move"

func _ready():
	for x in get_children():
		if x is Character:
			children.append(x)
	children[active_index].show_hide_arrow()
	
func _physics_process(_delta):
	if(!tour_is_active):
		if(get_input()):
			if(tour == "move"):
				if(!list_moved_characters.has(active_index)):
					move_tour()
			elif(tour  == "shoot"):
				shoot_tour()
		
	if(list_moved_characters.size() == children.size()):
		tour = "shoot"

	if(tour == "shoot"):
		if(Input.is_action_just_pressed("shoot")):
			children[active_index].point_to_shoot = true
			tour_is_active = false
		if(Input.is_action_just_pressed("cancel_shoot")):
			children[active_index].point_to_shoot = false
			
func _on_RoundTimer_timeout():
	children[active_index].is_active = false
	tour_is_active = false
	children[active_index].show_hide_arrow()
		
func move_tour():
	RoundTimer.wait_time = moveTourTime
	RoundTimer.start()
	children[active_index].is_active = true
	children[active_index].show_hide_arrow()
	tour_is_active = true
	list_moved_characters.append(active_index)
	
func shoot_tour():
	if(last_children):
		last_children.shoot_is_visible = false
	last_children = children[active_index]
	children[active_index].shoot_is_visible = true
	#tour_is_active = true
func get_input():
	if(Input.is_action_just_pressed("nextcharacter")):
		children[active_index].show_hide_arrow()
		active_index=(active_index-1) % children.size()
		children[active_index].show_hide_arrow()
	if(Input.is_action_just_pressed("prevcharacter")):
		children[active_index].show_hide_arrow()
		active_index=(active_index+1) % children.size()
		children[active_index].show_hide_arrow()
	if(Input.is_action_just_pressed("accept")):
		return true
