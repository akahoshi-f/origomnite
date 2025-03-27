extends Control

@warning_ignore("shadowed_global_identifier")
@export var bar_Final_Code : bar_final

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	bar_Final_Code.connect("toggle_game_paused", _on_bar_Final_toggle_game_paused)

func _on_bar_Final_toggle_game_paused(is_paused : bool):
	#se não ta pausado, pausa e se ta, despausa
	if(is_paused):
		show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		hide()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		



func _on_voltaaojogo_pressed():
	bar_Final_Code.game_paused = false

func _on_opções_pressed():
	var OptionsMenuPause = $"../Optionsmenu"
	OptionsMenuPause.visible = true
	hide()

func _on_sair_pressed():
	get_tree().change_scene_to_file("res://UI/StartMenu/StartMenu.tscn")
