extends Area3D
var entered = false

func _on_body_entered(body: PhysicsBody3D):
	entered = true
	
func _on_body_exited(body):
	entered = false
	
func _process(delta):
	if entered == true:
		get_tree().change_scene_to_file("res://parte3/parte_tres_final.tscn")
