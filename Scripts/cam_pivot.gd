extends Camera3D

var last_mouse_position = Vector2()
var dragging = false
var initial_world_position = Vector3()

var dimension: int = 2

func _unhandled_input(event: InputEvent) -> void:
	if dimension == 2:
		if event is InputEventMouseMotion:
			if dragging:
				var new_world_position = get_project_position(event.position, 0)
				var offset = initial_world_position - new_world_position
				position += offset

		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_MIDDLE:
				if event.pressed:
					dragging = true
					var mouse_position = event.position
					initial_world_position = get_project_position(mouse_position, 0)
				else:
					dragging = false

			elif event.button_index in [MOUSE_BUTTON_WHEEL_DOWN, MOUSE_BUTTON_WHEEL_UP]:
				var zoom_amount = -1 if event.button_index == MOUSE_BUTTON_WHEEL_UP else 1
				size = clamp(size + zoom_amount, 0.5, 100)
				
				# Adjust position to keep the cursor in the same world position
				var mouse_position = get_viewport().get_mouse_position()
				var world_position_before = get_project_position(mouse_position, 0)
				var world_position_after = get_project_position(mouse_position, 0)
				position += world_position_before - world_position_after
	elif dimension == 3:
		pass
		

func get_project_position(screen_position: Vector2, plane_y: float) -> Vector3:
	var ray_origin = project_ray_origin(screen_position)
	var ray_direction = project_ray_normal(screen_position)
	var plane = Plane(Vector3(0, 1, 0), plane_y)
	return plane.intersects_ray(ray_origin, ray_direction)


func _on_ui_dimension_changed(new: int) -> void:
	const TWO_D_POS = Vector3(0, 5, 0)
	const THREE_D_POS = Vector3(0, 5, 5)
	dimension = new
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position", TWO_D_POS if new == 2 else THREE_D_POS, 0.5)
	tween.parallel().tween_property(self, "rotation_degrees:x", -90 if new == 2 else -45, 0.5)
