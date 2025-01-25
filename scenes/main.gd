extends Node2D
@onready var vaso: TextureProgressBar = %RellenoCoca
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var perdiste: Label = %Perdiste
@onready var cantidad_fernet: Label = %CantidadFrNeTh
@onready var cantidad_coca: Label = %CantidadCoCa
@onready var restart: Button = $Restart
@onready var explicacion: Label = $Explicacion
@onready var check_fr_ne_th: Sprite2D = $FrNeTh/CheckFrNeTh
@onready var check_co_ca: Sprite2D = $FrNeTh/CheckCoCa
@onready var relleno_fernet: TextureProgressBar = $RellenoFernet
@onready var agua: AudioStreamPlayer = %Agua

const max_coca:float = 70
const max_ferne:float = 30


var _progress :float = 0.
var _progress_fernet :float = 70.
var animacion_finalizada :bool = false
#true es coca false es ferne
var bebida : bool = true

func _ready() -> void:
	animation_player.animation_finished.connect(animacion)
	cantidad_fernet.text = str(0)+"%"
	cantidad_coca.text = str(0)+"%"
	relleno_fernet.value = 70.

func _process(delta: float) -> void:
	if Input.is_action_pressed("fill") and animacion_finalizada and bebida:
		_progress += randf_range(0.1,0.5)
		print(_progress)
		vaso.value = _progress
	elif Input.is_action_pressed("fill") and animacion_finalizada and not bebida:
		_progress_fernet += randf_range(0.1,0.5)
		print(_progress_fernet)
		relleno_fernet.value = _progress_fernet
	
	cantidad_coca.text = str(vaso.value)+"%"
	cantidad_fernet.text = str(relleno_fernet.value-70.)+"%"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fill"):
		animation_player.play("girar")
		explicacion.hide()
	if event.is_action_released("fill"):
		animation_player.play("RESET")
		agua.stop()
		if animacion_finalizada:
			animacion_finalizada = false
		if vaso.value > max_coca:
			perdiste.text = "PERDISTE"
			perdiste.show()
			restart.show()
		if vaso.value == max_coca:
			#perdiste.text = "GANASTE"
			#perdiste.show()
			check_co_ca.show()
			bebida = false
			relleno_fernet.show()
		if relleno_fernet.value > 100:
			perdiste.text = "PERDISTE"
			perdiste.show()
			restart.show()
		if relleno_fernet.value == 100:
			check_fr_ne_th.show()
			restart.show()

func animacion(animacion: String) -> void:
	if animacion == "girar":
		animacion_finalizada = true
		agua.play()
	
	


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
