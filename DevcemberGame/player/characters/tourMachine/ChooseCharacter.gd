extends TourState

func handle_input(_event: InputEvent) -> void:
	if(Input.is_action_just_pressed("nextcharacter")):
		tourMenager.change_character(1)
	elif(Input.is_action_just_pressed("prevcharacter")):
		change_character(-1)
		
	if(Input.is_action_just_pressed("accept") && !tourMenager.list_moved_characters.has(tourMenager.active_child)):
		tourMenager.TourMachie.transition_to("Move")

func physics_update(_delta: float) -> void:
	pass
		
func enter() -> void:
	pass

func exit() -> void:
	pass

func change_character(input):
	tourMenager.active_child.StateMachine.transition_to("NotActive")
	tourMenager.active_index=(tourMenager.active_index-input) % tourMenager.children.size()
	tourMenager.active_child = tourMenager.children[tourMenager.active_index]
	tourMenager.active_child.StateMachine.transition_to("Active")
