class_name TableDisplay
extends Control

@onready var editor_bar: TextEdit = %EditorBar
@onready var cell_grid: CellGrid = $VBoxContainer/ScrollContainer/Vbox/CellGrid
var cell: Resource = load("res://Cell.tscn")

var table_name: String = ""
var table_data: Dictionary = {}


func populate_key() -> void:
	pass


func add_cell_to_grid() -> Cell:
	var new_cell: Cell = cell.instantiate()
	cell_grid.add_child(new_cell)
	return new_cell


func add_key_to_grid() -> Cell:
	#SAME AS ADD CELL UNTIL I CREATE SPECIAL DISP.AY FOR KEYS
	var new_cell: Cell = cell.instantiate()
	cell_grid.add_child(new_cell)
	return new_cell



func populate_column_headers() -> void:
	for column in table_data[DBManager.COLUMN]:
		add_cell_to_grid().text = column


func populate_cells() -> void:
	#SET GRID SIZE
	cell_grid.set_columns(get_column_count() + cell_grid.get_child_count())
	#POPULATE COLUMN HEADERS
	populate_column_headers()
	#START WITH FIRST KEY, LOOP THROUGH COLUMNS, GO TO NEXT KEY
	for key in table_data[DBManager.ROW]:
		add_key_to_grid().text = key
		print("ROW: ", key)
		for column in table_data[DBManager.COLUMN]:
			add_cell_to_grid().text = str(table_data[DBManager.ROW][key][column])
			print("COLUMN: ", column)


func get_column_count() -> int:
	return table_data[DBManager.COLUMN].size()

func set_cell_data() -> void:
	pass

func connect_editor_bar_to_cell(cell: Cell) -> void:
	print("CELL VALUE: ", cell.text)


func save_table_data() -> void:
	pass


func set_table_data(data_dict: Dictionary) -> void:
	#PASSES THE ADDRESS OF THE CURRENT TABLE FROM THE MAIN DB COPY - ANY CHANGES
	#WILL IMMEDIATLY EFFECT THE MAIN DB COPY FROM TABLE NAVIGATION
	table_data = data_dict


func _on_visibility_changed() -> void:
	print("ACTIVE TABLE DATA: ", table_data)
