extends Area2D
@export var SPEED = 100
var shell_speed = 500
@export var leading_indicator: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	leading_indicator = Sprite2D.new()
	add_child(leading_indicator)
	var circle_texture = create_circle_texture(20, Color.GREEN)
	leading_indicator.texture = circle_texture
	leading_indicator.z_index = 10

func _process(delta: float) -> void:
	position.x += delta * SPEED
	if position.x > get_viewport_rect().size.x:
		queue_free()
	update_leading_point()



func create_circle_texture(radius: int, color: Color) -> ImageTexture:
	var image = Image.create(radius*2, radius*2, false, Image.FORMAT_RGBA8)
	for x in range(radius*2):
		for y in range(radius*2):
			var dist = Vector2(x-radius, y-radius).length()
			if dist <= radius and dist >= radius - 3:
				image.set_pixel(x, y, color)
	return ImageTexture.create_from_image(image)
				
				
func update_leading_point():
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		return
	var player_position = player.global_position
	var bomber_pos = global_position
	var to_bomber = bomber_pos - player_position
	
	var distance = to_bomber.length()
	
	var impact_time = distance / (shell_speed - SPEED * to_bomber.normalized().x)

	var leading_point = SPEED * impact_time
	leading_indicator.position.x = leading_point
	leading_indicator.position.y = 0


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("aa_shell"):
		queue_free()
