tool
extends Control


var list_index :  int = 0
var todo_index : Vector2
var preview : PanelContainer
var mousepos : Vector2
onready var todot : Control = get_parent()


func _input(event):
	if event is InputEventMouseMotion:
		for child in get_children():
			child.rect_position += event.relative
			mousepos = todot.get_local_mouse_position()

			if child.is_in_group("List"):
				if list_index != get_list_index(child):
					list_index = get_list_index(child)
					preview.get_parent().move_child(preview, list_index if list_index != -1 else 0)

			if child.is_in_group("Todo"):
				if todo_index != get_todo_index(child):
					todo_index = get_todo_index(child)
					preview.get_parent().remove_child(preview)
					var list = todot.list_container.get_child(todo_index.x)
					list.get_node("VBox/VBox").add_child(preview)

					if todo_index.y < 0:
						todo_index.y = 0
					preview.get_parent().move_child(preview, todo_index.y)


func get_list_index(list : PanelContainer):
	var index = preview.get_index()
	var dist = list.get_size().x+30

	while mousepos.x >= dist*index:
		index+=1

	if index < 0:
		index = 1

	if index >= todot.list_container.get_child_count():
		index = todot.list_container.get_child_count() -1

	return index-1


func get_todo_index(todo : Control):
	var todo_index = Vector2()
	todo_index.x = preview.get_node("../../../").get_index()
	todo_index.y = preview.get_index()
	var dist = Vector2()
	dist.x = todo.list.get_size().x + 30
	var title_size =  preview.get_node("../../ListTitle").get_size().y
	while mousepos.x >= dist.x*todo_index.x:
		todo_index.x += 1

	if todo_index.x < 0:
		todo_index.x = 0

	if todo_index.x > todot.list_container.get_child_count():
		todo_index.x = todot.list_container.get_child_count()

	var size = 0
	var list = todot.list_container.get_child(todo_index.x-1)
	for i in range(todo_index.y):
		if list.get_node("VBox/VBox").get_child(i) and list:
			size = list.get_node("VBox/VBox").get_child(i).get_end().y
	while todo.get_position().y >= title_size + size:
		todo_index.y += 1
		if list.get_node("VBox/VBox").get_child_count() > todo_index.y:
			size += list.get_node("VBox/VBox").get_child(todo_index.y).get_size().y
		else:	break

	if todo_index.y < 0:
		todo_index.y = 1

	if todo_index.y > preview.get_parent().get_child_count():
		todo_index.y = preview.get_parent().get_child_count()

	return todo_index - Vector2(1, 2)
