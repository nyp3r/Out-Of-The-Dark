extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		var enemy = body as Enemy
		if enemy.target == null:
			enemy.target = get_tree().get_first_node_in_group("Player")
