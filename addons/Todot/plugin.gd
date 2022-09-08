tool
extends EditorPlugin

const todot : PackedScene = preload("res://addons/Todot/Todot.tscn")
const todot_icon: Texture = preload("res://addons/Todot/Assets/TodotIcon.svg")

var editor
var todot_instance

func _enter_tree():
	editor = get_editor_interface().get_base_control()
	todot_instance = todot.instance()
	todot_instance.editor = editor
	get_editor_interface().get_editor_viewport().add_child(todot_instance)
	make_visible(false)

func _exit_tree():
	if todot_instance:
		todot_instance.queue_free()

func has_main_screen():
	return true

func make_visible(visible):
	if todot_instance:
		todot_instance.visible = visible

func get_plugin_name(): return "Todot"

func get_plugin_icon(): return todot_icon
