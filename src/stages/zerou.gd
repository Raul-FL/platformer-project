extends Area2D

func _on_Area2D2_body_entered(body):
	Globals.goto_scene("res://assets/stages/debug/EndScreen.tscn")
