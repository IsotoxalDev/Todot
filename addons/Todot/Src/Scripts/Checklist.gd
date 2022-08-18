tool
extends VBoxContainer

onready var check_item_container = $CheckItemContainer
onready var progress_bar = $ProgressContainer/ProgressBar
onready var percent_label = $ProgressContainer/PercentLabel
onready var title = $TitleContainer/TitleEdit
var check_item = preload("res://addons/Todot/Src/Scenes/CheckItem.tscn")


func remove():
	queue_free()


func auto_nex_text(text :String, max_spaces_in_line: int = 8):
	# Algorithm that adds new line after a given number of words
	var space_count = 0
	var from = 0
	while text.findn(" ", from) != -1:
		var space = text.findn(" ", from)
		space_count += 1
		from = space + 1
		if space_count == max_spaces_in_line:
			text[space] = "\n"
			space_count = 0
	return text


func _on_Add_pressed():
	check_item_container.add_child(check_item.instance())


func _on_TitleEdit_text_changed(new_text: String) -> void:
	title.hint_tooltip = auto_nex_text(new_text)


func _add_check_item(text: String, done: bool):
	var check_itme_inst = check_item.instance()
	check_itme_inst.get_node("LineEdit").text = text
	check_itme_inst.get_node("CheckBox").pressed = done
	check_item_container.add_child(check_itme_inst)


func _process(delta):
	if check_item_container.get_children():
		var finished_task = 0
		if visible && check_item_container:
			for item in check_item_container.get_children():
				finished_task += float(item.get_node("CheckBox").pressed)
			var progress = finished_task/check_item_container.get_child_count()*100
			progress_bar.value = progress
			percent_label.text = str(progress, "%")


func _on_Remove_pressed() -> void:
	remove()
