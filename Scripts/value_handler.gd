extends HBoxContainer

signal value_changed(new_value)
var default_value: float

func set_ranges(new_min: float, new_max: float):
	for i in get_children():
		i.min_value = new_min
		i.max_value = new_max

func set_step(new_step: float):
	for i in get_children():
		i.step = new_step

func _on_spin_box_value_changed(value: float) -> void:
	$Slider.value = value
	value_changed.emit(value)

func _on_slider_value_changed(value: float) -> void:
	$SpinBox.value = value
	value_changed.emit(value)

func reset_to_default():
	for i in get_children():
		i.value = default_value
