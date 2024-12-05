extends Node2D

var playing = false
var time_since_generation = 0.0

var check_radius = 1
var speed_for_update = 0.2
# Ranges are stored as Vec2i, the x is min, y is max
var survive_range = Vector2i(2, 3)
var reproduction_range = Vector2i(3, 3)


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0,0,0))

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE) or \
				Input.is_action_pressed("move"):
			$Camera.position -= event.screen_relative / $Camera.zoom

	if event is InputEventMouseButton:
		if event.button_index in [MOUSE_BUTTON_WHEEL_DOWN, MOUSE_BUTTON_WHEEL_UP]:
			var zoom_amount = -(event.button_index - 4.5)
			$Camera.zoom = clamp($Camera.zoom + Vector2(zoom_amount, zoom_amount), Vector2(0.5, 0.5), Vector2(100, 100))

func _physics_process(delta: float) -> void:
	if playing:
		time_since_generation += delta
		if time_since_generation >= speed_for_update:
			update_cells()
			time_since_generation = 0.0

func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var pixel_pos = $TileMap.local_to_map(get_global_mouse_position())
		$TileMap.set_cell(pixel_pos, 0, Vector2i(0, 0))

	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		var pixel_pos = $TileMap.local_to_map(get_global_mouse_position())
		$TileMap.erase_cell(pixel_pos)




func _on_ui_speed_changed(speed: float) -> void:
	speed_for_update = speed


func _on_ui_clear() -> void:
	$TileMap.clear()


func _on_ui_radius_changed(radius: int) -> void:
	check_radius = radius


func _on_ui_survive_range_changed(new_range: Vector2i) -> void:
	survive_range = new_range


func _on_ui_reproduction_range_changed(new_range: Vector2i) -> void:
	reproduction_range = new_range


func _on_ui_paused() -> void:
	time_since_generation = 0.0
	playing = !playing
	print("Playing: ", playing)
