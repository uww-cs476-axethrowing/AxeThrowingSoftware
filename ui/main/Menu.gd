extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var user_data_path = OS.get_user_data_dir()
	print("User data directory: ", user_data_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pin"):
		get_node("DeveloperSettingsPin").show()
		get_node("DeveloperSettingsPin/PinBox/PinLineEdit").grab_focus()
	

func _on_quit_pressed():
	get_tree().quit()

func _on_setup_teams_menu_bt_pressed():
	get_tree().change_scene_to_file("res://ui/main/SetupTeams/SetTeams.tscn")


func _on_standard_target_menu_bt_pressed():
	get_tree().change_scene_to_file("res://gamemodes/Traditional Game/TraditionalGame.tscn")


func _on_tic_tac_toe_menu_bt_button_down():
	get_tree().change_scene_to_file("res://gamemodes/TicTacToe/TicTacToe.tscn")


func _on_hunter_menu_bt_button_down():
	get_tree().change_scene_to_file("res://gamemodes/Hunter/Hunter.tscn")


func _on_connect_four_bt_button_down():
	get_tree().change_scene_to_file("res://gamemodes/connect4/Connect4Game.tscn")


func _on_quit_button_button_down():
	get_node("DeveloperSettingsPin/PinBox/PinLineEdit").clear()
	get_node("DeveloperSettingsPin").hide()


func _on_pin_line_edit_text_changed(new_text):
	if new_text == DevSettings.pin:
		get_tree().change_scene_to_file("res://ui/main/DeveloperSettings/DeveloperSettings.tscn")
	elif new_text.length() == 4:
		get_node("DeveloperSettingsPin/PinBox/EnterPinLineEdit").set_text("Incorrect Pin")
		get_node("DeveloperSettingsPin/PinBox/PinLineEdit").clear()
	else:
		await get_tree().create_timer(3).timeout
		get_node("DeveloperSettingsPin/PinBox/EnterPinLineEdit").set_text("Enter Pin")
