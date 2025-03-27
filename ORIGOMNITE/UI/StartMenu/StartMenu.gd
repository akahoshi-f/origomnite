extends Control

@onready var startbutton = $VBoxContainer/StartButton
@onready var VideoPlayer = $VideoStreamPlayer
	
func _ready():
	get_tree().paused = false
	startbutton.grab_focus()
	
func _on_start_button_pressed():
	var label = $Label
	label.hide()
	VideoPlayer.show()
	$AudioStreamPlayer.stop()
	
	var screen_size = get_viewport().get_visible_rect().size
	VideoPlayer.set_size(screen_size)
	VideoPlayer.set_position(Vector2.ZERO)
	VideoPlayer.play()
	
func _input(event):
	if event is InputEventKey and event.pressed:
		VideoPlayer.stop()
		get_tree().change_scene_to_file("res://parte1/parte_um_final.tscn")
		

func _on_video_stream_player_finished():
	get_tree().change_scene_to_file("res://parte1/parte_um_final.tscn")
	
func _on_leave_button_pressed():
	get_tree().quit()
