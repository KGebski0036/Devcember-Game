extends Node

var children: Array

export var starting_character_index = 0


var active_index: int = starting_character_index


func _ready():
	for x in get_children():
		if x is Character:
			children.append(x)

	children[active_index].is_active = true
	
func _on_RoundTimer_timeout():
	children[active_index].is_active = false
	active_index=(active_index+1) % children.size()
	children[active_index].is_active = true
