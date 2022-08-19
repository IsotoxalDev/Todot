tool
extends HBoxContainer


onready var title: LineEdit = $"%title"

func _on_Remove_pressed() -> void:
	queue_free()


func _on_TitleEdit_text_changed(new_text: String) -> void:
	title.hint_tooltip = auto_nex_text(new_text)


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
