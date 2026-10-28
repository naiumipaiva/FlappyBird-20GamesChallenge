extends CharacterBody2D

# Variáveis de controle do jogo
var started = false
var start_position

# Define a força com que a gravidade puxa o pássaro para baixo
var gravidade = 800

# Define a força do impulso quando o jogador aperta espaço
var forca_pulo = 300

# Executado uma única vez assim que o pássaro entra na cena
func _ready() -> void:
	# Guarda a posição inicial do pássaro
	start_position = position


# Processamento de física executado em intervalos fixos
func _physics_process(delta: float) -> void:
	# Se o jogador apertar espaço e o jogo ainda não tiver começado
	# então inicia o jogo
	if Input.is_action_just_pressed("start") and started == false:
		started_game()
	
	# Executa apenas quando o jogo já estiver iniciado
	if started:
		# Aplica a gravidade ao pássaro. Quanto mais tempo passa, mais rápido ele cai
		velocity.y += gravidade * delta
		# Se o jogador apertar espaço aplica um impulso para cima
		if Input.is_action_just_pressed("start"):
			velocity.y = -forca_pulo	
		# Move o pássaro usando a velocidade atual
		move_and_slide()
		
		# Percorre todas as colisões que aconteceram com o pássaro neste frame
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			
			# Se o objeto tocado for o topo ou a base do cano, chama a função de game over global no pai
			if collider .name in ['pipeTop', 'pipeBotton']:
				get_parent().game_over()

# Marca que o jogo começou
func started_game(): 
	started = true

# Reseta o jogo
func reset_game():
	started = false
	position = start_position
	velocity = Vector2.ZERO


# O Fluxo é:
# 1. Espera o jogador apertar espaço.
# 2. Quando apertar, o jogo começa.
# 3. A gravidade passa a agir no pássaro.
# 4. A cada frame a velocidade para baixo aumenta.
# 5. Quando o jogador aperta espaço, a velocidade vira negativa.
# 6. A velocidade negativa faz o pássaro subir.
# 7. A gravidade reduz essa velocidade aos poucos.
# 8. A velocidade chega a 0.
# 9. Depois fica positiva.
# 10. O pássaro começa a cair novamente.
# 11. move_and_slide() move o pássaro.
# 12. Repete tudo de novo no próximo frame.
