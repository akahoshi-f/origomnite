extends CharacterBody3D
signal healthchanged

#Persona
@onready var personaidk = $Personaidk

@onready var hitbox1 = $Personaidk/HitboxAtacar
@onready var hitbox2 = $Personaidk/HitboxChute1
@onready var hitbox3 = $Personaidk/HitboxChute2
@onready var hitbox4 = $Personaidk/HitboxGiratorio
@onready var hitbox5 = $Personaidk/HitboxGiratorio2
@onready var hitbox6 = $Personaidk/HitboxGiratorioAlto

#camera
@onready var spring_arm_pivot = $SpringArmPivot
@onready var spring_arm = $SpringArmPivot/SpringArm3D
const LERP_VAL = .15

#timer para combate
@onready var ehossotimer = $ehossotimer as Timer
#timer pra saque
@onready var saquetimer = $saquetimer as Timer
var guardar = false

#Vida
@export var HP = 30
@export var Stam = 20
@onready var barra_de_vida = $"../Pause/Control/Vida"
@onready var barra_de_stam = $"../Pause/Control/Stamina"

#variaveiss
@export var speed = 7
@export var fall_acceleration = 75
@export var jump_impulse = 20
var target_velocity = Vector3.ZERO
var anim_rodando = false
var salto_anim = false
var armaSacada = false
var a = 0
var parada = true

#interação
var interação = false

#esconder o mouse
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if Global.change_scene:  # Só aplica o teleporte se veio do `Area3D`
		position = Global.spawn_position
		Global.change_scene = false  # Reseta a variável para evitar problemas


func _process(delta):
#Camera do joystick
	var camlado = Input.get_action_strength("cam_dir") - Input.get_action_strength("cam_esq")
	var camcima = Input.get_action_strength("cam_tras") - Input.get_action_strength("cam_frente")
	
	if InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-camlado * .12)
		spring_arm.rotate_x(-camcima * .12)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)
	
	
#mostrar texto na tela
func show_message(text):
	$Interação.text = text
	$Interação.show()


func _input(event):
	#rotação mouse
	if event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x * .012)
		spring_arm.rotate_x(-event.relative.y * .012)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)

#PULO
	if is_on_floor() and Input.is_action_just_pressed("pular") and not anim_rodando:
		target_velocity.y = jump_impulse
		saquetimer.stop()
		
#Correr
	if Input.is_action_just_pressed("correr"):
		speed = 16
	if Input.is_action_just_released("correr"):
		speed = 7
	

func _physics_process(delta):
	#impedimento de desarme caso a animação esteja rodando
	if anim_rodando:
		saquetimer.stop()
	#Movimento
	else:
		var input_dir = Input.get_vector("andar_esq", "andar_dir", "andar_frente", "andar_tras")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		#Mudar de acordo com a camera
		direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			#mudar direção da personagem de acordo com a camera
			personaidk.rotation.y = lerp_angle(personaidk.rotation.y, atan2(-velocity.x, -velocity.z), LERP_VAL)
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
	
		#animações
		#sem arma
		if not armaSacada and not salto_anim:
			if speed == 16 and (direction.z != 0 or direction.x != 0):
				$AnimationPlayer.play("Anim/correr")
				parada = false
			elif direction.z != 0 or direction.x != 0:
				$AnimationPlayer.play("Anim/caminhar")
				parada = false
			else:
				$AnimationPlayer.play("Anim/respirando")
				parada = true
				
			#Saque arma
			if Input.is_action_just_pressed("mouse_press") and is_on_floor():
				$AnimationPlayer.play("Anim/sacando")
				armaSacada = true
		#com arma na mão
		elif armaSacada and not salto_anim:
			if speed == 16 and (direction.z != 0 or direction.x != 0):
				$AnimationPlayer.play("Anim/correrComArma")
				parada = false
				saquetimer.stop()
			elif direction.z != 0 or direction.x != 0:
				$AnimationPlayer.play("Anim/caminharComArma")
				parada = false
				saquetimer.stop()
				#PARADA E ARMADA
			else:
				$AnimationPlayer.play("Anim/respirandoComArma")
				parada = true
				
				#desarme
				if saquetimer.is_stopped() and guardar == false:
					saquetimer.start()
				if guardar == true:
					$AnimationPlayer.play_backwards("Anim/sacando")
					armaSacada = false
					guardar = false

			#Ataque Especial
			if Input.is_action_just_pressed("especial"):
				$AnimationPlayer.play("Anim/GiratorioAlto")
				var enemiesspecial = hitbox6.get_overlapping_bodies()
				for junin_inim in enemiesspecial:
					if junin_inim.has_method("doi"):
						junin_inim.doi()
						print("Foi especial")
				#luta = true
			#if luta == true:
				#print('working')

			#Ataque (pode passar para o input() dps)
			if Input.is_action_just_pressed("mouse_press") and is_on_floor():
				
				#inicio do timer
				if ehossotimer.is_stopped():
					a = 0
				ehossotimer.start()
				
				a = a+1
				match a:
					1:
						$AnimationPlayer.play("Anim/Atacar")
					2:
						$AnimationPlayer.play("Anim/Chute1")
					3:
						$AnimationPlayer.play("Anim/Giratorio1")
						a = 0
	
		target_velocity.x = direction.x * speed
		target_velocity.z = direction.z * speed
	
	#velocidade queda GRAVIDADE
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
		
	velocity = target_velocity
	move_and_slide()
	
	#fazer interagir
	if $SpringArmPivot/RayCast3D.is_colliding():
		show_message("Pressione 'F' para interagir.")
		if Input.is_action_just_pressed("int"):
			$Panel.show()
			$Panel/Dialogos.text = "uéAAAAAA"
	elif not $SpringArmPivot/RayCast3D.is_colliding():
		show_message("")
		$Panel.hide()
		$Panel/Dialogos.text = ""
		
