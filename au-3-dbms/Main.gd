extends Control

@onready var table_navigation: VBoxContainer = %TableNavigation
@onready var DB: DBManager = DBManager.new()
@onready var save_button: Button = %SaveButton
@onready var exit_button: Button = %ExitButton


func _ready() -> void:
	save_button.button_up.connect(_on_save_button_pressed)
	DB.load_database()
	table_navigation.set_table_list(DB.get_table_list())
	table_navigation.add_table_buttons()
	table_navigation.set_table_data(DB.main_db)


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_save_button_pressed() -> bool:
	var success = true
	DB.update_main_db(table_navigation.save_table_data())
	return success
