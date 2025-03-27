extends Area3D
var entered = false
@onready var AudioPlayer = $AudioStreamPlayer
@onready var VideoPlayer = $VideoStreamPlayer
@onready var VideoPlayer2 = $VideoStreamPlayer2
@onready var Jogador = $Player

func _on_body_entered(body: PhysicsBody3D):
	entered = true
	Jogador.global_position = Vector3(0.503, 0, -67.23)
	
func _on_body_exited(body):
	entered = false
	
func _process(delta):
	if entered == true:
		AudioPlayer.stop()
		VideoPlayer.show()
			
		var screen_size = get_viewport().get_visible_rect().size
		VideoPlayer.set_size(screen_size)
		VideoPlayer.set_position(Vector2.ZERO)
		VideoPlayer.play()

func _on_video_stream_player_finished():
	get_tree().change_scene_to_file("res://UI/StartMenu/StartMenu.tscn")
