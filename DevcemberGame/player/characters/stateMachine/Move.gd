extends CharacterState

func handle_input(_event: InputEvent) -> void:
	character.horizontal_direction = Input.get_action_strength("right") - Input.get_action_strength("left")

func physics_update(delta: float) -> void:
	character.execute_state( character.update_state() )
	
	character.velocity.x = lerp(character.velocity.x, character.horizontal_direction * character.speed, 0.2)
	character.velocity.y += character.gravity * delta
	
	character.previous_velocity = character.velocity
	character.velocity = character.move_and_slide(character.velocity, character.UP_DIRECTION)
	
	if(character.previous_velocity.y - character.velocity.y > character.max_heigth_that_dont_hurt_character):
		character.execute_state([character.ACTION_STATE.HIT_THE_GROUND])

func enter() -> void:
	pass

func exit() -> void:
	pass
