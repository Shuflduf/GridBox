class_name GOLSettingsInt
extends GOLSettingsBase

@export var value: int:
	set(new):
		value = clamp(new, value_range.x, value_range.y)
@export var value_range: Vector2i:
	set(new):
		value_range = new
		value = clamp(value, value_range.x, value_range.y)
