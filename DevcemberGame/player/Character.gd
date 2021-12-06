extends KinematicBody2D

class_name Character

onready var WallColider : RayCast2D = $WallColider
onready var ShootColider : RayCast2D = $ShootColider
onready var Mark = $Strzalka

const UP_DIRECTION := Vector2.UP

export var speed := 100.0

export var max_jump_strength := 150.0
export var maximum_jumps := 3
export var weakening_jumps := 10.0
export var gravity := 500.0

var point_to_shoot := false
var shoot_is_visible := false
var is_active := false
var is_ready := false

var main_status := "not_active" 

var jump_strength := max_jump_strength
var jumps_made := 0
var velocity := Vector2.ZERO
var horizontal_direction := 0.0

func _physics_process(delta):
	if(is_active):
		update_input()
		execute_status( update_state() )
	else:
		horizontal_direction = 0
	
	velocity.x = lerp(velocity.x, horizontal_direction * speed, 0.2)
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, UP_DIRECTION)
	
	ShootColider.visible = shoot_is_visible

func update_input():
	horizontal_direction = Input.get_action_strength("right") - Input.get_action_strength("left")

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
			
	
func change_main_status(new_main_status):
	match new_main_status:
		"stop":
			is_active = false
			shoot_is_visible = false
			Mark.visible = true
		"move":
			is_active = true
			shoot_is_visible = false
			Mark.visible = true
		"aim": 
			is_ready = false
			is_active = false
			shoot_is_visible = true
			point_to_shoot = false
			Mark.visible = true
		"ready":
			is_ready = true
			is_active = false
			shoot_is_visible = true
			point_to_shoot = true
			Mark.visible = true
		"not_active":
			is_active = false
			shoot_is_visible = false
			Mark.visible = false
		_:
			print("Something is wrong ... i can feel it")
			
	main_status = new_main_status
	
