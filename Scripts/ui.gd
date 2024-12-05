extends Control

signal paused
signal clear
signal reset

@onready var list: VBoxContainer = %SettingsList

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("play"):
		_on_pause_pressed()

func _on_pause_pressed() -> void:
	paused.emit()


func _on_reset_pressed() -> void:
	reset.emit()
	#for i in list.get_children():
		#if i.has_method("reset_to_default"):
			#i.call("reset_to_default")

func _on_clear_pressed() -> void:
	clear.emit()
