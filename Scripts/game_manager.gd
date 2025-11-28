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

var kill_combo: int

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	spawn_enemies(spawn_count, Vector2.ZERO, 10) 
	print_debug("test")

func _on_count_down_timer_timeout() -> void:
	Scores.append_score(score)
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
	var light_position := Vector2.ZERO
	while get_closest_light_distance(light_position) < LIGHT_RADIUS or Vector2.ZERO.distance_to(light_position) < 200:
		light_position = Vector2(randi_range(-205, 205), randi_range(-205, 205))
	if light_position == Vector2.ZERO:
		light_instance.queue_free()
		return
	light_instance.global_position = light_position

func _on_enemy_killed(kill_points: int):
	score += kill_points
	score_label.text = str(score * (get_tree().get_nodes_in_group("Lights").size() + 1))
	combo_timer.start()
	kill_combo += kill_points
	kill_combo_label.text = str(kill_combo)
	if kill_combo >= 5:
		spawn_light()
		kill_combo = 0

func _on_combo_timer_timeout() -> void:
	kill_combo = 0
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
	score_label.text = str(score * (get_tree().get_nodes_in_group("Lights").size() + 1))
