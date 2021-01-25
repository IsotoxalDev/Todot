tool
extends Control


var on := false
var preview : PackedScene = preload("res://addons/Todot/Src/Scenes/Preview.tscn")
onready var mouse : Control = $Mouse
onready var list_container :HBoxContainer = $ListScrollContainer/ListContainer


func to_mouse(object : Control, offset):
	var new_preview : List_preview= preview.instance()
	object.get_parent().add_child(new_preview)
	new_preview.get_parent().move_child(new_preview, object.get_index())
	new_preview.init(object.rect_size)
	mouse.preview = new_preview
	object.get_parent().remove_child(object)
	mouse.add_child(object)
	object.set_global_position(get_global_mouse_position()-offset)

func to_list(object : Node):
	mouse.remove_child(object)
	mouse.preview.queue_free()
	mouse.preview = null

	if object.is_in_group("List"):
		list_container.add_child(object)
		list_container.move_child(object, mouse.list_index)
		list_container.queue_sort()

	elif object.is_in_group("Todo"):
		var list = list_container.get_child(mouse.todo_index.x)
		list.get_node("VBox/VBox").add_child(object)
		object.get_parent().move_child(object, mouse.todo_index.y)
		object.get_parent().queue_sort()
