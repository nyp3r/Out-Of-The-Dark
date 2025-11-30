extends State

const BULLET = preload("uid://blgiurjj48f67")
@onready var uzi_sprite: AnimatedSprite2D = %UziSprite
@onready var uzi_spray_speed_timer: Timer = %UziSpraySpeedTimer
@onready var uzi_spray_audio: AudioStreamPlayer2D = %UziSprayAudio
@onready var shooting_point: Marker2D = %ShootingPoint
@onready var shooting_anchor: Node2D = $"../../ShootingAnchor" 

func enter():
	uzi_sprite.visible = true

func exit():
	uzi_sprite.visible = false
	uzi_spray_speed_timer.stop()
	uzi_spray_audio.stop() 
 
func process(_delta):
	if Input.is_action_just_pressed("shoot"):
		uzi_spray_speed_timer.start()
		uzi_spray_audio.play() 
	if Input.is_action_just_released("shoot"):
		uzi_spray_speed_timer.stop()
		uzi_spray_audio.stop() 
	
	if Input.is_action_just_pressed("switch_weapon"):
		transitioned.emit(self, "GrenadeLauncher")


func _on_uzi_spray_speed_timer_timeout() -> void:
		var bullet_instance = BULLET.instantiate()
		get_tree().current_scene.add_child(bullet_instance)
		bullet_instance.global_position = shooting_point.global_position
		bullet_instance.rotation = shooting_anchor.rotation + randf_range(-0.5, +0.5)
