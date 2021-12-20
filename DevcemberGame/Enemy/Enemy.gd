extends KinematicBody2D

signal damage_changed(ratio)

export var maxhealth = 20
export var attackdmg = 10
export var defense = 1

var health: int
   
func damage(attack: int, piercing: int = 0):
	var damage = attack / max(defense - piercing,1)
	health -= damage
	if (health < 0):
		pass
	emit_signal("damage_changed", float(health)/float(maxhealth) )
	print("the signal was sent new health" + str(health))
func _ready():
	health = maxhealth
	emit_signal("damage_changed",1 )

func _on_HitDetector_area_entered(body):
	if body.is_in_group("bullet"):
		damage(body.damage, body.piercing)
