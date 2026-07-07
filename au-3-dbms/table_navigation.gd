class_name TableNavigation
extends VBoxContainer

@onready var table_list: Array = []
@onready var table_buttons: HBoxContainer = %TableButtons
@onready var button_template: Resource = load("res://TableButton.tscn")
@onready var table_template: Resource = load("res://TableDisplay.tscn")

var active_table_name: String = ""
var open_table_dict: Dictionary = {}
#THIS IS THE MAIN DB THAT WILL BE USED TO CHANGE DATA BY ALL SCRIPTS. ONCE WE ARE READY
#TO SAVE THE DB TO DISK, WE WILL PASS THIS ONE TO THE DBMANAGER
var DB_copy: Dictionary = {}


func set_table_data(data_dict: Dictionary) -> void:
	DB_copy = data_dict.duplicate_deep()


func add_table_buttons() -> void:
	for table: String in table_list:
		var button: Button = button_template.instantiate()
		button.set_text(table)
		table_buttons.add_child(button)
		button.pressed.connect(update_table.bind(button))


func update_table(button):
	active_table_name = button.get_text()
	activate_table(active_table_name)
	print("ACTIVE TABLE NAME: ", active_table_name)


func load_table_template(table_name: String) -> TableDisplay:
	var new_table_display: Control = table_template.instantiate()
	self.add_child(new_table_display)
	new_table_display.set_name(table_name)
	new_table_display.editor_bar.text = table_name #DELETE ME
	open_table_dict[table_name] = new_table_display
	new_table_display.set_table_data(DB_copy[table_name])
	new_table_display.populate_cells()
	return new_table_display


func activate_table(table_name:String) -> void:
	if !open_table_dict.has(table_name):
		load_table_template(table_name)
	set_visible_table(table_name)


func set_visible_table(table_name: String) -> void:
	for open_table: String in open_table_dict:
		open_table_dict[open_table].set_visible(open_table == table_name)


func set_table_list(table_array: Array) -> void:
	table_list = table_array
