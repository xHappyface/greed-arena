extends CanvasLayer
class_name MenuManager

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

func switch_to_menu(next_menu: Menu) -> void:
	if next_menu == current_menu:
		return
	else:
		menus[current_menu].hide()
		menus[next_menu].show()
		current_menu = next_menu

func switch_to_main() -> void:
	switch_to_menu(Menu.MAIN)

func switch_to_options() -> void:
	switch_to_menu(Menu.OPTIONS)

func switch_to_shop() -> void:
	switch_to_menu(Menu.SHOP)
