class_name GOLSettingsIVec2
extends GOLSettingsBase

@export var value: Vector2i:
	set(new):
		value = clamp(new, Vector2i(value_range.x, value_range.x), Vector2i(value_range.y, value_range.y))
@export var value_range: Vector2i:
	set(new):
		value_range = new
		value = clamp(value, Vector2i(value_range.x, value_range.x), Vector2i(value_range.y, value_range.y))
