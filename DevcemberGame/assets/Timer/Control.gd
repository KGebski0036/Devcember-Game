extends Control

onready var label : Label = $Label
onready var timer : Timer = $RoundTimer

signal timer_out

func start_counting(time):
	timer.wait_time = time
	timer.start()

func _process(_delta):
	label.text = "%.3f" % timer.time_left
	

func _on_RoundTimer_timeout():
	emit_signal("timer_out")
