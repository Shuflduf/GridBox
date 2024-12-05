extends HBoxContainer

signal value_changed(new_value)
@export var default_value: float

func _on_spin_box_value_changed(value: float) -> void:
	$Slider.value = value
	value_changed.emit(value)

func _on_slider_value_changed(value: float) -> void:
	$SpinBox.value = value
	value_changed.emit(value)

func reset_to_default():
	for i in get_children():
		i.value = default_value
