extends Control
class_name UI

@onready var money: Label = $VBoxContainer/MoneyLabel

var player: Player = null

func _physics_process(_delta: float) -> void:
	pass

func _on_coin_collected() -> void:
	if player:
		money.text = "$%.02f" % [player.money / 100.0]
		queue_redraw()
