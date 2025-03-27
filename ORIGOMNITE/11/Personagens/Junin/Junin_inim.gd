extends CharacterBody3D
@export var SPEED = 150.0
@export var CHASE_RANGE := 20.0
const ATK_RANGE := 3.0

@onready var AtqT = $AtqT as Timer
@export var target : CharacterBody3D
@onready var nav_agent = $NavigationAgent3D
var anim_rodando = false
var hit_tomando = false
@export var HP = 10
var a = 1
@onready var hitbox_1 = $NPC/ataque1
@onready var hitbox_2 = $NPC/ataque2

#variavel da barra de vida
@onready var progress_life = $SubViewport/ProgressBar

#var scripte = preload("res://main.gd")
#func _ready():
#	var resultado = scripte.naosei()
#	print(resultado)
	
#var scriptA = instance_from_id(id)
#func _ready():
	#var resultado = scriptA.minha_funcao()
	#print(resultado) 

func _process (delta):
	velocity = Vector3.ZERO
	
	#barra de vida
	progress_life.value = HP
	
	##Perseguir jogador
	if HP > 0:
		
		if global_position.distance_to(target.global_position) < CHASE_RANGE:
			nav_agent.set_target_position(target.global_transform.origin)
			var next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * SPEED * delta
			##Virar o personagem pra direção desejada
			look_at(Vector3(target.global_position.x, global_position.y, target.global_position.z), Vector3.UP)
			if not anim_rodando:
				$AnimationPlayer.play("AnimJ/caminharJunin")
		else:
			$AnimationPlayer.play("AnimJ/Respirando")
		
		if global_position.distance_to(target.global_position) < ATK_RANGE and not anim_rodando:
			if AtqT.is_stopped():
				a = 1
			AtqT.start()
			match a:
				1:
					$AnimationPlayer.play("AnimJ/ataqueJunin01")
					a = a+1
				2:
					$AnimationPlayer.play("AnimJ/ataqueJunin02")
					a = 1
		
	move_and_slide()
	
	if HP <= 0:
		morte()
		
	
func morte():
	$AnimationPlayer.play("AnimJ/Nocaute")

func _on_animation_player_animation_started(anim_name):
	if anim_name == "AnimJ/ataqueJunin01" or anim_name == "AnimJ/ataqueJunin02" or anim_name == "AnimJ/Respirando" or anim_name == "AnimJ/receberAtaque" or anim_name == "AnimJ/receberAtaque_02":
		anim_rodando = true
			
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "AnimJ/ataqueJunin01" or anim_name == "AnimJ/ataqueJunin02" or anim_name == "AnimJ/Respirando" or anim_name == "AnimJ/receberAtaque" or anim_name == "AnimJ/receberAtaque_02":
		anim_rodando = false
		
	if anim_name == "AnimJ/Nocaute":
		queue_free()
		
func doinormal():
	HP = HP - 3
	$AnimationPlayer.play("AnimJ/receberAtaque")
	SPEED = 0.0
	print("Parou")
	await(1)
	SPEED = 150.0

func doiespecial():
	HP = HP - 5
	$AnimationPlayer.play("AnimJ/receberAtaque_02")
	SPEED = 0.0
	print("Parou2")
	await(1)
	SPEED = 150.0

func ataque1():
	var jogadores = hitbox_1.get_overlapping_bodies()
	for Jogador in jogadores:
		if Jogador.has_method("doi"):
				Jogador.doi()

func ataque2():
	var jogadores = hitbox_2.get_overlapping_bodies()
	for Jogador in jogadores:
		if Jogador.has_method("doi"):
				Jogador.doi()
