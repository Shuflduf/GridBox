class_name GOLSettingsIVec2
extends GOLSettingsBase

@export var value: Vector2i
@export var value_range: Vector2i

func clamp_value():
	value = clamp(value, Vector2i(value_range.x, value_range.x), Vector2i(value_range.y, value_range.y))
