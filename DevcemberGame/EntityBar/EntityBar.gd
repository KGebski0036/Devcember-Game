extends TextureProgress

func _ready():
	pass

func _on_Enemy_damage_changed(ratio):
	value = ratio
