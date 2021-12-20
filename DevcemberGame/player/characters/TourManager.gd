class_name TourMenager
extends Node

onready var RoundTimer = $Character1
onready var EndTourButton = $EndTour
#onready var TourMachie := $TourMachine

export var starting_character_index = 0
export var moveTourTime = 5

signal enemy_tour_started

var tour_is_active = false
var tour_is_active_first_time = false

var children: Array
var active_index: int = starting_character_index
var active_child: Character
var list_moved_characters: Array
var number_of_ready_characters = 0
var tour = TOUR.MOVE

enum TOUR { 
	MOVE,
	SHOOT,
	END,
	ENEMY
}

func _ready():
	for x in get_children():
		if x is Character:
			children.append(x)
	active_child=children[active_index]
	active_child.StateMachine.transition_to("Active")

#func _physics_process(_delta):
#	if(!tour_is_active):
#
#		if(list_moved_characters.size() == children.size() and tour == TOUR.MOVE):
#			tour = TOUR.SHOOT
#			active_child.StateMachine.transition_to("Aim")
#
#		if(number_of_ready_characters == children.size() ):
#			tour = TOUR.END
#			EndTourButton.visible = true
#		else:
#			EndTourButton.visible = false
#
#		choose_character()
#
#	if(tour == TOUR.SHOOT or tour == TOUR.END):
#		if(Input.is_action_just_pressed("shoot")):
#			if(not active_child.is_ready):
#				active_child.StateMachine.transition_to("Ready")
#				number_of_ready_characters += 1
#		if(Input.is_action_just_pressed("cancel_shoot")):
#			if(active_child.is_ready):
#				active_child.StateMachine.transition_to("Aim")
#				number_of_ready_characters -= 1
			
func _on_Timer_timer_out():
	pass
	#TourMachie.transition_to("ChooseCharacter")
	
#func choose_character():
#	if(get_input()):
#		if(tour == TOUR.MOVE and !list_moved_characters.has(active_child)):
#			move_tour()
#		elif(tour  == TOUR.SHOOT):
#			shoot_tour()

#func move_tour():
#	RoundTimer.start_counting(moveTourTime)
#	active_child.StateMachine.transition_to("Move")
#	tour_is_active = true
#	list_moved_characters.append(active_child)
#
#func shoot_tour():
#	active_child.StateMachine.transition_to("Move")
	
#func get_input():
#	if(Input.is_action_just_pressed("nextcharacter")):
#		change_character(1)
#	elif(Input.is_action_just_pressed("prevcharacter")):
#		change_character(-1)
#
#	return Input.is_action_just_pressed("accept")
#
#
#func change_character(input):
#	active_child.StateMachine.transition_to("NotActive")
#	active_index=(active_index-input) % children.size()
#	active_child = children[active_index]
##
#
#	if(tour == TOUR.MOVE):
#		active_child.StateMachine.transition_to("Active")
#	else:
#		if(active_child.is_ready):
#			active_child.StateMachine.transition_to("Ready")
#		else:
#			active_child.StateMachine.transition_to("Aim")

func _on_EndTour_mouse_entered():
	for it in children:
		it.StateMachine.transition_to("Ready")


func _on_EndTour_mouse_exited():
	for it in children:
		it.StateMachine.transition_to("NotActive")
	active_child.StateMachine.transition_to("Ready")

func _on_EndTour_pressed():
	for it in children:
		it = it as Character
		var bullet = it.bullet_scene.instance() as Bullet
		bullet.init(it.target_point)
		it.add_child(bullet)
		it.change_turn_state(Character.TURN_STATE.NOT_ACTIVE)
	list_moved_characters.clear()
	tour_is_active = true
	number_of_ready_characters = 0
	tour = TOUR.ENEMY
	emit_signal("enemy_tour_started")
	EndTourButton.visible = false


func _on_EnemyManager_player_tour_started():
	tour_is_active = false
	tour = TOUR.MOVE
	for it in children:
		it = it as Character
		it.has_target = false
	active_child.StateMachine.transition_to("Active")
