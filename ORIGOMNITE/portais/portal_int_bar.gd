extends Area3D
var entered = false

func _on_body_entered(body: PhysicsBody3D):
	entered = true
	
func _on_body_exited(body):
	entered = false
	
func _process(delta):
	if entered:
		Global.change_scene = true  # Indica que a cena foi trocada pelo teleporte

		# Carrega a cena de destino
		var new_scene = load("res://parte2/parte_dois_final.tscn").instantiate()

		# Verifica se o SpawnPoint existe na nova cena
		if new_scene.has_node("SpawnPoint"):
			var spawn = new_scene.get_node("SpawnPoint")
			Global.spawn_position = spawn.position  # Salva a posição do SpawnPoint

		# Muda para a nova cena
		get_tree().change_scene_to_file("res://parte2/parte_dois_final.tscn")
