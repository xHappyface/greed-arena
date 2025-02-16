extends Resource
class_name ShopItem

@export var label: String = "Default"
@export var cost: int = 100_000

static func create(label: String, cost: int = 100_000) -> ShopItem:
	var item: ShopItem = ShopItem.new()
	item.label = label
	item.cost = cost
	return item
