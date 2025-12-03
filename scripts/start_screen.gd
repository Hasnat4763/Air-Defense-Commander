extends Control

signal start


func _on_button_pressed() -> void:
	start.emit()
