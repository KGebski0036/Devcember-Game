extends KinematicBody2D

var wallJump = 250
var jumpWall = 175

const UP_DIRECTION := Vector2.UP

export var speed := 100.0

export var jump_strength := 150.0
export var maximum_jumps := 2
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
	
	if is_on_floor() or is_on_wall():
		jumps_made = 2
	
		if(Input.is_action_just_pressed("jump") and jumps_made > 0):
			states.append("is_double_jumping")
			velocity.y = 0
			jumps_made += 1
			if (not is_on_floor() and nextToRightWall()):
				velocity.x -= wallJump
				velocity.y -= jumpWall
			if (not is_on_floor() and nextToLeftWall()):
				velocity.x += wallJump
				velocity.y -= jumpWall
			if(jumps_made <= maximum_jumps):
				velocity.y -= secound_jump_strength
		if nextToWall() and velocity.y > 30:
			velocity.y = 30
				
			
	if(Input.is_action_just_pressed("jump") and is_on_floor()):
		states.append("is_jumping")
		velocity.y = 0
		jumps_made += 1
		velocity.y = -jump_strength

	if(is_zero_approx(velocity.x) and is_on_floor()):
		states.append("is_idling")
		jumps_made = 0
		
	if((not is_zero_approx(velocity.x)) and is_on_floor()):
		states.append("is_running")
		jumps_made = 0

func nextToWall():
	return nextToRightWall() or nextToLeftWall()
	
func nextToRightWall():
	return $RightWall.is_colliding()
	
func nextToLeftWall():
	return $LeftWall.is_colliding()

func _physics_process(delta):
	get_input(delta)
	get_state()
	velocity = move_and_slide(velocity, UP_DIRECTION)
