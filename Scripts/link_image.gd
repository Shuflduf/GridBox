extends TextureRect

@export var url: String

func _ready() -> void:
	gui_input.connect(func(event: InputEvent):
		if event is InputEventMouseButton:
			if event.is_pressed():
				OS.shell_open(url)
	)
