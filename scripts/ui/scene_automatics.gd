extends Window

@export_node_path("OptionButton") var scene_select_path
@export_node_path("OptionButton") var scene_item_select_path
@export_node_path("VBoxContainer") var regex_container_path

@onready var regex_scene = preload("res://scenes/ui/scene_automatics_regex_item.tscn")

const OpCodeRequestResponse = ObsWebsocket.OpCodeEnums.WebSocketOpCode.RequestResponse.IDENTIFIER_VALUE

func _ready():
	ObsWebsocket.connect("data_received", on_data_received)
	if ObsWebsocket._poll_handler == ObsWebsocket._handle_data_received:
		obs_ready()
	else:
		ObsWebsocket.connect("connection_authenticated", obs_ready)

func _on_close_requested():
	queue_free()

func obs_ready():
	ObsWebsocket.send_command("GetSceneList")

func on_data_received(update: ObsWebsocket.ObsMessage):
	match update.op:
		OpCodeRequestResponse:
			on_response(update)

func on_response(response: ObsWebsocket.RequestResponse):
	match response.request_type:
		"GetSceneList":
			SceneAutomaticsGlobal.current_scene = response.response_data["currentProgramSceneName"]
			var scenes = response.response_data["scenes"]
			fill_scenes(scenes)
		"GetSceneItemList":
			on_scene_items_received(response.response_data["sceneItems"])

func fill_scenes(scenes: Array):
	if !SceneAutomaticsGlobal.scene_dict.has(SceneAutomaticsGlobal.current_scene):
		SceneAutomaticsGlobal.scene_dict[SceneAutomaticsGlobal.current_scene] = Dictionary()
	var scene_select = get_node(scene_select_path) as OptionButton
	scene_select.clear()
	var idx = 0
	for scene in scenes:
		var scene_name = scene["sceneName"]
		scene_select.add_item(scene_name)
		if SceneAutomaticsGlobal.current_scene == scene_name:
			scene_select.select(idx)
			_on_scene_select_item_selected(idx)
		idx += 1

func _on_scene_select_item_selected(index):
	var scene_select = get_node(scene_select_path) as OptionButton
	var scene_name = scene_select.get_item_text(index)
	ObsWebsocket.send_command("GetSceneItemList", {"sceneName": scene_name})

func on_scene_items_received(scene_items: Array):
	var scene_item_select = get_node(scene_item_select_path) as OptionButton
	for scene_item in scene_items:
		var scene_item_name = scene_item["sourceName"]
		var scene_item_id = int(scene_item["sceneItemId"])
		scene_item_select.add_item(scene_item_name, scene_item_id)
		var current_scene_dict = SceneAutomaticsGlobal.scene_dict[SceneAutomaticsGlobal.current_scene]
		if current_scene_dict.has(scene_item_name):
			var regex_info = current_scene_dict[scene_item_name]
			add_regex_item(scene_item_name, scene_item_id)
	#sceneItemEnabled
	#sourceName
	#print(scene_items)


func _on_scene_item_add_pressed():
	var scene_item_select = get_node(scene_item_select_path) as OptionButton
	var current_source_name = scene_item_select.get_item_text(scene_item_select.selected)
	var current_scene_item_id = scene_item_select.get_item_id(scene_item_select.selected)
	add_regex_item(current_source_name, current_scene_item_id)
	

func add_regex_item(scene_name: String, scene_id: int):
	var container = get_node(regex_container_path) as VBoxContainer
	var scene_items = SceneAutomaticsGlobal.scene_dict[SceneAutomaticsGlobal.current_scene]
	var instance = regex_scene.instantiate()
	instance.scene_name = scene_name
	instance.scene_item_id = scene_id
	if scene_items.has(scene_name):
		instance.current_regex = scene_items[scene_name][1]
	instance.connect("regex_changed", _on_scene_item_changed)
	container.add_child(instance)

func _on_scene_item_changed(source_name: String, id: int, new_regex: String):
	var scene_items = SceneAutomaticsGlobal.scene_dict[SceneAutomaticsGlobal.current_scene]
	scene_items[source_name] = [id, new_regex]
	SceneAutomaticsGlobal.save_regex_dict()

