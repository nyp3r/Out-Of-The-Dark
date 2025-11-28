extends Control

@onready var highscore_label: Label = $VBoxContainer2/VBoxContainer/HighscoreLabel
@onready var highscore_titel_label: Label = $VBoxContainer2/VBoxContainer/HighscoreTitelLabel
@onready var score_label: Label = $VBoxContainer2/VBoxContainer/ScoreLabel

func _on_play_again_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _ready() -> void:
	if Scores.new_highscore:
		highscore_titel_label.text = "New highscore!"
	else:
		highscore_titel_label.text = "Highscore"
	highscore_label.text = str(Scores.highscore)
	score_label.text = str(Scores.latest_score)
