extends Control

var cutsceneFim = false


@onready var VideoPlayer = $VideoStreamPlayer

func _ready():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("TransiçãoPreta")
	$SaveMenu/GoBackMainMenu.grab_focus()

func _on_go_back_main_menu_pressed():
	$AnimationPlayer.play("TransiçãoPreta")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://UI/StartMenu/StartMenu.tscn")


func _on_automatic_pressed():
	$AnimationPlayer.play("TransiçãoPreta")
	await get_tree().create_timer(1).timeout
	VideoPlayer.show()
	$AudioStreamPlayer.stop()
	
	var screen_size = get_viewport().get_visible_rect().size
	VideoPlayer.set_size(screen_size)
	VideoPlayer.set_position(Vector2.ZERO)
	VideoPlayer.play()


func _on_video_stream_player_finished():
	get_tree().change_scene_to_file("res://parte1/parte_um_final.tscn")
