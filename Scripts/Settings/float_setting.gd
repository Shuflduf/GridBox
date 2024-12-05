class_name GOLSettingsFloat
extends GOLSettingsBase

@export var value: float
@export var value_range: Vector2

func clamp_value():
	value = clamp(value, value_range.x, value_range.y)
