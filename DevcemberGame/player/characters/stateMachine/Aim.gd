extends CharacterState

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func enter() -> void:
	character.Mark.visible = true
	character.ShootColider.visible = true

func exit() -> void:
	character.Mark.visible = false
	character.ShootColider.visible = false
