extends Control

func _ready():
	get_tree().paused = false
	$AnimationPlayer.play("OptionsMenuAnimationSlide")
	


func _on_backeverything_pressed():
	$AnimationPlayer.play_backwards("OptionsMenuAnimationSlide")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://UI/StartMenu/StartMenu.tscn")


func _on_resetall_pressed():
	$"Panel/TabContainer/Jogo/OpçãoDificuldade".selected = 1
	$"Panel/TabContainer/Jogo/OpçãoIdiomaa".selected = 0
	$"Panel/TabContainer/Jogo/DicasBotão".button_pressed = false

func _on_resetsound_pressed():
	$Panel/TabContainer/Som/SFXsoundvolume.value = 0.5
	$Panel/TabContainer/Som/Mastersoundvolume.value = 0.5
	$Panel/TabContainer/Som/BGMsoundvolume.value = 0.5



func _on_windowsis_item_selected(index):
	if index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_resetvideo_pressed():
	$Panel/TabContainer/Video/Windowsis.selected = 0
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
