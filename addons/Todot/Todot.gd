tool
extends Control


var on := false
onready var mouse : Control = $Mouse
onready var dialogues : Control = $Dialouges
onready var list_container :HBoxContainer = $ListScrollContainer/ListContainer
var preview : PackedScene = preload("res://addons/Todot/Src/Scenes/Preview.tscn")
var list : PackedScene = preload("res://addons/Todot/Src/Scenes/List.tscn")

func _ready():
	load_data()

func save():
	var data = []
	for i in list_container.get_children():
		if i is Button: continue
		if i is List_preview: continue
		var todo_data = []
		for j in i.todo_container.get_children():
			if j is Button: continue
			if j is List_preview: continue
			todo_data.append({
				'text': j.text,
				'desc': j.desc,
				'checklist': j.checklist
			})
		var list_data = {
			"title": i.title.title.text,
			"todos": todo_data
			}

		data.append(list_data)
	var file: File = File.new()
	file.open("res://addons/Todot/data", File.WRITE)
	file.store_var(data, true)

func load_data():
	var file: File = File.new()
	if file.file_exists("res://addons/Todot/data"):
		file.open("res://addons/Todot/data", File.READ)
		var data: Array = file.get_var(true)
		for i in data:
			var list_instance = list.instance()
			list_container.add_child(list_instance)
			list_container.move_child(list_instance, list_container.get_child_count()-2)
			list_instance.title.title.text = i.title
			list_instance.title.title_edit.text = i.title
			list_instance.title.title_edit.hide()
			for j in i.todos:
				var todo = list_instance.add_todo()
				todo.set_text(j.text)
				todo.desc = j.desc
				todo.checklist = j.checklist

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
		list_container.move_child(object, (mouse.list_index if mouse.list_index != -1 else 0))
		list_container.queue_sort()

	elif object.is_in_group("Todo"):
		var list = list_container.get_child(mouse.todo_index.x)
		list.get_node("VBox/VBox").add_child(object)
		object.get_parent().move_child(object, mouse.todo_index.y)
		object.get_parent().queue_sort()
