extends Node
class_name main
signal toggle_game_paused(is_paused : bool)

#testes 2509
@export var luta = false

func _on_area_3d_body_entered(body):
	if luta == true:
		print('working')
		
func naosei():
	print('working2')

var game_paused : bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused", game_paused)

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event: InputEvent):
	if(event.is_action_pressed("pause")):
		game_paused = !game_paused
