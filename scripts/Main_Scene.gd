extends Node2D

@export var scene: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$StartScreen.start.connect(start_game)
	$Radar.hide()
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var current_frame = $Radar/radar.get_frame()
	
func locked():
	$Radar/Label.text = "Tracking"
	$Radar/Label.add_theme_color_override("font_color", Color(0.69, 0.0, 0.093, 1.0))
	
func not_locked():
	$Radar/Label.text = "Not Tracking"
	$Radar/Label.add_theme_color_override("font_color", Color(0.0, 0.507, 0.099, 1.0))


func _on_fired() -> void:
	locked()
	
func spawn_enemy():
	pass
	
	
	
func start_game():
	$StartScreen.hide()
	$Radar.show()
	$Radar/radar.play()
	
