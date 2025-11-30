extends StaticBody2D
class_name Light

signal light_died
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
const MAX_HEALTH := 8
var current_health := MAX_HEALTH

func _ready() -> void:
	animation_player.play("point_light")
	animated_sprite_2d.play_backwards()

func take_damage(damage):
	current_health -= damage
	animated_sprite_2d.frame = MAX_HEALTH - current_health
	if current_health <= 0:
		light_died.emit()
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		var enemy = body as Enemy
		enemy.target = self


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.queue_free()
