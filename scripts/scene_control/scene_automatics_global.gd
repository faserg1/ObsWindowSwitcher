extends Node

# scene_name -> {source -> [id, regex]}
var scene_dict = Dictionary()
var current_scene: String
const save_dict_path = "user://scene_control/scene_automatics.json"
const save_dict_dir_path = "user://scene_control/"

const OpCodeRequestResponse = ObsWebsocket.OpCodeEnums.WebSocketOpCode.RequestResponse.IDENTIFIER_VALUE
const OpCodeEvent = ObsWebsocket.OpCodeEnums.WebSocketOpCode.Event.IDENTIFIER_VALUE

signal current_scene_changed(scene_name: String)

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	load_regex_dict()
	ObsWebsocket.connect("data_received", on_data_received)
	if ObsWebsocket._poll_handler == ObsWebsocket._handle_data_received:
		obs_ready()
	else:
		ObsWebsocket.connect("connection_authenticated", obs_ready)
	WindowHelperScript.connect("window_changed", on_window_changed)

func obs_ready():
	ObsWebsocket.send_command("GetCurrentProgramScene")

func on_window_changed(window_name: String):
	#print(window_name)
	if !scene_dict.has(current_scene):
		return
	var current_scene_regex_dict = scene_dict[current_scene]
	for regex_key in current_scene_regex_dict:
		var regex_item_id = current_scene_regex_dict[regex_key][0]
		var regex_promt = current_scene_regex_dict[regex_key][1]
		var re = RegEx.new()
		re.compile(regex_promt)
		var result = re.search(window_name)
		#print(result)
		#print(regex_promt)
		enable_scene_item(regex_item_id, !!result)

func enable_scene_item(id: int, enable: bool):
	var data = {
		"sceneName": current_scene,
		"sceneItemId": id,
		"sceneItemEnabled": enable
	}
	ObsWebsocket.send_command("SetSceneItemEnabled", data)

func on_data_received(update: ObsWebsocket.ObsMessage):
	match update.op:
		OpCodeRequestResponse:
			on_response(update)
		OpCodeEvent:
			on_event(update)

func on_response(response: ObsWebsocket.RequestResponse):
	match response.request_type:
		"GetCurrentProgramScene":
			current_scene = response.response_data["currentProgramSceneName"]
			emit_signal("current_scene_changed", current_scene)

func on_event(event: ObsWebsocket.Event):
	match event.event_type:
		"CurrentProgramSceneChanged":
			current_scene = event.event_data["sceneName"]
			emit_signal("current_scene_changed", current_scene)

func load_regex_dict():
	if FileAccess.file_exists(save_dict_path):
		scene_dict = JSON.parse_string(FileAccess.get_file_as_string(save_dict_path))
	
func save_regex_dict():
	if !DirAccess.dir_exists_absolute(save_dict_dir_path):
		DirAccess.make_dir_recursive_absolute(save_dict_dir_path)
	var str = JSON.stringify(scene_dict)
	var file = FileAccess.open(save_dict_path, FileAccess.WRITE)
	file.store_string(str)
	file.flush()
