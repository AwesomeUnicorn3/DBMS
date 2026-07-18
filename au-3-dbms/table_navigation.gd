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
var main_db: Dictionary = {}


func set_table_data(data_dict: Dictionary) -> void:
	main_db = data_dict


func save_table_data() -> Dictionary:
	for tbl_nm: String in open_table_dict:
		main_db[tbl_nm] = open_table_dict[tbl_nm].save_data()
	return main_db


func add_table_buttons() -> void:
	for table: String in table_list:
		var button: Button = button_template.instantiate()
		button.set_text(table)
		table_buttons.add_child(button)
		button.pressed.connect(update_table.bind(button))


func update_table(button):
	active_table_name = button.get_text()
	activate_table(active_table_name)


func load_table_template(table_name: String) -> TableDisplay:
	var new_table_display: Control = table_template.instantiate()
	self.add_child(new_table_display)
	new_table_display.load_table_data(table_name, main_db[table_name])
	open_table_dict[table_name] = new_table_display
	
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
