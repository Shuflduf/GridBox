extends Control

@onready var label: Label = $Label

signal speed_changed(speed: float)
signal radius_changed(radius: int)
signal survive_range_changed(new_range: Vector2i)
signal reproduction_range_changed(new_range: Vector2i)
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
