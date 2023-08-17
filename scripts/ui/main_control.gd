extends Node2D

@onready var Controls = $WindowControl


func _ready():
	setup_main_window()
	setup_obs()

func _exit_tree():
	if !ObsWebsocket.password.is_empty():
		PersistentProperties.data["obs_pass"] = ObsWebsocket.password

func setup_main_window():
	var window = get_window()
	var primoryScreen = DisplayServer.get_primary_screen()
	var pos = DisplayServer.screen_get_position(primoryScreen)
	var size = DisplayServer.screen_get_size(primoryScreen)
	#window.current_screen = primoryScreen
	pos = DisplayServer.screen_get_position(window.current_screen)
	size = DisplayServer.screen_get_size(window.current_screen)
	window.borderless = true
	window.transparent = true
	window.transparent_bg = true
	window.mouse_passthrough = true
	window.unfocusable = true
	window.position = Vector2i(pos.x + size.x, pos.y + size.y)
	window.size = Vector2(1920, 1080)

func setup_obs():
	if PersistentProperties.data.has("obs_pass"):
		ObsWebsocket.password = PersistentProperties.data["obs_pass"]
	ObsWebsocket.establish_connection()
