extends CanvasLayer
class_name MenuManager

@onready var sfx_seek: AudioStreamWAV = preload("res://assets/audio/sfx/ui_select_gamelan.wav")
@onready var sfx_select: AudioStreamWAV = preload("res://assets/audio/sfx/ui_select_hitone.wav")

@onready var menu_sfx_player: AudioStreamPlayer = $MenuSFXPlayer

@onready var menus: Array[Control] = [
	$MainMenu,
	$OptionsMenu,
	$Shop,
]

enum Menu {
	MAIN,
	OPTIONS,
	SHOP,
}

var current_menu: Menu = Menu.MAIN

func _ready() -> void:
	for menu in menus:
		if menu != menus[Menu.SHOP]:
			for button in menu.buttons:
				button.connect("focus_entered", _play_menu_seek)
				button.connect("pressed", _play_menu_select)
	if Player.input_controls != Player.InputControls.MOUSE:
		menus[current_menu].buttons[0].grab_focus()

func switch_to_menu(next_menu: Menu) -> void:
	if next_menu == current_menu:
		return
	else:
		menus[current_menu].hide()
		menus[next_menu].show()
		if next_menu == Menu.SHOP:
			menus[next_menu].speed_item_card.button.grab_focus()
		else:
			menus[next_menu].buttons[0].grab_focus()
		current_menu = next_menu

func switch_to_main() -> void:
	switch_to_menu(Menu.MAIN)

func switch_to_options() -> void:
	switch_to_menu(Menu.OPTIONS)

func switch_to_shop() -> void:
	switch_to_menu(Menu.SHOP)

func _play_menu_seek() -> void:
	menu_sfx_player.set_stream(sfx_seek)
	menu_sfx_player.play()

func _play_menu_select() -> void:
	menu_sfx_player.set_stream(sfx_select)
	menu_sfx_player.play()
