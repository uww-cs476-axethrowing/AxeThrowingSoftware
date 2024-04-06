extends Node

var numPlayers = 0
var playerList = []
var currentPlayerIndex = 0
@onready var playerListObject = get_node("PlayerListObject")
@onready var playerNameText = get_node("PlayerLineEdit")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



#Connect Button to Script
func _on_add_player_button_pressed():
	if numPlayers < 8:
		_addPlayer("Player " + str(numPlayers + 1))

#Structure behind adding player
func _addPlayer(name):
	#Create a new player object and give it the Player script
	var newPlayer = Object.new()
	const newPlayerScript = preload("res://ui/main/options/SetupTeams/Player.gd")
	newPlayer.set_script(newPlayerScript)
	#Add the player to the player list and increment numPlayers
	playerList.append(newPlayer)
	numPlayers += 1
	#set the players name to the default name "player n"
	newPlayer.set_playerName(name)
	#add the player to the item list so that they can be selected later
	playerListObject.add_item(name, newPlayer, true)



func _removePlayer(name):
	playerList.remove(name)
	numPlayers -= 1
	
func _nextPlayer(currentPlayerIndex):
	currentPlayerIndex += 1
	if(currentPlayerIndex >= numPlayers):
		currentPlayerIndex = 0
		

#connector for rename button
func _on_rename_player_button_button_down():
	playerNameText.select_all()
	_renamePlayer(playerNameText.get_selected_text(), playerListObject.get_current())

#Sets the player name in both the item list and the respective player object
func _renamePlayer(name, current):
	if(current.size() > 0 and name != ""):
		playerList[current[0]].set_playerName(name)
		playerListObject.set_item_text(current[0], name)
