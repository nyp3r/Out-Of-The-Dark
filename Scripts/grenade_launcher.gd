extends State

@onready var grenade_launcher_sprite: AnimatedSprite2D = %GrenadeLauncherSprite
@onready var pistol_sprite: AnimatedSprite2D = %PistolSprite
@onready var grenade_impact_indicator: AnimatedSprite2D = %GrenadeImpactIndicator
@onready var grenade_launcher_shooting_cooldown_timer: Timer = %GrenadeLauncherShootingCooldownTimer
@onready var grenade_launcher_shoot_audio: AudioStreamPlayer2D = %GrenadeLauncherShootAudio
const GRENADE_IMPACT_AREA = preload("uid://xe8lgwqmmiga")

var can_shoot := true

func enter():
	grenade_launcher_sprite.visible = true
	grenade_impact_indicator.visible = true 

func exit():
	grenade_launcher_sprite.visible = false
	grenade_impact_indicator.visible = false

func process(_delta):
	grenade_impact_indicator.global_position = (owner as Node2D).get_global_mouse_position()
	if can_shoot and Input.is_action_just_pressed("shoot"):
		grenade_launcher_shoot_audio.play()
		grenade_launcher_shooting_cooldown_timer.start()
		can_shoot = false
		var grenade_impact_area_instantiated = GRENADE_IMPACT_AREA.instantiate() as Node2D
		get_tree().current_scene.add_child(grenade_impact_area_instantiated)
		grenade_impact_area_instantiated.global_position = (owner as Node2D).get_global_mouse_position()
	if Input.is_action_just_pressed("switch_weapon"):
		transitioned.emit(self, "Uzi")



func _on_grenade_launcher_shooting_cooldown_timer_timeout() -> void:
	can_shoot = true
