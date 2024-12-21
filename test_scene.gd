extends Node2D

func _ready():
	pass

func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
