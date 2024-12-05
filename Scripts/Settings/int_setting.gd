class_name GOLSettingsInt
extends GOLSettingsBase

@export var value: int:
	set(new):
		value = clamp(new, range_min, range_max)
@export var range_min: int:
	set(new):
		range_min = new
		value = clamp(value, range_min, range_max)
@export var range_max: int:
	set(new):
		range_max = new
		value = clamp(new, range_min, range_max)
