extends Node2D

@onready var video_player = $VideoStreamPlayer

func _ready():
	# Obtém o tamanho da tela
	var screen_size = get_viewport_rect().size
	
	# Ajusta o tamanho do VideoStreamPlayer para ocupar toda a tela
	video_player.set_size(screen_size)
	
	# Define a posição no canto superior esquerdo
	video_player.set_position(Vector2.ZERO)
	
	# Inicia a reprodução
	video_player.play()
