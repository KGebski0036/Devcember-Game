extends KinematicBody2D

signal damage_changed(ratio)

export var maxhealth = 20
export var attackdmg = 10
export var defense = 1

var health: int
   
func damage(attack: int, piercing: int = 0):
	
	var damage = attack / (defense - piercing)
	health -= damage
	if (health < 0):
		pass
	emit_signal("damage_changed", health/maxhealth )

func _ready():
	health = maxhealth

func _on_HitDetector_body_entered(body):
	if(body.is_in_group("bullet")):
		self.damage(body.attack,body.piercing)


func _on_HitDetector_area_entered(bullet):
		if bullet is Bullet:
			damage(bullet.damage, bullet.piercing)
