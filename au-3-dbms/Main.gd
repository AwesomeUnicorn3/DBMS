extends Control

@onready var table_navigation: VBoxContainer = %TableNavigation
#@onready var DB: DBManager = DBManager.new()
@onready var save_button: Button = %SaveButton
@onready var exit_button: Button = %ExitButton
var main_db_dict: Dictionary = {}

func _ready() -> void:
	save_button.button_up.connect(_on_save_button_pressed)
	main_db_dict = DBManager.load_database("res://", ".json")
	table_navigation.set_table_list(DBManager.get_table_list(main_db_dict))
	table_navigation.add_table_buttons()
	table_navigation.set_table_data(main_db_dict)


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_save_button_pressed() -> bool:
	var success = true
	DBManager.save_database("res://", ".json", main_db_dict)
	return success
