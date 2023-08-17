extends VBoxContainer
class_name SceneAutomaticsRegexItem

@export_node_path("Label") var scene_name_path
@export_node_path("LineEdit") var regex_edit_path
@export_node_path("Button") var save_btn_path

var scene_name: String : set = _set_scene_name, get =_get_scene_name
var scene_item_id: int
var current_regex: String : set = _set_current_regex, get = _get_current_regex

var _current_regex_saved: String

signal regex_changed(scene: String, id: int, regex: String)

func _on_remove_button_pressed():
	queue_free()
	
func _set_scene_name(new_scene_name: String):
	var scene_name_label = get_node(scene_name_path)
	scene_name_label.text = new_scene_name
	
func _get_scene_name() -> String:
	var scene_name_label = get_node(scene_name_path)
	return scene_name_label.text

func _set_current_regex(new_regex: String):
	var regex_edit = get_node(regex_edit_path)
	regex_edit.text = new_regex
	_current_regex_saved = new_regex
	
func _get_current_regex():
	return _current_regex_saved

func _on_save_button_pressed():
	var regex_edit = get_node(regex_edit_path)
	var save_btn = get_node(save_btn_path)
	current_regex = regex_edit.text
	save_btn.disabled = true
	emit_signal("regex_changed", scene_name, scene_item_id, current_regex)

func _on_line_edit_text_changed(new_text):
	var save_btn = get_node(save_btn_path)
	save_btn.disabled = _current_regex_saved == new_text
