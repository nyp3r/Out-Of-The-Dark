extends Area2D
class_name GrenadeArea

var bodies_in_area: Array[Node2D]
var color_transparency := 0.0
var grenade_launched := false
var launched_position: Vector2

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		bodies_in_area.append(body) 

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		for i in bodies_in_area:
			if i == body:
				bodies_in_area.erase(i)

func _process(delta: float) -> void:
	if not grenade_launched:
		global_position = get_global_mouse_position()
	else: global_position = launched_position

func _draw() -> void:
	draw_circle(Vector2.ZERO, 16, Color(255, 0, 0, color_transparency))
