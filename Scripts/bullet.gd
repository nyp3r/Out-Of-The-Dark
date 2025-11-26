extends Area2D
class_name Bullet

var damage := 1
const SPEED := 300

func _process(delta: float) -> void:
	position += transform.x * SPEED * delta


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("Enemy"):
		var enemy = body as Enemy
		enemy.take_damage(damage)
	queue_free()
