tool
extends VBoxContainer

onready var check_item_container = $CheckItemContainer
onready var progress_bar = $ProgressContainer/ProgressBar
onready var percent_label = $ProgressContainer/PercentLabel
onready var check_item = preload("res://addons/Todot/Src/Scenes/CheckItem.tscn")


func _on_Button_pressed():
	$CheckItemContainer.add_child(check_item.instance())

func _process(delta):
	var finished_task = 0
	if visible && check_item_container:
		for item in check_item_container.get_children():
			finished_task += float(item.get_node("CheckBox").pressed)
		var progress = finished_task/check_item_container.get_child_count()*100
		progress_bar.value = progress
		percent_label.text = str(progress)
