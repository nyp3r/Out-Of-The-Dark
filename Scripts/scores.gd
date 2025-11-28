extends Node

var scores: Array[int]
var highscore: int:
	get:
		var highest := 0
		for score in scores:
			if score > highest:
				highest = score
		return highest
var new_highscore := false
var latest_score: int

func append_score(score: int):
	latest_score = score
	if score > highscore: new_highscore = true
	else: new_highscore = false
	scores.append(score)