func _on_animation_player_animation_finished(anim_name): #Avisa animação finalizada
	if anim_name == "Anim/sacando" or anim_name == "Anim/Atacar" or anim_name == "Anim/Giratorio" or anim_name == "Anim/Chute1" or anim_name == "Chute 2" or anim_name == "Anim/GiratorioAlto" or anim_name == "Anim/Giratorio1":
		anim_rodando = false
		speed = 7
		
	if anim_name == "Anim/puloArma" or anim_name == "Anim/puloNãoArma":
		salto_anim = false
		$AnimationPlayer.speed_scale = 1

func _on_animation_player_animation_started(anim_name): #Avisa animação iniciada
	if anim_name == "Anim/sacando" or anim_name == "Anim/Atacar" or anim_name == "Anim/Giratorio" or anim_name == "Anim/Chute1" or anim_name == "Chute 2" or anim_name == "Anim/GiratorioAlto" or anim_name == "Anim/Giratorio1":
		anim_rodando = true
		speed = 0
		
	if anim_name == "Anim/puloArma" or anim_name == "Anim/puloNãoArma":
		salto_anim = true
		$AnimationPlayer.speed_scale = 1.5

#avisa timer saque acabou
func _on_saquetimer_timeout():
	guardar = true
	
func ataquelegal():
	
	if a == 1:
		print("Foi um")
		var enemies1 = hitbox1.get_overlapping_bodies()
		for junin_inim in enemies1:
			if junin_inim.has_method("doinormal"):
				junin_inim.doinormal()
	
	if a == 2:
		print("Foi dois")
		var enemies2 = hitbox2.get_overlapping_bodies()
		for junin_inim in enemies2:
			if junin_inim.has_method("doinormal"):
				junin_inim.doinormal()
	
	var enemies3 = hitbox3.get_overlapping_bodies()
	for junin_inim in enemies3:
		if junin_inim.has_method("doinormal"):
			junin_inim.doinormal()
			
	if a == 3:
		print("Foi tres")
		var enemies4 = hitbox4.get_overlapping_bodies()
		for junin_inim in enemies4:
			if junin_inim.has_method("doinormal"):
				junin_inim.doinormal()
			
	var enemies5 = hitbox5.get_overlapping_bodies()
	for junin_inim in enemies5:
		if junin_inim.has_method("doinormal"):
			junin_inim.doinormal()
			
	var enemies6 = hitbox6.get_overlapping_bodies()
	for junin_inim in enemies6:
		if junin_inim.has_method("doinormal"):
			junin_inim.doinormal()

func doi():
	HP = HP - 5
