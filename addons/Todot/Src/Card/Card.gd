class_name Card extends Resource

# The card's data
export var name: String
export var description: String
export var checklist: Array

# The init needs to have defaults values or can't load them
func _init(name = "Enter Name", description = "", checklist = []):
	self.name = name
	self.description = description
	self.checklist = checklist
