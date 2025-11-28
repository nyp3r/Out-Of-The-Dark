extends Area2D
class_name Bullet

@onready var bullet_sprite: AnimatedSprite2D = $BulletSprite

var damage := 1
const SPEED := 300

var time_alive := 0.0

func _process(delta: float) -> void:
	time_alive += delta
	if time_alive > 0.5:
		queue_free()
	position += transform.x * SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		var enemy = body as Enemy
		enemy.take_damage(damage, true)
	queue_free()
