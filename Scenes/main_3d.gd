extends Node3D

@onready var gridmap: GridMap = $GridMap
@onready var camera: Camera3D = $Camera3D

@export var settings: Array[GOLSettings]
var default_settings: Array[GOLSettings]

var time_since_generation = 0.0

var playing = true
var check_radius = 1
var speed_for_update = 0.2
# Ranges are stored as Vec2i, the x is min, y is max
var survive_range = Vector2i(2, 3)
var reproduction_range = Vector2i(3, 3)

func _ready() -> void:
	default_settings = settings
	update_settings(settings)
	#for i in settings:
		#var new_label = Label.new()
		#new_label.text = i.value_name
		#%SettingsList.add_child(new_label)
		#match i.value_type:
			#"float":
				#var value_handler = FloatValue.new()
				#value_handler.set_ranges()


func update_settings(new_settings: Array[GOLSettings]):
	for i in new_settings:
		set(i.property_name, i.value[0])


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
	playing = !playing
