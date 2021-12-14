extends RayCast2D

var target_point := Vector2.ZERO

func _physics_process(_delta):

	if(!get_parent().point_to_shoot):
		if(is_colliding()):
			target_point = get_collision_point() - global_position
		else:
			target_point = cast_to
			
	cast_to = get_local_mouse_position()
	update()
func _draw():
	draw_line(Vector2(0,0), target_point , Color.royalblue)

