tool
extends Button


onready var list = preload("res://addons/Todot/Src/Scenes/List.tscn")
onready var list_container :HBoxContainer = get_parent()
onready var todot = get_node("../../../")


func add_list():
	var new_list = list.instance()
	list_container.add_child(new_list)
	list_container.move_child(new_list, list_container.get_child_count()-2)
	todot.save()
