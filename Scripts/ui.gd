extends Control

signal speed_changed(speed: float)
signal radius_changed(radius: int)
signal survive_range_changed(new_range: Vector2i)
signal reproduction_range_changed(new_range: Vector2i)
signal paused
signal clear

func _on_speed_value_changed(new_value: Variant) -> void:
	speed_changed.emit(new_value)


func _on_clear_pressed() -> void:
	clear.emit()


func _on_radius_value_changed(new_value: Variant) -> void:
	radius_changed.emit(new_value)


func _on_survive_range_changed(new_range: Vector2i) -> void:
	survive_range_changed.emit(new_range)


func _on_reproduction_range_range_changed(new_range: Vector2i) -> void:
	reproduction_range_changed.emit(new_range)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("play"):
		_on_pause_pressed()

func _on_pause_pressed() -> void:
	paused.emit()


func _on_reset_pressed() -> void:
	for i in $VBoxContainer/ScrollContainer/VBoxContainer.get_children():
		if i.has_method("reset_to_default"):
			i.call("reset_to_default")
