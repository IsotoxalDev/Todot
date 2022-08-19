tool
extends PanelContainer


onready var todo_container: VBoxContainer = $"%TodoContainer"
onready var title: Button = $"%ListTitle"
onready var todot: Control = get_node("../../../")
var todo = preload("res://addons/Todot/Src/Scenes/Todo.tscn")


func _ready():
	var t = todot.get_theme().get_stylebox("read_only", "LineEdit")
	add_stylebox_override("panel", t)

func _on_Button_pressed():
	var _n = add_todo()
	todot.save()


func add_todo():
	var new_todo = todo.instance()
	todo_container.add_child(new_todo)
	todo_container.move_child(new_todo, todo_container.get_child_count()-2)
	return new_todo

func remove():
	get_parent().remove_child(self)
	queue_free()
