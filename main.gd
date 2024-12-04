extends Node2D

func _ready() -> void:
	VisualServer.set_default_clear_color(Color(0,0,0))

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
			$Camera.position -= event.screen_relative / $Camera.zoom

	if event is InputEventMouseButton:
		if event.button_index in [MOUSE_BUTTON_WHEEL_DOWN, MOUSE_BUTTON_WHEEL_UP]:
			var zoom_amount = -(event.button_index - 4.5)
			$Camera.zoom = clamp($Camera.zoom + Vector2(zoom_amount, zoom_amount), Vector2(0.5, 0.5), Vector2(50, 50))
