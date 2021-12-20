extends CharacterState


func physics_update(delta: float) -> void:
	character.velocity.x = lerp(character.velocity.x, 0, 0.4)
	character.velocity.y += character.gravity * delta
	character.velocity = character.move_and_slide(character.velocity, character.UP_DIRECTION)

func enter() -> void:
	character.Mark.visible = false

func exit() -> void:
	character.Mark.visible = true
