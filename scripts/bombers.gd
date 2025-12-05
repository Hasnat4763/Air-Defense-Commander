extends Area2D
@export var speed = 100
@export var bomb:PackedScene
var bomb_posx = randi_range(20, 940)
var bomb_timer = 0.1
var bomb_dropped = 0
var can_drop = true
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	position.x += delta * speed
	if position.x > 960:
		$bomb_drop_timer.stop()
		queue_free()
	if position.x >= bomb_posx and can_drop:
		if bomb_dropped < 5:
			drop_bombs(position.x, position.y)
			bomb_dropped += 1
func drop_bombs(posx, posy):
	can_drop = false
	var bombs = bomb.instantiate()
	bombs.position.y = posy
	bombs.position.x = posx
	get_tree().current_scene.add_child(bombs)
	$bomb_drop_timer.start(bomb_timer)


func _on_bomb_drop_timer_timeout() -> void:
	can_drop = true
