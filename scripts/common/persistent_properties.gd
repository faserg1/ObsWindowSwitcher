extends Node

var data = Dictionary()
const fname = "user://persistent.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	load_properties()
	
func _exit_tree():
	save_properties()

func save_properties():
	var content = JSON.stringify(data)
	var file = FileAccess.open(fname, FileAccess.WRITE)
	file.store_string(content)

func load_properties():
	var file = FileAccess.open(fname, FileAccess.READ)
	if file:
		data = JSON.parse_string(file.get_as_text()) as Dictionary
