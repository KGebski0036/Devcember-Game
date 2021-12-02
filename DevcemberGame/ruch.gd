extends KinematicBody2D

var velocity = Vector2()
export (int) var speed = 200

export var jump_heigh : float
export var jump_time_to_peak : float
export var jump_time_to_descent : float

onready var jump_velocity : float = ((2.0 * jump_heigh) / jump_time_to_peak	) * -1
onready var jump_gravity : float = ((-2.0 * jump_heigh) / (jump_time_to_peak	* jump_time_to_peak)) * -1
onready var fall_gravity : float = ((-2.0 * jump_heigh) / (jump_time_to_descent	* jump_time_to_descent)) * -1

func get_gravity() -> float:
	return jump_gravity if velocity.y > 0.0 else fall_gravity
	
func jump():
	velocity.y = jump_velocity
	
	if Input.is_action_just_pressed("jump")  and is_on_floor():
		jump()
	velocity = move_and_slide(velocity)

func get_input():
	
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	velocity = velocity.normalized() * speed
	return velocity

func _physics_process(delta):
	velocity = get_input() * speed
	velocity.y += get_gravity() * delta
	
	velocity = move_and_slide(velocity)

