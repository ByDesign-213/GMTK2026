# start ByDesign
extends Node # replace if desired

# i cant figure out how to do this properly
@onready var main : Node2D = get_tree().get_root().get_node("Main") # adjust if needed
@onready var monitor_container : SubViewportContainer = get_tree().get_root().get_node("Main/Monitor")
@onready var manager : Node2D = get_tree().get_root().get_node("Main/Monitor/SubViewport/Manager") # adjust if needed
@onready var audio_manager : Node = get_tree().get_root().get_node("Main/AudioManager") # adjust if needed
var email_open : bool = false
var cursor_position : Vector2 = Vector2.ZERO
signal fake_mouse_clicked
# end ByDesign

func reset_mouse_position() -> void:
	Global.cursor_position = get_viewport().get_mouse_position()

func cursor_pos_in_subviewport(container: SubViewportContainer) -> Vector2:
	var root_viewport := get_tree().root
	var canvas_transform := root_viewport.get_canvas_transform()
	var canvas_pos: Vector2 = canvas_transform.affine_inverse() * Global.cursor_position

	var container_rect := container.get_global_rect()
	var relative_pos := canvas_pos - container_rect.position

	var sub_vp := container.get_child(0) as SubViewport
	var scale_factor := Vector2(sub_vp.size) / container_rect.size
	return relative_pos * scale_factor
