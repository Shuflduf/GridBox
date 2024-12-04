extends Control

@onready var label: Label = $Label

signal speed_changed(speed: float)

func _on_speed_value_changed(new_value: Variant) -> void:
	speed_changed.emit(new_value)
