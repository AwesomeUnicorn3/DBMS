class_name TextInputCell
extends Cell

@onready var text_edit: TextEdit = $TextEdit

var value:String = ""


func set_value(new_value:String) -> void:
	value = new_value
	text_edit.set_text(new_value)
