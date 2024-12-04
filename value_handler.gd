extends HBoxContainer

signal value_changed(new_value)


func _on_spin_box_value_changed(value: float) -> void:
	$Slider.value = value
	value_changed.emit(value)

func _on_slider_value_changed(value: float) -> void:
	$SpinBox.value = value
	value_changed.emit(value)
