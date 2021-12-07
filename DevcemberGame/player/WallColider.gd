extends RayCast2D

func _physics_process(_delta):
	
	if(Input.is_action_pressed("left")):
		cast_to = Vector2(-7,0)
	elif(Input.is_action_pressed("right")):
		cast_to = Vector2(7,0)
	else:
		cast_to = Vector2(0,0)


