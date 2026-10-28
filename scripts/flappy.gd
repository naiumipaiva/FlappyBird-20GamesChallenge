extends Node2D

# Referências para os nós da cena
@onready var bird = $Bird
@onready var label_pontos = $pontos
@onready var tutorial = $tutorial
@onready var timer = $Timer 

# Carrega a cena do cano previamente na memória
var pipe_scene = preload("res://cenas/pipe.tscn")
var game_started = false

# Armazena a quantidade de pontos do jogador
var pontos = 0

# Executado quando a cena principal é carregada 
func _ready() -> void:
	# Define o tempo de intervalo entre a criação de cada cano (2.5 segundos)
	timer.wait_time = 2.5
	# Conecta o sinal de término do Timer à função de criar novos canos
	timer.timeout.connect(_on_timer_timeout)

func _process(delta: float) -> void:
	
	# Se o jogador apertar o botão de iniciar
	if Input.is_action_just_pressed("start") and not game_started:
		game_started = true
		# Inicia o movimento do pássaro
		bird.started_game()
		# Mostra o contador de pontos na tela
		label_pontos.visible = true
		# Esconde a mensagem de tutorial
		tutorial.visible = false
		#Começa a gerar os canos quando o jogo inicia
		timer.start()
		# Instancia o primeiro cano imediatamente na tela
		_on_timer_timeout()

# Função disparada toda vez que o Timer atinge o tempo limite
func _on_timer_timeout() -> void:
	# Cria uma nova instância do cano
	var new_pipe = pipe_scene.instantiate()
	# Define a posição X no lado direito da tela e sorteia uma altura Y aleatória
	var random_y = randf_range(30,280)
	new_pipe.position = Vector2(280,random_y)
	# Adiciona o cano na cena principal
	add_child(new_pipe)
	
# Função unificada que reseta completamente o jogo (chamada por colisões ou pelo buraco)
func game_over():
	# Quando algum corpo entrar na área "hole"
	# reseta o jogo
	bird.reset_game()
	# Esconde o contador de pontos
	pontos = 0
	label_pontos.text = "0"
	label_pontos.visible = false
	# Mostra novamente a mensagem de tutorial
	tutorial.visible = true
	game_started = false
	# Para de gerar canos quando perde
	timer.stop()
	# Opcional: remover todos os canos restantes da tela ao reiniciar
	get_tree().call_group("pipes", "queue_free")

func _on_hole_body_entered(body: Node2D) -> void:
	game_over()

func adicionar_ponto():
	pontos +=1
	label_pontos.text = str(pontos)
	print(pontos)
	
# O Fluxo é:
# 1. O jogo começa mostrando o tutorial.
# 2. O jogador aperta espaço.
# 3. O pássaro começa a se mover.
# 4. O contador de pontos aparece.
# 5. O tutorial desaparece.
# 6. O jogador continua jogando.
# 7. Se o pássaro entrar na área "hole",
#    o sinal body_entered é emitido.
# 8. O jogo é reiniciado com reset_game().
# 9. O contador de pontos é escondido.
# 10. O tutorial volta a aparecer.
# 11. O jogador pode iniciar uma nova partida.
