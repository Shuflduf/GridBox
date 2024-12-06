extends Control

signal paused
signal clear
signal reset
signal dimension_changed(new: int)

@onready var list: VBoxContainer = %SettingsList

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("play"):
		_on_pause_pressed()

func _on_pause_pressed() -> void:
	paused.emit()


func _on_reset_pressed() -> void:
	reset.emit()


func _on_clear_pressed() -> void:
	clear.emit()


func _on_dimensions_value_changed(value: float) -> void:
	dimension_changed.emit(roundi(value))
	$Dimensions.get_line_edit().release_focus()
