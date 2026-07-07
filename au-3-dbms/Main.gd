extends Control

@onready var table_navigation: VBoxContainer = %TableNavigation
@onready var DB: DBManager = DBManager.new()


func _ready() -> void:
	DB.load_database()
	table_navigation.set_table_list(DB.get_table_list())
	table_navigation.add_table_buttons()
	table_navigation.set_table_data(DB.main_db)


func _on_exit_button_pressed() -> void:
	get_tree().quit()
