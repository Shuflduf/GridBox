extends Control

signal paused
signal clear
signal value_changed(value_name: String, value: Variant)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("play"):
		_on_pause_pressed()

func _on_pause_pressed() -> void:
	paused.emit()


func _on_reset_pressed() -> void:
	for i in $VBoxContainer/ScrollContainer/VBoxContainer.get_children():
		if i.has_method("reset_to_default"):
			i.call("reset_to_default")
