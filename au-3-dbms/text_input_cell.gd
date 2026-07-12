class_name TextInputCell
extends Cell


@onready var text_edit: TextEdit = $TextEdit

var value:String = ""

func _ready() -> void:
	text_edit.text_changed.connect(set_value)


func set_value(new_value:String = text_edit.get_text()) -> void:
	if new_value != text_edit.get_text():
		text_edit.set_text(new_value)
	on_cell_value_updated.emit(self)
	value = new_value
	


func get_value() -> String:
	return value
