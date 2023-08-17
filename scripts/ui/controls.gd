extends Window

@onready var sceneAutomaticsWindow = preload("res://scenes/ui/scene_automatics.tscn")

func _on_scene_automatics_btn_pressed():
	var scene = sceneAutomaticsWindow.instantiate()
	add_child(scene)

func _on_close_requested():
	get_tree().quit()
