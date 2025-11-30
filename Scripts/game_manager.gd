extends Node
class_name GameManager

var score := 0

const END_SCREEN = preload("uid://6cp1xfijh1jf")
const ENEMY = preload("uid://cowge2t74w0jm")
const LIGHT = preload("uid://crcb7qb4t3a4i")
const LIGHT_RADIUS = 64
const MAIN_LIGHT_RADIUS = 96
var spawn_count = 5

@onready var combo_timer: Timer = $"../ComboTimer"
@onready var kill_combo_label: Label = $"../CanvasLayer/KillComboLabel"
@onready var score_label: Label = $"../CanvasLayer/ScoreLabel"
@onready var score_animation: AnimationPlayer = %ScoreAnimation
@onready var kill_combo_indicator: AnimatedSprite2D = %KillComboIndicator
@onready var combo_decrease_timer: Timer = $"../ComboDecreaseTimer"

var kill_combo: int

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and not get_tree().paused:
		get_tree().paused = true
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		get_tree().paused = false

func _ready() -> void:
	spawn_enemies.call_deferred(spawn_count, Vector2.ZERO, MAIN_LIGHT_RADIUS)

func _on_count_down_timer_timeout() -> void:
	Scores.append_score(score * get_tree().get_nodes_in_group("Lights").size() + 1)
	get_tree().change_scene_to_packed(END_SCREEN)

func spawn_enemies(count: int, center: Vector2, radius: float): #to be figured out
	for i in range(count):
		var enemy_instance = ENEMY.instantiate()
		get_tree().current_scene.add_child(enemy_instance)
		
		# Spawn randomly from a point in a circle
		var angle: float = randf_range(0.0, TAU)
		var vec: Vector2 = Vector2.RIGHT
		enemy_instance.global_position = (vec * radius).rotated(angle) + center
		
		enemy_instance.connect("enemy_killed", _on_enemy_killed)


func _on_spawn_timer_timeout() -> void:
	spawn_enemies(spawn_count, Vector2.ZERO, MAIN_LIGHT_RADIUS) 
	for child in get_tree().get_nodes_in_group("Lights") as Array[Node2D]:
		spawn_enemies(spawn_count, child.global_position, LIGHT_RADIUS)

func spawn_light():
	var light_instance = LIGHT.instantiate() as Node2D
	get_tree().current_scene.add_child.call_deferred(light_instance)
	light_instance.connect("light_died", _on_light_died)
	light_instance.add_to_group("Lights") 
	while true:
		var angle: float = randf_range(0.0, TAU)
		var vec: Vector2 = Vector2.RIGHT
		light_instance.global_position = (vec * 205).rotated(angle)
		if get_closest_light_distance(light_instance.global_position) > LIGHT_RADIUS:
			break

func _on_enemy_killed(kill_points: int):
	var lights_multiplier = get_tree().get_nodes_in_group("Lights").size() + 1
	score += kill_points
	score_label.text = str(score * lights_multiplier, " x", lights_multiplier)
	combo_timer.start()
	combo_decrease_timer.stop()
	kill_combo += kill_points
	kill_combo_label.text = str(kill_combo)
	if kill_combo >= 5:
		score_animation.play("kill_combo")
		spawn_light()
		kill_combo = 0
	kill_combo_indicator.frame = kill_combo

func _on_combo_timer_timeout() -> void:
	kill_combo -= 1
	combo_decrease_timer.start()
	kill_combo_indicator.frame = kill_combo
	kill_combo_label.text = str(kill_combo)

func get_closest_light_distance(position: Vector2) -> float:
	var closest_light := Vector2.ZERO
	var closest_distance := 999999.9
	for light in get_tree().get_nodes_in_group("Lights"): 
		light = light as Node2D
		if light.global_position.distance_to(position) < closest_distance:
			closest_light = light.global_position
			closest_distance = light.global_position.distance_to(position)
	return closest_distance

func _on_light_died():
	var lights_multiplier = get_tree().get_nodes_in_group("Lights").size() + 1
	score_label.text = str(score * lights_multiplier, " x", lights_multiplier)


func _on_combo_decrease_timer_timeout() -> void:
	kill_combo -= 1
	kill_combo_indicator.frame = kill_combo
	kill_combo_label.text = str(kill_combo)
	if kill_combo == 0:
		combo_decrease_timer.stop()
