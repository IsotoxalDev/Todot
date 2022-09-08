tool
extends PopupMenu

var list: PanelContainer
var items_in_list = ["Add Card", "Copy List", "Move List", "Delete List", "SEP",
	"Move all cards in this list...", "Delete all cards in this list..."]

export var todot: NodePath
export var move_list_menu: NodePath

func edit(rect, list):
	rect.position.y = rect.end.y
	self.list = list
	popup(rect)

func _enter_tree():
	clear()
	add_items()
	connect("add_card", self, "add_card")
	connect("move_list", self, "move_list")

func add_items():
	for item in items_in_list:
		if item == "SEP":
			add_separator()
			continue
		add_item(item, items_in_list.find(item))
		add_user_signal(get_signalified_name(item))

func get_signalified_name(item: String) -> String:
	var sig: String = item.to_lower()
	sig = sig.replace(" ", "_")
	while sig.count("_") >= 3:
		sig = sig.trim_suffix(sig.substr(sig.find_last("_")))
	return sig

func _index_pressed(index):
	emit_signal(get_signalified_name(items_in_list[index]))

func add_card():
	list.add_card_button.hide()
	list.add_card_box.show()
	list.add_card_edit.text =""
	yield(get_tree(), "idle_frame")
	list.add_card_edit.grab_focus()

func move_list():
	var move_menu = get_node(move_list_menu)
	move_menu.popup()
	var editor_theme: Theme = get_node(todot).editor.get_theme()
	var title_height = editor_theme.get_constant("title_height", "WindowDialog")
	move_menu.rect_position = rect_position
	move_menu.rect_position.y += title_height
	var move_list_spin: SpinBox = move_menu.get_node("%MoveListSpin")
	move_menu.get_node("%MoveButton").connect("pressed", self, "move_list_pressed")
	move_menu.get_node("%MoveButton").connect("pressed", move_menu, "hide")
	move_list_spin.max_value = list.get_parent().get_child_count() -1
	move_list_spin.value = list.get_index()

func move_list_pressed():
	var move_menu = get_node(move_list_menu)
	var idx = move_menu.get_node("%MoveListSpin").value
	list.get_parent().move_child(list, idx-1)
