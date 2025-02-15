extends Node
class_name LevelManager

@onready var game_viewport = $GameView/GameViewport
@onready var ui: Control = $UI

@onready var level_scene: PackedScene = preload("res://scene/level.tscn")

func _ready() -> void:
	load_level()

func load_level() -> void:
	if level_scene.can_instantiate():
		var level: Level = level_scene.instantiate()
		LevelProvider.level = level
		game_viewport.add_child(level)
		level.level_manager = self
		ui.player = level.player
		level.game_timer.connect("timeout", get_parent().stop_game)
		level.player.money = LevelProvider.save_file.money
