extends Node2D
var playerList = PlayerList.global_list
#This array holds the "Frame Row" objects from each "Scoreboard Row" object
var sbArray = []
#This array holds the totals of each player's score
var totals = []
#variables to keep track of current player/frame
var currentFrame = 0
var currentPlayer = 0
#help for adding/setting scores
var tempScoreHolder = 0
#
var styleForCurrent = preload("res://ui/main/options/SetupTeams/BlueButtonStyleNormal.tres")
var styleForNormal = preload("res://ui/main/options/SetupTeams/ButtonStyleNormal.tres")


# Called when the node enters the scene tree for the first time.
func _ready():
	#Loop that sets up scoreboard based on how many players there are
	for index in range(playerList.size()):
		var sbString = "ScoreBoardRow" + str(index + 1)
		var tsString = "TotalScoresContainer/TotalScore" + str(index + 1)
		var current = get_node(sbString)
		var currentTS = get_node(tsString)
		current.show()
		currentTS.show()
		sbArray.append(current.get_child(1))
		current.get_child(0).set_text(playerList[index])
		totals.append(0)
		UpdateCurrentStyle(currentPlayer,currentFrame, styleForCurrent)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func nextPlayer():
	#sets the text of the scoreboard to the clicked number
	sbArray[currentPlayer].get_children()[currentFrame].set_text(str(tempScoreHolder))
	#adds clicked number to player's total score
	totals[currentPlayer] += tempScoreHolder
	#sets the text of the total score
	get_node("TotalScoresContainer").get_child(currentPlayer).set_text(str(totals[currentPlayer]))
	tempScoreHolder = 0
	currentPlayer += 1
	
		#Goes to next frame after last player
	if(currentPlayer > playerList.size() - 1):
		currentPlayer = 0
		currentFrame += 1
	
	#Use this to check who wins after frame 10
	if (currentFrame >= 10):
		var winnerscore = totals.max()
		var winner = totals.rfind(winnerscore)
		print(str(playerList[winner]) + " Wins") 
		return
	#Updating the styles for scoreboard (makes it look better)
	UpdateCurrentStyle(currentPlayer, currentFrame, styleForCurrent)
	var prev = findPreviousPlayer()
	UpdateCurrentStyle(prev[0], prev[1], styleForNormal)

#Used for updating the box style of a player
func UpdateCurrentStyle(player, frame, style):
	var currentsbRow = "ScoreBoardRow" + str(player + 1)
	get_node(currentsbRow).get_child(0).set("theme_override_styles/read_only", style)
	get_node(currentsbRow).get_child(1).get_children()[frame].set("theme_override_styles/read_only", style)
	
#Finds the previous player, even across frames
func findPreviousPlayer():
	if(currentPlayer == 0 and currentFrame == 0):
		return null
	elif(currentPlayer == 0):
		return [playerList.size() - 1, currentFrame - 1]
	else:
		return [currentPlayer - 1, currentFrame]


func _on_ring_1_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			tempScoreHolder += 1
		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			self.nextPlayer()

func _on_ring_2_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			tempScoreHolder += 1

func _on_ring_3_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			tempScoreHolder += 1

func _on_ring_4_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			tempScoreHolder += 1

func _on_ring_5_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			tempScoreHolder += 1

func _on_ring_6_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			tempScoreHolder += 1
