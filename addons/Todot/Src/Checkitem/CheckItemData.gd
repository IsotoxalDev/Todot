class_name CheckItem extends Resource

export var name: String
export var done: bool

func _init(name: String = "", done: bool= false):
	self.name = name; self.done = done
