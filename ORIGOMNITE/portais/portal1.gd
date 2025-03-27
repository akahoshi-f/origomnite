extends Area3D

@onready var transition = get_node ("Transition2/Fill")
@onready var animation = get_node ("Transition2/Fill/animation") 

var entered = false

func _on_body_entered(body: PhysicsBody3D):
	entered = true
	
func _on_body_exited(body):
	entered = false
	
func _process(delta):
	if entered == true:
		get_tree().change_scene_to_file("res://parte2/parte_dois_final.tscn")
		
