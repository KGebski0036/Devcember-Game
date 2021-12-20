extends KinematicBody2D

class_name Character

onready var WallColider : RayCast2D = $WallColider
onready var ShootColider : RayCast2D = $ShootColider
onready var Mark : Sprite = $Strzalka
#onready var StateMachine = $StateMachine

const UP_DIRECTION := Vector2.UP

export var speed: float = 100.0
export var max_jump_strength: float = 150.0
export var maximum_jumps: int= 3
export var jump_weakening: float = 10.0
export var gravity: float = 500.0
export var max_health: float = 200
export var defense: float = 1
export var max_heigth_that_dont_hurt_character: float = 250 #maksymalna wysokosc z ktorej moze upasc
export var bullet_scene: PackedScene

enum ACTION_STATE {
	IDLING,
	JUMPING,
	DOUBLE_JUMPING,
	FALLING,
	WALL_SLIDING,
	HIT_THE_GROUND,
	RUNNING_LEFT,
	RUNNING_RIGHT
}

var chosen := false
enum TURN_STATE {
	NOT_ACTIVE,
	MOVE,
	AIM,
	READY
}

#turn related
var target_point : Vector2
var has_target := false 
var shoot_is_visible := false
var is_active := false
var is_ready := false
var turn_state = TURN_STATE.NOT_ACTIVE

#movement_related
var jump_strength := max_jump_strength
var jumps_made := 0
var velocity := Vector2.ZERO
var previous_velocity := Vector2.ZERO
var horizontal_direction := 0.0

#health related
var health:= max_health


#func _physics_process(delta):
#	target_point = ShootColider.target_point
#	if(is_active):
#		update_input()
#		execute_state( update_state() )
#	else:
#		horizontal_direction = 0
#
#	velocity.x = lerp(velocity.x, horizontal_direction * speed, 0.2)
#	velocity.y += gravity * delta
#	jebudu = velocity.y
#	velocity = move_and_slide(velocity, UP_DIRECTION)
#	if(jebudu - velocity.y > alakurwarzeczywiscie):
#		execute_state([ACTION_STATE.JEBNAL_W_ZIEMIE])
#	ShootColider.visible = shoot_is_visible
#
#func update_input():
#	horizontal_direction = Input.get_action_strength("right") - Input.get_action_strength("left")
#
func update_state():
	var states := Array() 

	if(is_on_floor()):
		if(Input.is_action_just_pressed("jump")):
			states.append(ACTION_STATE.JUMPING)
	else:
		if(velocity.y > 0.0):
			states.append(ACTION_STATE.FALLING)
			if(Input.is_action_just_pressed("jump")):
				states.append(ACTION_STATE.DOUBLE_JUMPING)
		if(WallColider.is_colliding()):
			states.append(ACTION_STATE.WALL_SLIDING)

	if(is_zero_approx(velocity.x)):
		states.append(ACTION_STATE.IDLING)
	else:
		if(velocity.x < 0):
			states.append(ACTION_STATE.RUNNING_LEFT)
		else:
			states.append(ACTION_STATE.RUNNING_RIGHT)

	return states

func execute_state(states : Array):
	if(states.has(ACTION_STATE.WALL_SLIDING)):
		jumps_made = 0
		if(velocity.y > 30):
			velocity.y = 30
	if(states.has(ACTION_STATE.JUMPING)):
		jump_strength = max_jump_strength
		velocity.y = 0
		jumps_made = 1
		velocity.y -= jump_strength
	if(states.has(ACTION_STATE.DOUBLE_JUMPING)):
		if(jumps_made < maximum_jumps):
			velocity.y = 0
			jumps_made += 1
			velocity.y -= jump_strength
			jump_strength -= jump_weakening
	if(states.has(ACTION_STATE.HIT_THE_GROUND)):
		health -= (previous_velocity.y - velocity.y - max_heigth_that_dont_hurt_character) / 5
#
#func change_turn_state(new_turn_state):
#	if(new_turn_state == turn_state):
#		return
#
#	match new_turn_state:
#		TURN_STATE.STOP:
#			is_active = false
#			shoot_is_visible = false 
#			Mark.visible = true
#		TURN_STATE.MOVE:
#			is_active = true
#			shoot_is_visible = false
#			Mark.visible = true
#		TURN_STATE.AIM: 
#			is_ready = false
#			is_active = false
#			shoot_is_visible = true
#			has_target = false
#			Mark.visible = true
#		TURN_STATE.READY:
#			is_ready = true
#			is_active = false
#			shoot_is_visible = true
#			has_target = true
#			Mark.visible = true
#		TURN_STATE.NOT_ACTIVE:
#			is_active = false
#			shoot_is_visible = false
#			Mark.visible = false
#		_:
#			push_error("Something is wrong ... i can feel it")
#	turn_state = new_turn_state
#
#func damage(attack: int, piercing: int = 0):
#	var damage = attack / (defense - piercing)
#	health -= damage
#	if (health < 0):
#		pass #TODO
#	emit_signal("damage_changed", float(health) /max_health )
