extends Node2D
@onready var vaso: TextureProgressBar = %Vaso
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var perdiste: Label = %Perdiste
@onready var cantidad: Label = %Cantidad
@onready var restart: Button = $Restart
@onready var explicacion: Label = $Explicacion

const max_coca:float = 70
const max_ferne:float = 30


var _progress :float = 0.
var animacion_finalizada :bool = false

func _ready() -> void:
	animation_player.animation_finished.connect(animacion)

func _process(delta: float) -> void:
	if Input.is_action_pressed("fill") and animacion_finalizada:
		_progress += randf_range(0.1,0.5)
		print(vaso.value)
	vaso.value = _progress
	cantidad.text = str(vaso.value)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fill"):
		animation_player.play("girar")
		explicacion.hide()
	if event.is_action_released("fill"):
		animation_player.play("RESET")
		if animacion_finalizada:
			animacion_finalizada = false
		if vaso.value > max_coca:
			perdiste.text = "PERDISTE"
			perdiste.show()
			restart.show()
		if vaso.value == max_coca:
			perdiste.text = "GANASTE"
			perdiste.show()
			restart.show()

func animacion(animacion: String) -> void:
	if animacion == "girar":
		animacion_finalizada = true
	


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
