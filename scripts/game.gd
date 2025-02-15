extends Node
class_name Game

@onready var save_file_resource: Resource = preload("res://scripts/save_file.gd")

@onready var level_manager: LevelManager = $LevelManager
@onready var ui: Control = $LevelManager/UI
@onready var main_menu: Control = $Menu/MainMenu

func _init() -> void:
	LevelProvider.save_file = SaveFile.load_game()

func _ready() -> void:
	get_tree().paused = true

func start_game() -> void:
	main_menu.hide()
	get_tree().paused = false

func stop_game() -> void:
	get_tree().paused = true
	LevelProvider.save_file.money = LevelProvider.level.player.money
	LevelProvider.level.queue_free()
	level_manager.load_level()
	main_menu.show()
	LevelProvider.save_file.save_game()
