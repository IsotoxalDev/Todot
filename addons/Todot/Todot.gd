tool
extends Control

signal fix_list_theme()

var on := false
var drag_data = {}
var editor: Control
var list_panel: StyleBox
var list_scene : PackedScene = preload("res://addons/Todot/Src/List/List.tscn")
onready var card_details: Popup = $"%CardDetails"
onready var add_title_edit: LineEdit = $"%AddTitleEdit"
onready var add_button: Button = $"%AddButton"
onready var add_panel: PanelContainer = $"%Panel"
onready var dialogues: Control = $Dialouges
onready var list_scroll: ScrollContainer = $ListScrollContainer
onready var list_container: HBoxContainer = $"%ListContainer"

func fix_theme():
	theme = null
	if list_panel == editor.get_theme().get_stylebox("read_only", "LineEdit"): return
	list_panel = editor.get_theme().get_stylebox("read_only", "LineEdit")
	emit_signal("fix_list_theme")
	var panel = editor.get_theme().get_stylebox("panel", "WindowDialog")
	panel.border_width_top = 1
	card_details.add_stylebox_override("panel", panel)

func _notification(what):
	match what:
		NOTIFICATION_THEME_CHANGED:
			fix_theme()

func _ready():
	fix_theme()

func save():
	pass
#	var data = []
#	for i in list_container.get_children():
#		if i is Button: continue
#		if i is List_preview: continue
#		var todo_data = []
#		for j in i.card_container.get_children():
#			if j is Button: continue
#			if j is List_preview: continue
#			todo_data.append({
#				'text': j.data.name,
#				'desc': j.data.description,
#				'checklist': j.data.checklist
#			})
#		var list_data = {
#			"title": i.title.title.text,
#			"todos": todo_data
#			}
#
#		data.append(list_data)
#	var file: File = File.new()
#	file.open("res://addons/Todot/data", File.WRITE)
#	file.store_var(data, true)

#func load_data():
#	var file: File = File.new()
#	if file.file_exists("res://addons/Todot/data"):
#		file.open("res://addons/Todot/data", File.READ)
#		var data: Array = file.get_var(true)
#		for i in data:
#			var list = add_list()
#			for j in i.todos:
#				list.add_card(j.data)

func set_data(data):drag_data = data

func clear_data():
	match drag_data["Item"].get_groups()[0]:
		"List":
			var idx = drag_data["Preview"].get_index()
			drag_data["Preview"].queue_free()
			list_container.add_child(drag_data["Item"])
			list_container.move_child(drag_data["Item"], idx)
		"Card":
			var idx = drag_data["Preview"].get_index()
			drag_data["Preview"].queue_free()
			drag_data["List"].card_container.add_child(drag_data["Item"])
			drag_data["List"].card_container.move_child(drag_data["Item"], idx)
	drag_data = null

func _input(event):
	if event is InputEventMouseButton && add_title_edit.has_focus():
		if !add_title_edit.get_global_rect().has_point(get_global_mouse_position()):
			add_button.show()
			add_panel.hide()
	if !event is InputEventMouseMotion:return
	if !drag_data: return
	var mouse_pos = get_local_mouse_position()
	var scroll_horizontal = list_scroll.scroll_horizontal
	var list_size = drag_data["Preview"].rect_size.x+list_container.get_constant("separation")
	var lists_count = list_container.get_child_count()-2
	var xindex = floor((mouse_pos.x+scroll_horizontal)/list_size)
	xindex = 0 if xindex < 0 else xindex if xindex < lists_count else lists_count
	match drag_data["Item"].get_groups()[0]:
		"List":
			if drag_data["Preview"].get_index() == xindex: return
			list_container.move_child(drag_data["Preview"], xindex)
		"Card":
			var list = list_container.get_child(xindex)
			if !drag_data["Preview"] in list.card_container.get_children():
				drag_data["Preview"].get_parent().remove_child(drag_data["Preview"])
				list.card_container.add_child(drag_data["Preview"])
			var scroll_vertical = list_scroll.scroll_vertical
			var title = list.title.rect_size.y
			var card_size = drag_data["Preview"].rect_size.y + list.card_container.get_constant("separation")
			var cards_count = list.card_container.get_child_count()
			var yindex = floor((mouse_pos.y+scroll_vertical+title)/card_size)-2
			yindex = 0 if yindex < 0 else yindex if yindex < cards_count else cards_count
			list.card_container.move_child(drag_data["Preview"], yindex)
			drag_data["List"] = list

func add_list(title = ""):
	if title == "": return
	var list = list_scene.instance()
	list.plugin_rect = get_rect()
	list.add_stylebox_override("panel", list_panel)
	connect("fix_list_theme", list, "fix_theme", [self])
	connect("resized", list, "set_plugin_rect", [self])
	connect("resized", list, "fix_size")
	list.connect("drag_start", self, "set_data")
	list.connect("drag_end", self, "clear_data")
	list.connect("on_edit", self, "save")
	list.connect("card_pressed", card_details, "card_pressed")
	list_container.add_child(list)
	list_container.move_child(list, list_container.get_child_count()-2)
	list.title.title.text = title
	list.title.title_edit.text = title

func add_list_button_pressed(_n = ""):
	if add_title_edit.text != "":
		add_list(add_title_edit.text)
		add_title_edit.text = ""
