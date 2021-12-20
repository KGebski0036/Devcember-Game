extends Node

export var initial_tour := NodePath()

onready var tour: State = get_node(initial_tour)


func _ready() -> void:
	yield(owner, "ready")
	
	for child in get_children():
		child.tour_machine = self
	tour.enter()


func _unhandled_input(event: InputEvent) -> void:
	tour.handle_input(event)


func _process(delta: float) -> void:
	tour.update(delta)


func _physics_process(delta: float) -> void:
	tour.physics_update(delta)


func transition_to(target_tour_name: String) -> void:
	
	if not has_node(target_tour_name):
		return
		
	tour.exit()
	tour = get_node(target_tour_name)
	tour.enter()

