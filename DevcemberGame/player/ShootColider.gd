extends RayCast2D

var is_visible = false
var point 


func _physics_process(_delta):
	cast_to = get_local_mouse_position()
	update()

	if(is_colliding()):
		point = get_collision_point() - global_position
	else:
		point = cast_to
func _draw():
	if is_visible: draw_line(Vector2(0,0), point , Color.royalblue)

