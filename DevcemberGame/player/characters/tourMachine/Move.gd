extends TourState

	
func enter() -> void:
	tourMenager.active_child.StateMachine.transition_to("Move")
	tourMenager.RoundTimer.start_counting(tourMenager.moveTourTime)
	tourMenager.list_moved_characters.append(tourMenager.active_child)

func exit() -> void:
	tourMenager.active_child.StateMachine.transition_to("Active")
