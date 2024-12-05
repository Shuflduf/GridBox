class_name GOLSettingsInt
extends GOLSettingsBase

@export var value: int:
	set(new):
		value = clamp(new, range.x, range.y)
@export var range: Vector2i:
	set(new):
		range = new
		value = clamp(value, range.x, range.y)
