extends Node

signal player_tour_started

func _on_CharacterManager_enemy_tour_started():
	emit_signal("player_tour_started")
