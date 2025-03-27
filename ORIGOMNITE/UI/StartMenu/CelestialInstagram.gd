extends Sprite2D


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if get_rect().has_point(to_local(event.position)):
			OS.shell_open("https://www.instagram.com/celestiaestudio_/profilecard/?igsh=MXRzenB1ZWIxdmhqbg%3D%3D")
