extends Node

var save_file: SaveFile
var level: Level

var last_earned: int = -1

const SPEED_RANKS: int = 5
const TIME_RANKS: int = 5

var speed_rank: int = 0
var time_rank: int = 0

func update_game_timer() -> void:
	level.game_timer.stop()
	level.game_timer.wait_time = level.BASE_GAME_TIME + (time_rank * level.TIME_GROWTH_RATE)
	level.game_timer.start()
