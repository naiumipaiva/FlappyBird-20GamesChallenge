extends Node2D

# Busca a referência do nó "Bird" que é filho do mesmo pai deste cano
@onready var bird = get_parent().get_node("Bird")


# Velocidade constante em que o cano se move para a esquerda
var velocidade = 130

# Executado assim que o cano é instanciado no jogo
func _ready() -> void:
	# Adiciona este cano ao grupo "pipes" para ser limpo facilmente no reset do jogo
	add_to_group("pipes")

# Executado a cada frame do jogo
func _physics_process(delta: float) -> void:
	# Só movimenta o cano se o jogo/pássaro já estiver ativo
	if bird.started:
		# Desloca a posição X para a esquerda ao longo do tempo
		position.x -= velocidade * delta
		# Se o cano sair totalmente da tela pelo lado esquerdo (X < -300)
		if position.x < -300:
			queue_free()
		
# Acionado quando o corpo do pássaro entra na área central de pontuação do cano
func _on_marca_ponto_body_entered(body: Node2D) -> void:
	if body.name == "Bird":
		# Chama a função que está no flappy.gd para somar no total geral
		get_parent().adicionar_ponto()
		
