class_name GOLSettingsFloat
extends GOLSettingsBase

@export var value: float:
	set(new):
		value = clamp(new, range_min, range_max)
@export var range_min: float:
	set(new):
		range_min = new
		value = clamp(value, range_min, range_max)
@export var range_max: float:
	set(new):
		range_max = new
		value = clamp(new, range_min, range_max)
