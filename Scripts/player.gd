extends CharacterBody2D
class_name Player

@export var max_health := 10
var current_health = max_health

@export var speed = 400
@onready var pistol_anchor_node: Node2D = $PistolAnchorNode


func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(_delta):
	get_input()
	move_and_slide()
	pistol_anchor_node.look_at(get_global_mouse_position())

func take_damage(damage: int):
	current_health -= damage
	if current_health <= 0:
		get_tree().change_scene_to_file("res://Scenes/end_screen.tscn")
