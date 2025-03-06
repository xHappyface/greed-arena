extends Resource
class_name SaveFile

const PATH: NodePath = "user://save_file.TRES"

@export var money: int = 0
@export var ranks: Dictionary = {
	LevelProvider.Rank.SPEED: 0,
	LevelProvider.Rank.TIME: 0,
	LevelProvider.Rank.MAGNET: 0,
	LevelProvider.Rank.MONEY_BUNDLE: 0,
	LevelProvider.Rank.MONEY_BAG: 0,
}
@export var options_input_controls: Player.InputControls = Player.InputControls.MOUSE
@export var options_audio_volume: float = 100.0
@export var options_audio_mute: bool = false

func save_game() -> void:
	print("GAME SAVED")
	ranks[LevelProvider.Rank.SPEED] = LevelProvider.ranks[LevelProvider.Rank.SPEED]
	ranks[LevelProvider.Rank.TIME] = LevelProvider.ranks[LevelProvider.Rank.TIME]
	ranks[LevelProvider.Rank.MAGNET] = LevelProvider.ranks[LevelProvider.Rank.MAGNET]
	ranks[LevelProvider.Rank.MONEY_BUNDLE] = LevelProvider.ranks[LevelProvider.Rank.MONEY_BUNDLE]
	ranks[LevelProvider.Rank.MONEY_BAG] = LevelProvider.ranks[LevelProvider.Rank.MONEY_BAG]
	ResourceSaver.save(self, PATH)

static func load_game() -> SaveFile:
	if ResourceLoader.exists(PATH):
		print("GAME LOADED")
		var save: SaveFile = ResourceLoader.load(PATH)
		LevelProvider.ranks[LevelProvider.Rank.SPEED] = save.ranks[LevelProvider.Rank.SPEED]
		LevelProvider.ranks[LevelProvider.Rank.TIME] = save.ranks[LevelProvider.Rank.TIME]
		LevelProvider.ranks[LevelProvider.Rank.MAGNET] = save.ranks[LevelProvider.Rank.MAGNET]
		LevelProvider.ranks[LevelProvider.Rank.MONEY_BUNDLE] = \
		  save.ranks[LevelProvider.Rank.MONEY_BUNDLE]
		LevelProvider.ranks[LevelProvider.Rank.MONEY_BAG] = \
		  save.ranks[LevelProvider.Rank.MONEY_BAG]
		OptionsMenu.set_input_controls(save.options_input_controls)
		OptionsMenu.set_volume(save.options_audio_volume)
		OptionsMenu.set_mute(save.options_audio_mute)
		return save
	else:
		print("NEW GAME")
		return SaveFile.new()
