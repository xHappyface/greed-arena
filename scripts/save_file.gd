extends Resource
class_name SaveFile

const PATH: NodePath = "user://save_file.TRES"

@export var money: int = 0
@export var speed_rank: int = 0
@export var time_rank: int = 0
@export var options_audio_volume: float = 100.0
@export var options_audio_mute: bool = false

func save_game() -> void:
	print("GAME SAVED")
	speed_rank = LevelProvider.speed_rank
	time_rank = LevelProvider.time_rank
	ResourceSaver.save(self, PATH)

static func load_game() -> SaveFile:
	if ResourceLoader.exists(PATH):
		print("GAME LOADED")
		var save: SaveFile = ResourceLoader.load(PATH)
		LevelProvider.speed_rank = save.speed_rank
		LevelProvider.time_rank = save.time_rank
		OptionsMenu.set_volume(save.options_audio_volume)
		OptionsMenu.set_mute(save.options_audio_mute)
		return save
	else:
		print("NEW GAME")
		return SaveFile.new()
