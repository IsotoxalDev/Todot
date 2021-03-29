tool
extends PanelContainer

onready var todo_container = $VBox/VBox
onready var todo = preload("res://addons/Todot/Src/Scenes/Todo.tscn")


func _on_Button_pressed():
	var new_todo = todo.instance()
	todo_container.add_child(new_todo)
	todo_container.move_child(new_todo, todo_container.get_child_count()-2)
