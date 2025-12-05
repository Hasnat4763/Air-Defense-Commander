extends Area2D
@export var SPEED = 200
var hit = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not hit:
		position.x += delta * SPEED
		if position.x > get_viewport_rect().size.x:
			queue_free()
	else:
		position.y += delta * 100
		position.x += 1
		if position.y > get_viewport_rect().size.y:
			queue_free()
	


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("aa_shell"):
		hit = true
