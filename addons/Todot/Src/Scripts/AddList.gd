tool
extends PanelContainer


onready var list = preload("res://addons/Todot/Src/Scenes/List.tscn")
onready var list_container :HBoxContainer = get_parent()


func _on_ListTitle_on_enter_pressed():
	add_list()


func add_list():
	var new_list = list.instance()
	list_container.add_child(new_list)
	list_container.move_child(new_list, list_container.get_child_count()-2)
