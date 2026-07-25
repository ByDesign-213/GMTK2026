# start ByDesign
extends Node2D

# start Psuedo Pakman
@export_group("Scenes")
@export var main_menu: PackedScene
@export var monitor: PackedScene

enum GameState {
	MAIN_MENU,
	GAME,
	PAUSE_MENU # add this later
}

var game_state: GameState = GameState.MAIN_MENU:
	set(value):
		if game_state == value:
			return # no change, don't redo work
		game_state = value
		_on_state_changed(value)
		
var current_scene_instance: Node = null
# end Psuedo Pakman

var clock : float = 0.0 # + 9 to it and go to 7 to simulate 9 to 5
var total_emails : int = 0

@export var counter : Label
@export var time : Label

@export var day_duration : float = 300.0

@onready var fake_cursor : Sprite2D = %FakeCursor
var invert := false

func _ready():
	Global.cursor_position = get_viewport().get_mouse_position()
	# start Psuedo Pakman
	# trigger initial setup once
	_on_state_changed(game_state)
	# end Psuedo Pakman
	
	var tween_time = create_tween().tween_property(self, "clock", 8.0, 300.0)
	await tween_time.finished
	print("end game")

func _process(delta):
	counter.text = "Inbox " + str(total_emails)
	
	# clock stuff! :D
	if round(clock + 9) > 12:
		time.text = str(int(fmod(round(clock + 9), 12))) + " PM"
	elif fmod(round(clock + 9), 12) == 0:
		time.text = "12 PM"
	else:
		time.text = str(int(fmod(round(clock + 9), 12))) + " AM"
		
	fake_cursor.global_position = Global.cursor_position

# start Psuedo Pakman
func _on_state_changed(new_state: GameState) -> void:
	# clear out whatever was there before
	if current_scene_instance:
		current_scene_instance.queue_free()
		current_scene_instance = null
		
	match new_state:
		GameState.MAIN_MENU:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			current_scene_instance = main_menu.instantiate()
			add_child(current_scene_instance)
			var play_button = current_scene_instance.get_node("TempPlayButton")
			play_button.play_pressed.connect(_on_play_pressed)
			get_tree().paused = true
		GameState.GAME:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
			Global.cursor_position = get_viewport().get_mouse_position()
			get_tree().paused = false
		GameState.PAUSE_MENU:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_tree().paused = true

func _on_play_pressed() -> void:
	game_state = GameState.GAME
	
	Global.manager.create_emails()
# end Psuedo Pakman
# end ByDesign

func _input(event):
	if event is InputEventMouseMotion:
		if invert:
			Global.cursor_position -= event.relative
		else:
			Global.cursor_position += event.relative
		var screen_size := get_viewport().get_visible_rect().size
		Global.cursor_position.x = clamp(Global.cursor_position.x, 0, screen_size.x)
		Global.cursor_position.y = clamp(Global.cursor_position.y, 0, screen_size.y)
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			Global.fake_mouse_clicked.emit()
		
			
func set_mouse_invert(value: bool):
	invert = value
	
func _notification(what):
	if what == NOTIFICATION_APPLICATION_FOCUS_IN or what == NOTIFICATION_WM_MOUSE_ENTER:
		if (get_viewport() != null and get_viewport().get_mouse_position() != null and not invert):
			Global.cursor_position = get_viewport().get_mouse_position()
			
