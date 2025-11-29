extends StaticBody2D
class_name Light

signal light_died

const MAX_HEALTH := 5
var current_health := MAX_HEALTH

func take_damage(damage):
	current_health -= damage
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
