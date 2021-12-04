extends KinematicBody2D

onready var WallColider : RayCast2D = $WallColider

const UP_DIRECTION := Vector2.UP

export var speed := 100.0

export var max_jump_strength := 150.0
var jump_strength = max_jump_strength
export var maximum_jumps := 3
export var weakening_jumps := 10.0
export var gravity := 500.0

var wallJump = 250
var jumpWall = 175
var jumps_made := 0
var velocity := Vector2.ZERO

func _physics_process(delta):
	update_input(delta)
	execute_status( update_state() )

	velocity = move_and_slide(velocity, UP_DIRECTION)


func update_input(delta):
	var horizontal_direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	velocity.x = lerp(velocity.x, horizontal_direction * speed, 0.2)
	velocity.y += gravity * delta
	
func update_state():
	var states := Array() 

	if(is_on_floor()):
		if(Input.is_action_just_pressed("jump")):
			states.append("is_jumping")
	else:
		if(velocity.y > 0.0):
			states.append("is_falling")
			if(Input.is_action_just_pressed("jump")):
				states.append("is_double_jumping")
		if(WallColider.is_colliding()):
			states.append("is_attached_to_wall")
	
	if(is_zero_approx(velocity.x)):
		states.append("is_idling")
	else:
		if(velocity.x < 0):
			states.append("is_running_left")
		else:
			states.append("is_running_right")
			
	return states
	
func execute_status(states : Array):
	if(states.has("is_attached_to_wall")):
		jumps_made = 0
		if(velocity.y > 30):
			velocity.y = 30
	if(states.has("is_jumping")):
		jump_strength = max_jump_strength
		velocity.y = 0
		jumps_made = 1
		velocity.y -= jump_strength
	if(states.has("is_double_jumping")):
		if(jumps_made < maximum_jumps):
			velocity.y = 0
			jumps_made += 1
			velocity.y -= jump_strength
			jump_strength -= weakening_jumps

