extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StartButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://ui/main/modeselect/menu.tscn")


func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://ui/main/options/SetupTeams/SetupTeams.tscn")
	#var options = load("res://ui/main/options/menu.tscn").instance()
	#get_tree().current_scene.add_child(options)


func _on_quit_pressed():
	get_tree().quit()
