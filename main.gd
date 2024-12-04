extends Node2D

var playing = false

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0,0,0))

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
			$Camera.position -= event.screen_relative / $Camera.zoom

	if event is InputEventMouseButton:
		if event.button_index in [MOUSE_BUTTON_WHEEL_DOWN, MOUSE_BUTTON_WHEEL_UP]:
			var zoom_amount = -(event.button_index - 4.5)
			$Camera.zoom = clamp($Camera.zoom + Vector2(zoom_amount, zoom_amount), Vector2(0.5, 0.5), Vector2(50, 50))

func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var pixel_pos = $TileMap.local_to_map(get_global_mouse_position())
		$TileMap.set_cell(pixel_pos, 0, Vector2i(0, 0))

	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		var pixel_pos = $TileMap.local_to_map(get_global_mouse_position())
		$TileMap.erase_cell(pixel_pos)

	if Input.is_action_just_pressed("play"):
		playing = !playing
		print(playing)
