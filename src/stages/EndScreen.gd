extends Node2D

func _ready():
	stage_music.stop()
	$AudioStreamPlayer.play()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		stage_music.stop()
		Globals.goto_scene("res://Objects/TitleScreen.tscn")
	if event.is_action_pressed("escape"):
		get_tree().quit()
