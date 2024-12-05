class_name GOLSettingsIVec2
extends GOLSettingsBase

@export var value: Vector2i:
	set(new):
		value = clamp(new, Vector2i(range.x, range.x), Vector2i(range.y, range.y))
@export var range: Vector2i:
	set(new):
		range = new
		value = clamp(value, Vector2i(range.x, range.x), Vector2i(range.y, range.y))
