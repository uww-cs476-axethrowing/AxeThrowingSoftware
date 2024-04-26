extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_quit_pressed():
	get_tree().quit()

func _on_setup_teams_menu_bt_pressed():
	get_tree().change_scene_to_file("res://ui/main/SetupTeams/SetupTeams.tscn")


func _on_standard_target_menu_bt_pressed():
	get_tree().change_scene_to_file("res://gamemodes/Traditional Game/TraditionalGame.tscn")


func _on_tic_tac_toe_menu_bt_button_down():
	get_tree().change_scene_to_file("res://gamemodes/Tic Tac Toe/TicTacToe.tscn")


func _on_hunter_menu_bt_button_down():
	pass # Replace with function body.


func _on_connect_four_bt_button_down():
	get_tree().change_scene_to_file("res://gamemodes/connect4/Connect4Game.tscn")
