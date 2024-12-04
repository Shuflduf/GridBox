extends Node2D

var playing = false:
	set(value):
		playing = value
		$CanvasLayer/UI.label.visible = !value

var generation_update = 1.0
var time_generation = 0.0

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0,0,0))

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
			$Camera.position -= event.screen_relative / $Camera.zoom

	if event is InputEventMouseButton:
		if event.button_index in [MOUSE_BUTTON_WHEEL_DOWN, MOUSE_BUTTON_WHEEL_UP]:
			var zoom_amount = -(event.button_index - 4.5)
			$Camera.zoom = clamp($Camera.zoom + Vector2(zoom_amount, zoom_amount), Vector2(0.5, 0.5), Vector2(100, 100))

func _physics_process(delta: float) -> void:
	if playing:
		time_generation += delta
		if time_generation >= generation_update:
			update_cells()
			time_generation = 0.0

func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var pixel_pos = $TileMap.local_to_map(get_global_mouse_position())
		$TileMap.set_cell(pixel_pos, 0, Vector2i(0, 0))

	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		var pixel_pos = $TileMap.local_to_map(get_global_mouse_position())
		$TileMap.erase_cell(pixel_pos)

	if Input.is_action_just_pressed("play"):
		playing = !playing
		print("Playing: ", playing)

func update_cells():
	var tilemap: TileMapLayer = $TileMap
	var alive_cells = tilemap.get_used_cells()
	var calculating_cell_pos = get_all_useful_cells()
	var new_cell_pos: Array[Vector2i] = []
	for cell in calculating_cell_pos:
		print(cell)
		var radius = 1
		var square = range(-radius, radius + 1)
		var neighbor_count = 0
		for x in square:
			for y in square:
				var check_pos = cell + Vector2i(x, y)
				print("Checking: ", check_pos)
				if check_pos != cell:
					if check_pos in alive_cells:
						neighbor_count += 1
		if cell in alive_cells:
			if neighbor_count in range(2, 3 + 1):
				new_cell_pos.append(cell)
		else:
			if neighbor_count == 3:
				new_cell_pos.append(cell)
	
	tilemap.clear()
	for i in new_cell_pos:
		tilemap.set_cell(i, 0, Vector2i(0, 0))

func get_all_useful_cells() -> Array[Vector2i]:
	var tilemap: TileMapLayer = $TileMap
	var alive_cells = tilemap.get_used_cells()
	var final: Array[Vector2i] = alive_cells
	for cell in alive_cells:
		var radius = 1
		var square = range(-radius, radius + 1)
		for x in square:
			for y in square:
				var check_pos = cell + Vector2i(x, y)
				print(check_pos)
				if !check_pos in final:
					final.append(check_pos)
	
	print(final)
	return final
