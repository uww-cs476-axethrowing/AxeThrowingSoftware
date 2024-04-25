extends Node

var numPlayers = 0
var playerList = []

@onready var playerListObject = get_node("PlayerListObject")
@onready var playerNameText = get_node("PlayerLineEdit")

# Called when the node enters the scene tree for the first time.
func _ready():
	playerList = PlayerList.global_list
	numPlayers = playerList.size()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



#Connect Button to Script
func _on_add_player_button_pressed():
	if numPlayers < 8:
		_addPlayer("Player " + str(numPlayers + 1))

#Structure behind adding player
func _addPlayer(name):
	#Add the player to the player list and increment numPlayers
	playerList.append(name)
	numPlayers += 1
	#add the player to the item list so that they can be selected later
	playerListObject.add_item(name)

#connecter for rename button
func _on_rename_player_button_button_down():
	playerNameText.select_all()
	_renamePlayer(playerNameText.get_selected_text(), playerListObject.get_current())

#Sets the player name in both the item list and the respective player object
func _renamePlayer(name, current):
	if(current.size() > 0 and name != ""):
		playerList[current[0]] = name
		playerListObject.set_item_text(current[0], name)

#connecter for remove button
func _on_remove_player_button_button_down():
	if playerListObject.get_current().size() > 0:
		var current = playerListObject.get_current()[0]
		_removePlayer(current)

#removes player from player list
func _removePlayer(current):
	if(playerList.size() > 1):
		playerList.remove_at(current)
		playerListObject.remove_item(current)
		numPlayers -= 1
	

#connecter for done button
func _on_done_button_button_down():
	if(playerList.size() != 0):
		PlayerList.set_List(playerList)
	get_tree().change_scene_to_file("res://ui/main/menu.tscn")
	



