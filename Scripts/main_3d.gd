extends Node3D

@onready var gridmap: GridMap = $GridMap
@onready var camera: Camera3D = $Camera3D

@export var settings: Array[GOLSettingsBase]
var default_settings: Array[GOLSettingsBase]

var time_since_generation = 0.0

var playing = true

var check_radius: int
var speed_for_update: float:
	set(new):
		speed_for_update = new
		time_since_generation = 0.0
var survive_range: Vector2i
var reproduction_range: Vector2i

func _ready() -> void:
	default_settings = settings
	
	for i in settings:
		#print(i.value_name, i.value)
		var new_label = Label.new()
		new_label.text = i.value_name
		$UI.list.add_child(new_label)
		if (i is GOLSettingsFloat) or (i is GOLSettingsInt):
			var value_handler = preload("res://Scenes/value_handler.tscn").instantiate()
			print(i.value)
			value_handler.set_step(0.1 if i is GOLSettingsFloat else 1.0)
			value_handler.set_ranges(i.range_min, i.range_max)
			value_handler.default_value = i.value
			value_handler.reset_to_default()
			value_handler.value_changed.connect(func(new_value):
				i.value = new_value
				#print("Set ", i.property_name, " to ", new_value)
				set(i.property_name, new_value)
				#print(new_value)
			)
			$UI.list.add_child(value_handler)
			
	update_settings(settings)


func update_settings(new_settings: Array[GOLSettingsBase]):
	for i in new_settings:
		set(i.property_name, i.value)


func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		gridmap.set_cell_item(mouse_world_pos(), -1)
#
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		gridmap.set_cell_item(mouse_world_pos(), 0)


func _physics_process(delta: float) -> void:
	if playing:
		time_since_generation += delta
		if time_since_generation >= speed_for_update:
			print("Run")
			var new_cells = get_new_cells()
			gridmap.clear()
			for i in new_cells:
				gridmap.set_cell_item(i, 0)
			time_since_generation = 0.0


func mouse_world_pos() -> Vector3i:
	var mouse_position = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_position)
	var ray_direction = camera.project_ray_normal(mouse_position)
	var plane = Plane(Vector3(0, 1, 0), 0)
	var world_position = floor(plane.intersects_ray(ray_origin, ray_direction))
	return world_position

func get_new_cells():
	var alive_cells = gridmap.get_used_cells()
	var calculating_cell_pos = get_all_useful_cells()
	var new_cell_pos: Array[Vector3i] = []
	for cell in calculating_cell_pos:
		var square = range(-check_radius, check_radius + 1)
		var neighbor_count = 0
		for x in square:
			for y in square:
				var check_pos = cell + Vector3i(x, 0, y)
				if check_pos != cell:
					if check_pos in alive_cells:
						neighbor_count += 1
		if cell in alive_cells:
			if neighbor_count in range(survive_range.x, survive_range.y + 1):
				new_cell_pos.append(cell)
		else:
			if neighbor_count in range(reproduction_range.x, reproduction_range.y + 1):
				new_cell_pos.append(cell)
	
	return new_cell_pos


func get_all_useful_cells() -> Array[Vector3i]:
	var alive_cells = gridmap.get_used_cells()
	var final: Array[Vector3i] = alive_cells.duplicate()
	for cell in alive_cells:
		var square = range(-check_radius, check_radius + 1)
		for x in square:
			for y in square:
				var check_pos = cell + Vector3i(x, 0, y)
				if check_pos not in final:
					final.append(check_pos)
	
	return final


func _on_ui_paused() -> void:
	print(playing)
	playing = !playing


func _on_ui_clear() -> void:
	gridmap.clear()
