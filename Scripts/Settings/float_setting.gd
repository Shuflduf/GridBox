class_name GOLSettingsFloat
extends GOLSettingsBase

@export var value: float:
	set(new):
		value = clamp(new, range.x, range.y)
@export var range: Vector2:
	set(new):
		range = new
		value = clamp(value, range.x, range.y)
