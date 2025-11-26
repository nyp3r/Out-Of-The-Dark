extends Marker2D

const BULLET = preload("uid://blgiurjj48f67")

const MAX_CLIP_SIZE = 10
var current_clip_size := MAX_CLIP_SIZE
var reloading := false

func _ready() -> void:
	current_clip_size = MAX_CLIP_SIZE

func _process(_delta: float) -> void:
	if not reloading and Input.is_action_just_pressed("shoot"):
		var bullet_instance = BULLET.instantiate()
		get_tree().current_scene.add_child(bullet_instance)
		bullet_instance.global_position = global_position
		bullet_instance.rotation = get_parent().rotation
