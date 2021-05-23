extends TextureRect

var firstplay = false

func _ready():
#	OS.window_maximized = true
	$CanvasLayer/VBoxContainer/start_button.grab_focus()

func _on_Quit_pressed():
	get_tree().quit()

func _on_Quit_mouse_entered():
	$CanvasLayer/VBoxContainer/Quit.grab_focus()

func _on_start_button_mouse_entered():
	$CanvasLayer/VBoxContainer/start_button.grab_focus()


func _on_start_button_pressed():
	$AudioStreamPlayer2D.stop()
	$menu_start_pressed.play()
	$CanvasLayer/VBoxContainer/start_button.focus_neighbour_bottom = "root/CanvasLayer/VBoxContainer/start_button"
	$CanvasLayer/VBoxContainer/Quit.disabled = true

func _on_start_button_focus_entered():
	if firstplay:
		$menu_sound.play()
	else:
		firstplay = true


func _on_Quit_focus_entered():
	$menu_sound.play()

func _on_menu_start_pressed_finished():
	Globals.goto_scene("res://assets/stages/serious/test_room1.tscn")
#	stage_music.play()
