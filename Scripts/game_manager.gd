extends Node

const ENEMY = preload("uid://cowge2t74w0jm")
const LIGHT = preload("uid://crcb7qb4t3a4i")
@onready var combo_timer: Timer = $"../ComboTimer"
@onready var kill_combo_label: Label = $"../CanvasLayer/KillComboLabel"
@onready var light_container: Node2D = $"../Lights"

var kill_combo: int

func _ready() -> void:
	spawn_enemies(5)

func _on_count_down_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/end_screen.tscn")

func spawn_enemies(count):
	for i in range(count):
		var enemy_instance = ENEMY.instantiate()
		get_tree().root.call_deferred("add_child", enemy_instance)
		var spawn_position = Vector2.ZERO
		while spawn_position.distance_to(Vector2.ZERO) < 102:
			spawn_position = Vector2(randi_range(-102,102), randi_range(-102,102))
		enemy_instance.global_position = spawn_position
		
		enemy_instance.connect("enemy_killed", _on_enemy_killed)

func _on_spawn_timer_timeout() -> void:
	spawn_enemies(5)

func start_new_light():
	var light_instance = LIGHT.instantiate() as Node2D
	light_container.call_deferred("add_child", light_instance)
	var light_position := Vector2.ZERO
	while Vector2.ZERO.distance_to(light_position) < 200 and light_container.distance_to:
		light_position = Vector2(randi_range(-205, 205), randi_range(-205, 205))
	light_instance.global_position = light_position

func _on_enemy_killed(kill_points: int):
	combo_timer.start()
	kill_combo += kill_points
	kill_combo_label.text = str(kill_combo)
	if kill_combo >= 5:
		start_new_light()
		kill_combo = 0


func _on_combo_timer_timeout() -> void:
	kill_combo = 0
	kill_combo_label.text = str(kill_combo)
