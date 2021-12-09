extends RayCast2D

var point 

func _physics_process(_delta):

	if(!get_parent().point_to_shoot):
		if(is_colliding()):
			point = get_collision_point() - global_position
		else:
			point = cast_to
			
	cast_to = get_local_mouse_position()
	update()
func _draw():
	if(point):
		 draw_line(Vector2(0,0), point , Color.royalblue)

