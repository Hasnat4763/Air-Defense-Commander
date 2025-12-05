extends Node2D
var Rotation_Speed = 5
var can_shoot = true
var firing_rate = 1
@export var Projectile_Scene : PackedScene
var game_running = false
signal scored
signal shot_fired

func _ready() -> void:
	$Sprite2D2.hide()

func _process(_delta: float) -> void:
	if game_running:
		var mouse_pos = get_global_mouse_position()
		look_at(mouse_pos)
		if Input.is_action_pressed("fire") and can_shoot:
			shoot()
func shoot():
	$Sprite2D.hide()
	$Sprite2D2.show()
	can_shoot = false
	var projectile = Projectile_Scene.instantiate()
	projectile.global_position = $Muzzle.global_position
	projectile.rotation = rotation
	projectile.hit.connect(air_hit)
	get_parent().add_child(projectile)
	$Firing_rate.start(firing_rate)
	shot_fired.emit()
	
func _on_firing_rate_timeout() -> void:
	can_shoot = true
	$Sprite2D.show()
	$Sprite2D2.hide()

func air_hit():
	scored.emit()
