extends KinematicBody2D

const UP_DIRECTION := Vector2.UP

export var speed := 100.0

export var jump_strength := 150.0
export var maximum_jumps := 1
export var secound_jump_strength := 250.0
export var gravity := 800.0

var jumps_made := 0
var velocity := Vector2.ZERO

var states := Array() 

func get_input(delta):
	var horizontal_direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	velocity.x = horizontal_direction * speed
	velocity.y += gravity * delta
	
func get_state():
	if(velocity.y > 0.0 and not is_on_floor()):
		states.append("is_falling")
		
		if(Input.is_action_just_pressed("jump")):
			states.append("is_double_jumping")
			jumps_made += 1
			if(jumps_made <= maximum_jumps):
				velocity.y -= secound_jump_strength
			
	if(Input.is_action_just_pressed("jump") and is_on_floor()):
		states.append("is_jumping")
		jumps_made += 1
		velocity.y = -jump_strength

	if(is_zero_approx(velocity.x) and is_on_floor()):
		states.append("is_idling")
		jumps_made = 0
		
	if((not is_zero_approx(velocity.x)) and is_on_floor()):
		states.append("is_running")
		jumps_made = 0
func _physics_process(delta):
	get_input(delta)
	get_state()
	velocity = move_and_slide(velocity, UP_DIRECTION)
