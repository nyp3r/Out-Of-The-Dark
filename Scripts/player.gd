extends CharacterBody2D
class_name Player

@export var max_health := 10
var current_health = max_health

@export var speed = 400
@onready var shooting_anchor: Node2D = $ShootingAnchor
@onready var health_label: Label = $"../CanvasLayer/HealthLabel"
@onready var body_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	health_label.text = str(current_health)

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(_delta):
	get_input()
	move_and_slide()
	shooting_anchor.look_at(get_global_mouse_position())
	var abs_degrees := abs(shooting_anchor.rotation_degrees) as float
	body_sprite.flip_h = abs_degrees > 90
	for child in shooting_anchor.get_children():
		if child.is_class("AnimatedSprite2D"):
			(child as AnimatedSprite2D).flip_v = abs_degrees > 90

func take_damage(damage: int):
	current_health -= damage
	health_label.text = str(current_health)
	if current_health <= 0:
		get_tree().change_scene_to_file("res://Scenes/end_screen.tscn")
