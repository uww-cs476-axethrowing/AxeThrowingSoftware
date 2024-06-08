extends Node2D

var buttonList = []
# Called when the node enters the scene tree for the first time.
func _ready():
	if PlayerList.global_list.size() == 8:
		$PlusButton.hide()
	create_buttons()

func _process(delta):
	if PlayerList.global_list.size() == 8:
		$PlusButton.hide()

# Function to create and position buttons
func create_buttons():
	var player_button = $Player  # Reference to the original "Player" button
	var button_y = player_button.position.y  # Initial y position

	for i in range(len(PlayerList.global_list)):
		# Duplicate the "Player" button
		var new_button = player_button.duplicate()
		add_child(new_button)  # Add the new button to the scene
		new_button.text = PlayerList.global_list[i]  # Set the button text to the player's name
		
		# Position the new button
		button_y += 50
		new_button.position = Vector2(0, button_y)
		
		#add it to list
		buttonList.append(new_button)
		
		# Connect the button's "pressed" signal to a function using a callable
		new_button.connect("pressed", Callable(self, "_on_Player_button_pressed").bind(i))
	
	$PlusButton.position.y = button_y + 50


func _on_done_button_button_down():
	get_tree().change_scene_to_file("res://ui/main/menu.tscn")

func _on_Player_button_pressed(index):
	PlayerList.currentPlayer = index
	get_tree().change_scene_to_file("res://ui/main/SetupTeams/PlayerEdit.tscn")


func _on_plus_button_button_down():
	PlayerList.currentPlayer = -1
	get_tree().change_scene_to_file("res://ui/main/SetupTeams/PlayerEdit.tscn")
