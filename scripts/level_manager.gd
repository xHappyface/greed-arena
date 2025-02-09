extends Node
class_name LevelManager

@export var default_level: PackedScene

@onready var game_viewport = $GameView/GameViewport
@onready var ui: Control = $UI

var level: Level = null

func _ready() -> void:
	load_level()

func load_level() -> void:
	if default_level.can_instantiate():
		level = default_level.instantiate()
		game_viewport.add_child(level)
		level.level_manager = self
		ui.player = level.player
		level.game_timer.connect("timeout", get_parent().stop_game)
