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
#Styles for buttons
var styleForCurrent = preload("res://ui/main/SetupTeams/BlueButtonStyleNormal.tres")
var styleForNormal = preload("res://ui/main/SetupTeams/ButtonStyleNormal.tres")
#var that will control when animation plays 
var winnerbool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#Setting winner lable to hide
	get_node("WinnerText").hide()
	#Sets the y position of the bottom buttons based on how many players there are
	get_node("BottomButtonsContainer").position.y = (playerList.size() * 31) + 2
	#Loop that sets up scoreboard based on how many players there are
	for index in range(playerList.size()):
		var sbString = "Scoreboard/ScoreBoardRow" + str(index + 1)
		var tsString = "Scoreboard/TotalScoresContainer/TotalScore" + str(index + 1)
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
	var move_speed = 500.0
	var rotSpeed = 9
	if winnerbool:
		get_node("WinnerPath/WinnerPathFollow").progress += move_speed * delta
		get_node("WinnerPath/WinnerPathFollow/WinnerAxe").rotation += rotSpeed * delta
	if get_node("WinnerPath/WinnerPathFollow").progress > 290:
		winnerbool = false

func nextPlayer():
	get_node("target/HitTimer").start()
	if tempScoreHolder < 8 and tempScoreHolder != 0:
		targetAnimation(tempScoreHolder)
	await get_node("target/HitTimer").timeout
	get_node("target/HitTimer").stop()
	if(currentFrame != 10): #Added to prevent clicking the target after the last frame from crashing the program
		#sets the text of the scoreboard to the clicked number
		sbArray[currentPlayer].get_children()[currentFrame].set_text(str(tempScoreHolder))
		#adds clicked number to player's total score
		totals[currentPlayer] += tempScoreHolder
		#sets the text of the total score
		get_node("Scoreboard/TotalScoresContainer").get_child(currentPlayer).set_text(str(totals[currentPlayer]))
		tempScoreHolder = 0
		currentPlayer += 1
		
		#Goes to next frame after last player
	if(currentPlayer > playerList.size() - 1):
		currentPlayer = 0
		currentFrame += 1
	#Use this to check who wins after frame 10
	if findWinner():
		return
	#Updating the styles for scoreboard (makes it look better)
	UpdateCurrentStyle(currentPlayer, currentFrame, styleForCurrent)
	var prev = findPreviousPlayer()
	UpdateCurrentStyle(prev[0], prev[1], styleForNormal)
	#killshots
	if(currentFrame == 4 or currentFrame == 9):
		get_node("target/KillshotArea").show()
		get_node("target/KillshotArea2").show()
	else:
		get_node("target/KillshotArea").hide()
		get_node("target/KillshotArea2").hide()

#Used for updating the box style of a player
func UpdateCurrentStyle(player, frame, style):
	if(currentFrame != 10): #Added to prevent clicking undo after the last frame from crashing the program
		var currentsbRow = "Scoreboard/ScoreBoardRow" + str(player + 1)
		get_node(currentsbRow).get_child(0).set("theme_override_styles/read_only", style)
		get_node(currentsbRow).get_child(1).get_children()[frame].set("theme_override_styles/read_only", style)
	
#Finds the previous player, even across frames
#Returns a list: [prev player index, prev frame]
func findPreviousPlayer():
	if(currentPlayer == 0 and currentFrame == 0):
		return [0, 0]
	elif(currentPlayer == 0):
		return [playerList.size() - 1, currentFrame - 1]
	else:
		return [currentPlayer - 1, currentFrame]

#For displaying the winner
func showWinner(winnerName):
	winnerbool = true
	get_node("WinnerText").set_text(str(winnerName) + " Wins!")
	get_node("wintimer").start()

func findWinner():
	if (currentFrame >= 10):
		var winnerscore = totals.max()
		var winner = totals.rfind(winnerscore)
		print(str(playerList[winner]) + " Wins") 
		showWinner(playerList[winner])
		return true

#Animation on target click
func targetAnimation(start):
	var textureArray = []
	#set textures to green
	for i in range(start, 0, -1):
		textureArray.append(get_node("target/Ring" + str(i) + "Area/Ring" + str(i) + "Sprite").get_texture())
		var newTexture = load("res://Sprites/Ring" + str(i) + "Green.png")
		get_node("target/Ring" + str(i) + "Area/Ring" + str(i) + "Sprite").set_texture(newTexture)
		await get_tree().create_timer(.05).timeout
	#set textures back
	textureArray.reverse()
	for i in range(start, 0, -1):
		get_node("target/Ring" + str(i) + "Area/Ring" + str(i) + "Sprite").set_texture(textureArray[i-1])
		await get_tree().create_timer(.05).timeout

#wait for previous hit
func wait():
	return get_node("target/HitTimer").is_stopped()

#Connectors
func _on_ring_1_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if wait():
				tempScoreHolder += 1
		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed and currentFrame != 10:
			if wait():
				self.nextPlayer()

func _on_ring_2_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if wait():
				tempScoreHolder += 1

func _on_ring_3_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if wait():
				tempScoreHolder += 1

func _on_ring_4_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if wait():
				tempScoreHolder += 1

func _on_ring_5_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if wait():
				tempScoreHolder += 1

func _on_ring_6_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if wait():
				tempScoreHolder += 1

func _on_miss_button_button_down():
	if(currentFrame != 10):
		if wait():
			nextPlayer()

func _on_undo_button_button_down():
	if(currentFrame != 10): #Added to prevent clicking undo after the last frame from crashing the program
		#finds prev player
		var prev = findPreviousPlayer()
		#Changes styles to reflect current player
		UpdateCurrentStyle(currentPlayer, currentFrame, styleForNormal)
		UpdateCurrentStyle(prev[0], prev[1], styleForCurrent)
		#Updates current variables
		currentPlayer = prev[0]
		currentFrame = prev[1]
		#finds the point that was last clicked
		var lastPoint = int(sbArray[currentPlayer].get_children()[currentFrame].get_text())
		#Updates total
		totals[currentPlayer] -= lastPoint
		get_node("Scoreboard/TotalScoresContainer").get_child(currentPlayer).set_text(str(totals[currentPlayer]))
		#Updates scoreboard text
		sbArray[currentPlayer].get_children()[currentFrame].set_text("")

func _on_new_game_button_button_down():
	get_tree().change_scene_to_file("res://gamemodes/Traditional Game/TraditionalGame.tscn")

func _on_main_menu_button_button_down():
	get_tree().change_scene_to_file("res://ui/main/menu.tscn")

func _on_wintimer_timeout():
	get_node("WinnerText").show()

func _on_killshot_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			tempScoreHolder += 7

func _on_killshot_area_2_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			tempScoreHolder += 7
