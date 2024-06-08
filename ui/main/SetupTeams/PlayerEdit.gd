extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if PlayerList.currentPlayer != -1:
		get_node("PlayerNameLineEdit").set_text(PlayerList.global_list[PlayerList.currentPlayer])
	else:
		get_node("PlayerNameLineEdit").set_text("Player " + str(len(PlayerList.global_list) + 1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_save_button_button_down():
	if PlayerList.currentPlayer == -1:
		PlayerList.global_list.append($PlayerNameLineEdit.get_text())
	else:
		PlayerList.global_list[PlayerList.currentPlayer] = $PlayerNameLineEdit.get_text()
	get_tree().change_scene_to_file("res://ui/main/SetupTeams/SetTeams.tscn")
	


func _on_remove_button_button_down():
	if PlayerList.global_list.size() > 1:
		_removePlayer(PlayerList.currentPlayer)
	else:
		get_tree().change_scene_to_file("res://ui/main/SetupTeams/SetTeams.tscn")

#removes player from player list
func _removePlayer(current):
	if(current != -1):
		PlayerList.global_list.remove_at(current)
	get_tree().change_scene_to_file("res://ui/main/SetupTeams/SetTeams.tscn")
