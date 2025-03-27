extends Control

@export var main : main

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	main.connect("toggle_game_paused", on_main_toggle_game_paused)



	
func on_main_toggle_game_paused(is_paused : bool):
	if(is_paused):
		show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		hide()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_voltar_pressed():
	main.game_paused = false

func _on_sair_pressed():
	get_tree().quit()
