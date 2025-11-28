extends State

@onready var grenade_launcher_sprite: AnimatedSprite2D = %GrenadeLauncherSprite
@onready var pistol_sprite: AnimatedSprite2D = %PistolSprite
@onready var shooting_point: Marker2D = %ShootingPoint
@onready var shooting_anchor: Node2D = $"../../ShootingAnchor"
@onready var pistol_shot_audio: AudioStreamPlayer2D = %PistolShotAudio

const BULLET = preload("uid://blgiurjj48f67")

const MAX_CLIP_SIZE = 10
var current_clip_size := MAX_CLIP_SIZE
var reloading := false

func enter():
	pistol_sprite.visible = true

func exit():
	pistol_sprite.visible = false

func ready() -> void:
	current_clip_size = MAX_CLIP_SIZE

func process(_delta: float) -> void:
	if not reloading and Input.is_action_just_pressed("shoot"):
		pistol_shot_audio.play()
		var bullet_instance = BULLET.instantiate()
		get_tree().current_scene.add_child(bullet_instance)
		bullet_instance.global_position = shooting_point.global_position
		bullet_instance.rotation = shooting_anchor.rotation
	if Input.is_action_just_pressed("switch_weapon"):
		transitioned.emit(self, "GrenadeLauncher")
