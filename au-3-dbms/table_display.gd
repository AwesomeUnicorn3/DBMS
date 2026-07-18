class_name TableDisplay
extends Control

@onready var table_name_display: Label = %TableNameDisplay
@onready var cell_grid: CellGrid = $VBoxContainer/ScrollContainer/Vbox/CellGrid

#PLACEHOLDER UNTIL I CREATE UNIQUE COLUMN AND KEY NODES
var cell: Resource = load("res://TextInputCell.tscn")
var table_dict: Dictionary = {}
var table_name: String = ""


func load_table_data(tbl_name: String, tbl_data: Dictionary) -> void:
	set_table_name(tbl_name)
	set_table_data(tbl_data)
	populate_cells()


func set_table_name(tbl_name: String) -> void:
	table_name_display.set_text(tbl_name)
	table_name = tbl_name


func add_cell_to_grid(cell_type: String) -> Cell:
	var datatype_cell: Resource = load("res://" + cell_type + ".tscn")
	var new_cell: Cell = datatype_cell.instantiate()
	cell_grid.add_child(new_cell)
	new_cell.on_cell_value_updated.connect(update_cell_value_in_table,1)
	return new_cell


func add_column_header_to_grid() -> Cell:
	#NEED TO CREATE UNIQUE NODE FOR COLUMNS
	var new_cell: Cell = cell.instantiate()
	cell_grid.add_child(new_cell)
	return new_cell


func create_and_add_key_to_grid() -> Cell:
	#NEED TO CREATE UNIQUE NODE FOR KEYS
	var new_cell: Cell = cell.instantiate()
	cell_grid.add_child(new_cell)
	return new_cell


func populate_column_headers() -> void:
	for column in table_dict[DBManager.COLUMN]:
		add_column_header_to_grid().set_value(column)


func populate_cells() -> void:
	cell_grid.set_columns(get_column_count() + cell_grid.get_child_count())
	populate_column_headers()
	for key in table_dict[DBManager.ROW]:
		create_and_add_key_to_grid().set_value(key)
		for column in table_dict[DBManager.COLUMN]:
			var datatype: String = table_dict[DBManager.COLUMN][column]["datatype"]
			var new_cell: Cell = add_cell_to_grid(datatype)
			
			new_cell.set_value(str(table_dict[DBManager.ROW][key][column]))
			new_cell.set_cell_address(key,column)


func update_cell_value_in_table(updated_cell: Cell) -> void:
	var row: String = updated_cell.cell_key
	var column: String = updated_cell.cell_column
	
	table_dict[DBManager.ROW][row][column] = updated_cell.get_value()


func get_column_count() -> int:
	return table_dict[DBManager.COLUMN].size()


func set_cell_data() -> void:
	pass


func set_table_data(table_data: Dictionary) -> void:
	table_dict = table_data


func _on_visibility_changed() -> void:
	pass
