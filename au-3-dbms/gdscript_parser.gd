extends Node

#func _ready():
	#var script_text: String = load_file_string("res://TestTable.gd")
	#script_text = append_to_end_of_file("var new_var: String = 'test'
	#var var2: int = 1", script_text)
	#print(script_text)
	#save_string_to_file(script_text,"res://TestTable2.gd")
	
	#var table_script: GDScript = load("res://TestTable2.gd")
	#tabletable_script.get("new_var"))_script.set("new_var", "TEST2")
	#print(TestTable2.var2)
	
	#var script_string: String = "extends Control

#const ROW : String = 'ROW'
#const COLUMN : String = 'COLUMN'"

#	parse_gdscript_string(script_string)


func parse_gdscript_string(script: String) -> Dictionary:
	var rtn_dict: Dictionary = {}
	
	var word_array: PackedStringArray = script.split(" ")
	for word in word_array:
		print(word)
	
	
	
	return rtn_dict


func load_file_string(file_path : String = "res://") -> String:
	var load_file = FileAccess.open(file_path, FileAccess.READ)
	var text_of_file_contents: String = load_file.get_as_text()
	print(text_of_file_contents)
	#var json = JSON.new()
	#var parse_result = json.parse(load_json_string)
	#if parse_result != OK:
	#	print("Parse Error: ", json.get_error_line())
	#	return
	load_file.close()
	
	return text_of_file_contents
	#main_db = json.data


func append_to_end_of_file(new_string: String, file_contents: String) -> String:
	var return_string :String = ""
	return_string = file_contents + new_string
	return return_string

func save_string_to_file(string_to_save: String = "", file_path: String = "res://") -> void:
	var save_file = FileAccess.open(file_path,FileAccess.WRITE)
	#var save_json_string = JSON.stringify(main_db, " ")
	save_file.store_string(string_to_save)
	save_file.close()
