extends CharacterBody2D
class_name Enemy


@export var data: EnemyData
var current_health: int

var target: Node2D

@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer

var in_attack_range := false

signal enemy_killed(kill_points: int)

func get_closest_target() -> Node2D:
	var targets := get_tree().get_nodes_in_group("Lights")
	targets.append(get_tree().get_first_node_in_group("Player"))
	var closest_node: Node2D
	var closest_distance: float = INF 
	for child in targets as Array[Node2D]: 
		var target_distance = child.global_position.distance_to(global_position)
		if target_distance < closest_distance:
			closest_node = child
			closest_distance = target_distance
	return closest_node

func _ready() -> void:
	await get_tree().create_timer(0.01).timeout
	target = get_closest_target()
	attack_cooldown_timer.wait_time = data.attack_speed
	current_health = data.max_health

func _physics_process(_delta: float) -> void:
	if target:
		var direction = global_position.direction_to(target.global_position)
		velocity = direction * data.speed
		move_and_slide()
		look_at(target.global_position)
	else: queue_free()

func take_damage(damage: int):
	current_health -= damage
	if current_health <= 0:
		enemy_killed.emit((data.attack_speed + data.damage + float(data.max_health)/2 + data.speed/25) / 4)
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") or body.is_in_group("Lights"):
		attack_cooldown_timer.start()
		in_attack_range = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") or body.is_in_group("Lights"):
		attack_cooldown_timer.stop()
		in_attack_range = false


func _on_attack_cooldown_timer_timeout() -> void:
	if in_attack_range:
		target.take_damage(data.damage)
		attack_cooldown_timer.start()
