class_name GOLSettingsIVec2
extends GOLSettingsBase

@export var value: Vector2i:
	set(new):
		value = clamp(new, range_min, range_max)
@export var range_min: Vector2i:
	set(new):
		range_min = new
		value = clamp(value, range_min, range_max)
@export var range_max: Vector2i:
	set(new):
		range_max = new
		value = clamp(new, range_min, range_max)
