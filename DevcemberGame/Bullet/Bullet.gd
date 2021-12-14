extends Area2D
class_name Bullet

var direction 
var speed
var damage
var piercing

func init(target:Vector2, dmg:int = 5, pierce:int = 0, spd:int = 50):
	direction = position.direction_to(target)
	speed = spd
	damage = dmg
	piercing = pierce

func _physics_process(delta):
	position += direction * speed * delta


func _on_body_entered(body):
	if(body is TileMap):
		queue_free()
