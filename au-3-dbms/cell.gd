class_name Cell
extends Control

@warning_ignore("unused_signal")
signal on_cell_value_updated

var cell_key: String
var cell_column: String

func set_cell_address(key: String, column: String) -> void:
	cell_key = key
	cell_column = column
