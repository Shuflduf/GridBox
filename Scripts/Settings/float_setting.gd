class_name GOLSettingsFloat
extends GOLSettingsBase

@export var value: float:
	set(new):
		value = clamp(new, value_range.x, value_range.y)
@export var value_range: Vector2:
	set(new):
		value_range = new
		value = clamp(value, value_range.x, value_range.y)
