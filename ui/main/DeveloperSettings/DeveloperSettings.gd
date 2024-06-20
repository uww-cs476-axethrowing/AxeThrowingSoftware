extends Node2D

var gameTextures = []

var new_pin

# Called when the node enters the scene tree for the first time.
func _ready():
	dir_contents("res://Sprites/MenuButtonSprites/")
	for icon in gameTextures:
		get_node("VBoxContainer/GameItemList").add_icon_item(icon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				gameTextures.append(load("res://Sprites/MenuButtonSprites/" + file_name))
				print("Found file: " + file_name)
			file_name = dir.get_next()
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")


func _on_done_button_button_down():
	get_tree().change_scene_to_file("res://ui/main/menu.tscn")


func _on_game_item_list_item_clicked(index, at_position, mouse_button_index):
	if mouse_button_index == MOUSE_BUTTON_LEFT:
		DevSettings.gameIndex = index
		get_tree().change_scene_to_file("res://ui/main/GameSettings/GameSettings.tscn")


func _on_pin_line_edit_text_changed(new_text):
	if new_text.length() == 4:
		new_pin = new_text


func _on_save_button_button_down():
	if new_pin.length() == 4:
		DevSettings.save_pin("Pin.txt", new_pin)
		DevSettings.pin = new_pin
		get_node("DeveloperSettingsPin/PinBox/SaveButton").text = "Pin Saved!"
