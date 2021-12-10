extends Area2D

var direction 
var speed
var damage


func init(target:Vector2, dmg:int = 5, spd:int = 5):
	direction = position.direction_to(target)
	speed = spd
	damage = dmg

func _physics_process(delta):
	position += direction * speed * delta
