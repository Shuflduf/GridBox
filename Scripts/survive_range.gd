extends VBoxContainer

signal range_changed(range: Vector2i)

@export var current_range = Vector2i(1, 1)
@export var default_value = Vector2i(1, 1)

func _on_radius_value_changed(new_value: Variant) -> void:
	var squared = (((new_value * 2) + 1) ** 2) - 1
	for i in $Min.get_children() + $Max.get_children():
		i.max_value = squared


func _on_min_value_changed(new_value: Variant) -> void:
	current_range.x = new_value
	range_changed.emit(current_range)


func _on_max_value_changed(new_value: Variant) -> void:
	current_range.y = new_value
	range_changed.emit(current_range)

func reset_to_default():
	for i in $Min.get_children():
		i.value = default_value.x
	for i in $Max.get_children():
		i.value = default_value.y
