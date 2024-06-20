extends Node

var gameIndex
var pin
var backgrounds = []
var backgroundDict = {
	"standardTarget" : "",
	"hunter" : "",
	"tictactoe" : "",
	"connect4" : ""
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pin = findPin("user://Pin.txt")
	if pin.length() > 4:
		pin = "2626"
	
	dir_contents("res://Backgrounds/")
	if !load_dict_from_file("backgrounds.txt").is_empty():
		backgroundDict = load_dict_from_file("backgrounds.txt")
	print(backgroundDict)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func findPin(file_path: String) -> String:
	var file := FileAccess.open(file_path, FileAccess.READ)
	if file:
		var first_line = file.get_line()
		file.close()
		return first_line
	else:
		return "Error: Unable to open file"

# Function to save a pin to a file
func save_pin(file_name: String, pin_content: String) -> void:
	# Construct the full file path in the user:// directory
	var user_file_path = "user://" + file_name
	
	# Open the file for writing
	var file = FileAccess.open(user_file_path, FileAccess.WRITE)
	if file:
		# Write the pin content to the file
		file.store_string(pin_content)
		file.close()
		print("Pin saved successfully to ", user_file_path)
	else:
		print("Error: Unable to open file for writing.")

func dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				DevSettings.backgrounds.append("res://Backgrounds/" + file_name)
				print("Found file: " + file_name)
			file_name = dir.get_next()
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

# Function to save a dictionary to a file
func save_dict_to_file(file_name: String, dictionary: Dictionary) -> void:
	# Convert the dictionary to a JSON string
	var json_string = JSON.stringify(dictionary)
	
	# Construct the full file path in the user:// directory
	var user_file_path = "user://" + file_name
	
	# Open the file for writing
	var file = FileAccess.open(user_file_path, FileAccess.WRITE)
	if file:
		# Write the JSON string to the file
		file.store_string(json_string)
		file.close()
		print("Dictionary saved successfully to ", user_file_path)
	else:
		print("Error: Unable to open file for writing.")
	

# Function to load a dictionary from a file
func load_dict_from_file(file_name: String) -> Dictionary:
	# Construct the full file path in the user:// directory
	var user_file_path = "user://" + file_name
	
	# Open the file for reading
	var file = FileAccess.open(user_file_path, FileAccess.READ)
	if file:
		# Read the entire file content as a string
		var json_string = file.get_as_text()
		file.close()
		
		# Parse the JSON string back into a dictionary
		var dictionary = JSON.parse_string(json_string)
		if dictionary is Dictionary:
			print("Dictionary loaded successfully from ", user_file_path)
			return dictionary
		else:
			print("Error: Failed to parse JSON into dictionary.")
			return {}
	else:
		print("Error: Unable to open file for reading.")
		return {}
