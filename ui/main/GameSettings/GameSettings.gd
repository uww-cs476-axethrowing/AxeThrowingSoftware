extends Node2D

var gameIndex
var gameString

# Called when the node enters the scene tree for the first time.
func _ready():
	match DevSettings.gameIndex:
		0:
			get_node("VBoxContainer/GameNameLineEdit").set_text("Connect Four " + "Settings")
			gameString = "connect4"
		1:
			get_node("VBoxContainer/GameNameLineEdit").set_text("Hunter " + "Settings")
			gameString = "hunter"
		2:
			get_node("VBoxContainer/GameNameLineEdit").set_text("Standard Target " + "Settings")
			gameString = "standardTarget"
		3:
			get_node("VBoxContainer/GameNameLineEdit").set_text("Tic Tac Toe " + "Settings")
			gameString = "tictactoe"
	
	for background in DevSettings.backgrounds:
		get_node("VBoxContainer/BackgroundItemList").add_icon_item(load(background))
	gameIndex = DevSettings.gameIndex


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_done_button_button_down():
	get_tree().change_scene_to_file("res://ui/main/DeveloperSettings/DeveloperSettings.tscn")


func _on_background_item_list_item_clicked(index, at_position, mouse_button_index):
	if mouse_button_index == MOUSE_BUTTON_LEFT:
		DevSettings.backgroundDict[gameString] = DevSettings.backgrounds[index]
		DevSettings.save_dict_to_file("backgrounds.txt", DevSettings.backgroundDict)
