extends Area2D
@export var SPEED = 200
var shell_speed = 500
@onready var leading_indicator: Sprite2D = $leading_indicator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(leading_indicator)
	leading_indicator.z_index = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += delta * SPEED
	if position.x >= get_viewport_rect().size.x:
		queue_free()
	update_leading_point()
	
func update_leading_point():
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		return
	var player_pos = player.global_position
	var fighter_pos = global_position
	var to_fighter = fighter_pos - player_pos
	var d = to_fighter.length()
	var impact_time = d / (shell_speed - SPEED * to_fighter.normalized().x)
	var leading_point = SPEED * impact_time
	leading_indicator.position.x = leading_point
	leading_indicator.position.y = 0


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("aa_shell"):
		queue_free()
