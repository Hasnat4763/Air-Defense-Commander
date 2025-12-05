extends Node2D

@export var aircrafts: PackedScene
@export var fighter: PackedScene
var aircraft_spawning_interval = 5
var aircraft_interval_timer = 4
var game_running = false
var score = 0
var aircrafts_spawned = 0
var fighters_spawned = 0
var needed_aircraft_bomber = 10
var needed_aircraft_fighter = 10
var shots_fired = 0

func _ready() -> void:
	$StartScreen.start.connect(start_showing_game_story)
	$Story1st.hide()
	$Player.hide()
	$UI.hide()
	$Player.scored.connect(scored)
	$Story1st.start.connect(start_game)
	$Player.shot_fired.connect(shot_fired_calc)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if game_running:
		aircraft_interval_timer += _delta
		if aircraft_interval_timer >= aircraft_spawning_interval:
			spawn_aircrafts()
			spawn_fighters()
			aircraft_interval_timer = 0
		if aircrafts_spawned >= needed_aircraft_bomber:
			end_game()

func start_showing_game_story():
	$StartScreen.hide()
	$Story1st.show()

func start_game():
	$StartScreen.hide()
	$Story1st.hide()
	$Player.show()
	$UI.show()
	random_aircraft_number_gen()
	$Player.game_running = true
	$UI/Score.text = "Score: " + str(score)
	game_running = true

func scored():
	score += 1
	$UI/Score.text = "Score: " + str(score)
	

func spawn_aircrafts():
	var aircraft = aircrafts.instantiate()
	aircraft.position.x = 0
	aircraft.position.y = randi_range(10, 400)
	get_tree().current_scene.add_child(aircraft)
	aircrafts_spawned+=1

func spawn_fighters():
	var fighters = fighter.instantiate()
	fighters.position.x = 0
	fighters.position.y = randi_range(10, 400)
	get_tree().current_scene.add_child(fighters)
	fighters_spawned += 1
	
func shot_fired_calc():
	shots_fired += 1


func end_game():
	game_running = false
	$Player.game_running = false
	$end_screen.show()
	$end_screen/shot_fired.text = "You've fired " + str(shots_fired) + " shots"
	$end_screen/Score.text = "You've Destroyed " + str(score) + " Aircrafts \n from a formation of " + str(needed_aircraft_bomber + needed_aircraft_fighter)
	var percentage = score * 100 / float(shots_fired)
	$end_screen/Conclusion.text = str(percentage) + "% of your shots were a direct hit"
	for i in get_tree().get_nodes_in_group("enemy"):
		i.queue_free()



func random_aircraft_number_gen():
	randomize()
	needed_aircraft_bomber = randi_range(10, 50)
	needed_aircraft_fighter = randi_range(15, 60)
	$UI/Aircrafts_Coming.text = str(needed_aircraft_bomber + needed_aircraft_fighter) + " aircrafts has been spotted coming towards Agartha"
	
