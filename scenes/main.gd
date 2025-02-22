extends Node2D
@onready var vaso: TextureProgressBar = %RellenoCoca
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var cantidad_fernet: Label = %CantidadFrNeTh
@onready var cantidad_coca: Label = %CantidadCoCa
@onready var restart: Button = $Restart
@onready var explicacion: Label = $Explicacion
@onready var check_fr_ne_th: Sprite2D = $FrNeTh/CheckFrNeTh
@onready var check_co_ca: Sprite2D = $FrNeTh/CheckCoCa
@onready var relleno_fernet: TextureProgressBar = $RellenoFernet
@onready var agua: AudioStreamPlayer = %Agua
@onready var bomba: AudioStreamPlayer = %Bomba
@onready var alarma: AudioStreamPlayer = %Alarma
@onready var bomba_animation: AnimationPlayer = %bombaAnimation
@onready var bomba_rec: ColorRect = $bombaRec
@onready var camara: Camera2D = $Camara
@onready var cruz_co_ca: Sprite2D = $FrNeTh/CruzCoCa
@onready var cruz_fr_ne_th: Sprite2D = $FrNeTh/CruzFrNeTh
@onready var animacion_japon: AnimationPlayer = $BackgroundJapon/AnimacionJapon
@onready var animacion_ganar: AnimationPlayer = %AnimacionGanar
@onready var animacion_brillo_vaso: AnimationPlayer = $BrillosVaso/AnimacionBrilloVaso
@onready var background_japon: Sprite2D = $BackgroundJapon
@onready var sprite_espuma: Sprite2D = $SpriteEspuma
@onready var brillos_vaso: Sprite2D = $BrillosVaso
@onready var win: AudioStreamPlayer = %win
@onready var nuke: Sprite2D = $nuke
@onready var sprite_espuma_perdio: Sprite2D = $SpriteEspumaPerdio
@onready var animation_nuke: AnimationPlayer = $nuke/AnimationNuke
@onready var animation_espuma_perdio: AnimationPlayer = $SpriteEspumaPerdio/AnimationEspumaPerdio
@onready var fuego: AnimatedSprite2D = $Fuego
@onready var fuego_2: AnimatedSprite2D = $Fuego2
@onready var fuego_3: AnimatedSprite2D = $Fuego3
@onready var fuego_4: AnimatedSprite2D = $Fuego4
@onready var fr_ne_th_roto: AnimationPlayer = $FrNeTh/FrNeThRoto
@onready var animation_vaso: AnimationPlayer = $SpriteVaso/AnimationVaso
@onready var alarma_animacion: AnimatedSprite2D = $alarma

var randomFuerza : float = 30.0
var shakeFade : float = 50

var rng = RandomNumberGenerator.new()

var shake_str: float = 0.0
var ganaste : bool = false
var perdiste: bool = false

const max_coca:float = 100
const max_ferne:float = 30


var _progress :float = 30.
var _progress_fernet :float = 0.
var animacion_finalizada :bool = false
#true es coca false es ferne
var bebida : bool = false

func _ready() -> void:
	animation_player.animation_finished.connect(animacion)
	animacion_ganar.animation_finished.connect(ganar_ani)
	animation_nuke.animation_finished.connect(nukePerdio)
	animation_player.play("RESET")
	cantidad_fernet.text = str(0)+"%"
	cantidad_coca.text = str(0)+"%"
	vaso.value = 30.
	background_japon.hide()
	sprite_espuma.hide()
	brillos_vaso.hide()

func _process(delta: float) -> void:
	if Input.is_action_pressed("fill") and animacion_finalizada and not bebida and not ganaste and not perdiste:
		_progress_fernet += randf_range(50,100)*delta
		relleno_fernet.value = _progress_fernet
	elif Input.is_action_pressed("fill") and animacion_finalizada and bebida and not ganaste and not perdiste:
		_progress += randf_range(50,100)*delta
		vaso.value = _progress
	
	cantidad_coca.text = str(vaso.value-30.)+"%"
	cantidad_fernet.text = str(relleno_fernet.value)+"%"
	
	if shake_str > 0:
		#shake_str = lerpf(shake_str,0,shakeFade*delta)
		shake_str = move_toward(shake_str, 0, shakeFade * delta)
		camara.offset = random_offset()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fill") and not ganaste and not perdiste:
		if bebida == false:
			animation_player.play("girar")
			#explicacion.hide()
		else:
			animation_player.play("tubo2")
	if event.is_action_released("fill") and not ganaste and not perdiste:
		if bebida == false:
			animation_player.play("RESET")
		else:
			animation_player.play("tubo_idle")
		agua.stop()
		if animacion_finalizada:
			animacion_finalizada = false
		if vaso.value > max_coca:
			perdiste = true
			cruz_co_ca.show()
			alarma.play()
			alarma_animacion.show()
			apply_shake()
			show_espuma_perdio()
			
			alarma.finished.connect(bombaAni)
			#perdiste.show()
		if vaso.value == max_coca:
			#perdiste.text = "GANASTE"
			#perdiste.show()
			sprite_espuma.show()
			check_co_ca.show()
			ganaste = true
			win.play()
			animacion_ganar.play("ganar1")
		if relleno_fernet.value > 30:
			perdiste = true
			cruz_fr_ne_th.show()
			alarma.play()
			alarma_animacion.show()
			apply_shake()
			show_espuma_perdio()
			alarma.finished.connect(bombaAni)
			#perdiste.show()
			
		if relleno_fernet.value == 30:
			check_fr_ne_th.show()
			vaso.show()
			bebida = true
			
			

func animacion(animacion: String) -> void:
	if animacion == "girar" or animacion == "tubo2":
		animacion_finalizada = true
		agua.play()


func bombaAni()->void:
	bomba_animation.play("explosion")
	bomba.play()
	bomba_animation.animation_finished.connect(bombaReset)
	


func bombaReset(animacion: String)->void:
	if animacion == "explosion":
		await get_tree().create_timer(1).timeout
		bomba_animation.play("salir")
		bomba_animation.animation_finished.connect(
			func(animacion: String):
				if animacion == "salir":
					restart.show()
		)


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
	
func apply_shake()-> void:
	shake_str = randomFuerza
	
func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_str,shake_str),rng.randf_range(-shake_str,shake_str))

func ganar_ani(animacion: String)-> void:
	if animacion=="ganar1":
		
		animacion_ganar.play("ganar2")
		background_japon.show()
		animacion_japon.play("japon")
		brillos_vaso.show()
		animacion_brillo_vaso.play("brillo")
		await get_tree().create_timer(2).timeout
		restart.show()

func show_nuke()->void:
	nuke.show()
	animation_nuke.play("nuke")

func show_espuma_perdio()-> void:
	sprite_espuma_perdio.show()
	animation_espuma_perdio.play("espuma")

func nukePerdio(animacion: String)->void:
	if animacion=="nuke":
		nuke.hide()
		sprite_espuma_perdio.hide()

func mostrarRoto()->void:
	if bebida==false:
		animation_player.play("tubo1roto")
	else:
		animation_player.play("tubo2roto")
	fr_ne_th_roto.play("roto")
	animation_vaso.play("roto")
	fuego.show()
	fuego_2.show()
	fuego_3.show()
	fuego_4.show()
	
	
	
	
