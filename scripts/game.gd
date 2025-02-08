extends Node
class_name Game

@onready var level_manager: LevelManager = $LevelManager
@onready var ui: Control = $LevelManager/UI
@onready var main_menu: Control = $MainMenu

func _ready() -> void:
	get_tree().paused = true

func start_game() -> void:
	main_menu.hide()
	get_tree().paused = false
