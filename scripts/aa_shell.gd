extends Area2D
var SPEED = 500
var velocity = Vector2.ZERO
signal hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = Vector2.RIGHT.rotated(rotation) * SPEED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta
	rotation = velocity.angle()
	if position.y > get_viewport_rect().size.y + 100:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		hit.emit()
		queue_free()
