extends Node2D
@export var tutorial_bomber_scene: PackedScene
@export var tutorial_fighter_scene: PackedScene
@export var player_ref: Node2D

var tutorial_stage = 0
var hits_needed = 5
var current_hits = 0
var bomber_spawn_timer_calc = 0
var bomber_interval = 2
var tutorial = false
signal tutorial_end

func _ready() -> void:
	$Player.hide()
	$UI.hide()
	if $Player:
		$Player.scored.connect(aircraft_hit)
		$Player.game_running = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not tutorial:
		return
	
	match tutorial_stage:
		0:
			if Input.is_action_just_pressed("ui_accept"):
				tutorial_stage += 1
				show_stage_text()
		1:
			bomber_spawn_timer_calc += delta
			if bomber_spawn_timer_calc >= bomber_interval:
				spawn_tutorial_bomber()
				bomber_spawn_timer_calc = 0
		2:
			bomber_spawn_timer_calc += delta
			if bomber_spawn_timer_calc >= bomber_interval:
				spawn_tutorial_fighters()
				bomber_spawn_timer_calc = 0
		3:
			complete_tutorial()

func show_stage_text():
	match tutorial_stage:
		0:
			$UI/Tutorial.text = "Welcome to Air Defense Command \n use your mouse to aim \n leftclick to fire \n 'enter' to continue"
			
		1:
			$Player.game_running = true
			$Player.show()
			$UI/Tutorial.text = "In real war you have to figure out where you need to shoot \n for now we are giving you a chance \n shoot at the green circle in front of the aircraft"

		2:
			current_hits = 0
			$UI/Tutorial.text = "Fighters Are Faster Targets so you need more lead"
		3:
			$Player.game_running = false
			$UI/Tutorial.text = "Excellent! You are to be shipped out today."
			for i in get_tree().get_nodes_in_group("tutorial"):
				i.queue_free()
func aircraft_hit():
	if tutorial_stage == 1 or tutorial_stage == 2:
		current_hits += 1
		$UI/Tutorial.text = "Hit"
		$UI/Score.text = "Score: " + str(current_hits)
		if current_hits >= hits_needed and tutorial_stage < 3:
			tutorial_stage += 1
			await get_tree().create_timer(0.5).timeout
			show_stage_text()

func spawn_tutorial_bomber():
	if current_hits >= hits_needed:
		return
	
	var bomber = tutorial_bomber_scene.instantiate()
	bomber.position.x = 0
	bomber.position.y = randi_range(10, 500)
	bomber.add_to_group("enemy")
	add_child(bomber)

func spawn_tutorial_fighters():
	if current_hits >= hits_needed:
		return
	var fighter = tutorial_fighter_scene.instantiate()
	fighter.position.x = 0
	fighter.position.y = randi_range(10, 500)
	fighter.add_to_group("enemy")
	add_child(fighter)

func skip_button_pressed():
	tutorial = false
	queue_free()
func complete_tutorial():
	if Input.is_action_just_pressed("ui_accept"):
		tutorial = false
		tutorial_end.emit()
		queue_free()
