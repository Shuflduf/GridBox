extends VBoxContainer

signal range_changed(range: Vector2i)

var range = Vector2i(2, 3)

func _on_radius_value_changed(new_value: Variant) -> void:
	var squared = (((new_value * 2) + 1) ** 2) - 1
	for i in $Min.get_children() + $Max.get_children():
		i.max_value = squared


func _on_min_value_changed(new_value: Variant) -> void:
	range.x = new_value
	range_changed.emit(range)


func _on_max_value_changed(new_value: Variant) -> void:
	range.y = new_value
	range_changed.emit(range)
