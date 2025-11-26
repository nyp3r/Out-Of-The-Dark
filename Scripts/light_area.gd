extends StaticBody2D
class_name Light

const MAX_HEALTH := 5
var current_health := MAX_HEALTH

func take_damage(damage):
	current_health -= damage
	if current_health <= 0:
		queue_free()
