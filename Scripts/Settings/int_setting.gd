class_name GOLSettingsInt
extends GOLSettingsBase

@export var value: int
@export var value_range: Vector2i

func clamp_value():
	value = clamp(value, value_range.x, value_range.y)
