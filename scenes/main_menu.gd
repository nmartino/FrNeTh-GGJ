extends Node2D
var main = preload("res://scenes/main.tscn")

func _ready() -> void:
	Musica.play_music()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(main)
