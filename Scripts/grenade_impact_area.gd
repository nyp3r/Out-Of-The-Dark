extends Area2D

var damage := 2
var bodies_in_area: Array[Enemy]
@onready var impact_sound: AudioStreamPlayer2D = $ImpactSound
@onready var explosion_animation: AnimatedSprite2D = $ExplosionAnimation
var transparency := 0.5

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		bodies_in_area.append(body) 

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		for i in bodies_in_area:
			if i == body:
				bodies_in_area.erase(i)

func _draw() -> void:
	draw_circle(Vector2.ZERO, 16, Color(255, 0, 0, transparency)) 


func _on_timer_timeout() -> void:
	impact_sound.play()
	explosion_animation.visible = true
	explosion_animation.play()
	transparency = 0
	queue_redraw()
	for body in bodies_in_area:
		body.take_damage(damage)


func _on_impact_sound_finished() -> void:
	queue_free()


func _on_explosion_animation_animation_finished() -> void:
	await get_tree().create_timer(0.05).timeout
	explosion_animation.visible = false
