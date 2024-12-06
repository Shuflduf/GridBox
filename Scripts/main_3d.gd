extends Node3D

@onready var gridmap: GridMap = $GridMap
@onready var camera: Camera3D = $CamPivot/Camera3D
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
var dimension: int = 2

var value_handlers = {}

func _ready() -> void:
	for i in settings:
		default_settings.append(i.duplicate(true))

	for i in settings:
		var new_label = Label.new()
		new_label.text = i.value_name
		$UI.list.add_child(new_label)
		if (i is GOLSettingsFloat) or (i is GOLSettingsInt):
			var value_handler = preload("res://Scenes/value_handler.tscn").instantiate()
			value_handler.set_step(0.1 if (i is GOLSettingsFloat) else 1.0)
			value_handler.set_ranges(i.value_range.x, i.value_range.y)
			value_handler.default_value = i.value
			value_handler.reset_to_default()
			value_handler.set_values(i.value)
			value_handler.value_changed.connect(func(new_value):
				i.value = new_value
				set(i.property_name, new_value)
			)
			if i.property_name == "check_radius":
				value_handler.value_changed.connect(change_radius_dependencies)
			$UI.list.add_child(value_handler)
			value_handlers[i.property_name] = value_handler
		elif i is GOLSettingsIVec2:
			var min_value_handler = preload("res://Scenes/value_handler.tscn").instantiate()
			var max_value_handler = preload("res://Scenes/value_handler.tscn").instantiate()

			for handler in [min_value_handler, max_value_handler]:
				handler.set_step(1)
				handler.set_ranges(i.value_range.x, i.value_range.y)
				handler.reset_to_default()
				$UI.list.add_child(handler)
			min_value_handler.value_changed.connect(func(new_value):
				var vec = get(i.property_name)
				vec.x = new_value
				set(i.property_name, vec)
			)
			max_value_handler.value_changed.connect(func(new_value):
				var vec = get(i.property_name)
				vec.y = new_value
				set(i.property_name, vec)
			)

			min_value_handler.default_value = i.value.x
			max_value_handler.default_value = i.value.y
			min_value_handler.reset_to_default()
			max_value_handler.reset_to_default()
			value_handlers[i.property_name + "x"] = min_value_handler
			value_handlers[i.property_name + "y"] = max_value_handler

	update_settings(settings)


func change_radius_dependencies(new_radius):
	var diam = ((2 * new_radius) + 1) ** 2
	for i in get_radius_dependencies():
		var ranges = [value_handlers[i.property_name + "x"], value_handlers[i.property_name + "y"]]
		for j in ranges:
			j.set_ranges(1, diam)
		for s in settings:
			if s.property_name == i.property_name:
				s.value_range = Vector2i(1, diam)


func get_radius_dependencies() -> Array[GOLSettingsBase]:
	return settings.filter(func(setting: GOLSettingsBase):
		return setting.property_name in ["survive_range", "reproduction_range"])


func update_settings(new_settings: Array[GOLSettingsBase], after_ready = false):
	for i in new_settings:
		i.clamp_value()
		set(i.property_name, i.value)
		if after_ready:
			if i is GOLSettingsIVec2:
				value_handlers[i.property_name + "x"].reset_to_default()
				value_handlers[i.property_name + "y"].reset_to_default()
			else:
				value_handlers[i.property_name].reset_to_default()


func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		gridmap.set_cell_item(mouse_world_pos(), -1)

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		gridmap.set_cell_item(mouse_world_pos(), 0)


func _physics_process(delta: float) -> void:
	if playing:
		time_since_generation += delta
		if time_since_generation >= speed_for_update:
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
	var t = plane.intersects_ray(ray_origin, ray_direction)
	var world_position = floor(t) if t != null else Vector3.ZERO
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
	playing = !playing


func _on_ui_clear() -> void:
	gridmap.clear()


func _on_ui_reset() -> void:
	settings = default_settings.duplicate(true)
	update_settings(settings, true)



func _on_ui_dimension_changed(new: int) -> void:
	dimension = new
