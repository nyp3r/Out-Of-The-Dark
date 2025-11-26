extends Label

var count_down := 20.0

func _process(delta: float) -> void:
	count_down -= delta
	text = str("%0.1f" % count_down)
