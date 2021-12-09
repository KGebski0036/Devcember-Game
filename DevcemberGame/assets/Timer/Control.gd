extends Control

onready var label = $Label
onready var timer = $RoundTimer

signal timer_out


func _process(_delta):
	label.text = "%.3f" % timer.time_left
	

func _on_RoundTimer_timeout():
	emit_signal("timer_out")
