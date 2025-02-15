extends Resource
class_name SaveFile

const PATH: NodePath = "user://save_file.TRES"

@export var money: int = 0

func save_game() -> void:
	print("GAME SAVED")
	ResourceSaver.save(self, PATH)

static func load_game() -> SaveFile:
	if ResourceLoader.exists(PATH):
		print("GAME LOADED")
		var save: SaveFile = ResourceLoader.load(PATH)
		return save
	else:
		print("NEW GAME")
		return SaveFile.new()
