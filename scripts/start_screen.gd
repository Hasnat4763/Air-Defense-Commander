extends Control

signal start
signal tutorial


func _on_button_pressed() -> void:
	start.emit()


func _on_button_2_pressed() -> void:
	tutorial.emit()
