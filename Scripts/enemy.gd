extends CharacterBody2D
class_name Enemy


@export var data: EnemyData
var current_health: int

var player: Player

@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var game_manager: Node = %GameManager

signal enemy_killed(kill_points: int)

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	attack_cooldown_timer.wait_time = data.attack_speed
	current_health = data.max_health

func _physics_process(_delta: float) -> void:
	if player:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * data.speed
		move_and_slide()
		look_at(player.global_position)

func take_damage(damage: int):
	current_health -= damage
	if current_health <= 0:
		enemy_killed.emit((data.attack_speed + data.damage + float(data.max_health)/2 + data.speed/25) / 4)
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		attack_cooldown_timer.start()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		attack_cooldown_timer.stop()


func _on_attack_cooldown_timer_timeout() -> void:
	player.take_damage(data.damage)
