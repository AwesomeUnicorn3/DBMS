class_name DBManager

const TABLE_LIST: String = "TableList"
const ROW: String = "ROW"
const COLUMN: String = "COLUMN"
const DISPLAY_ORDER: String = "display_order"
const DATATYPE: String = "datatype"
const ROW_DEFAULT_DICT: Dictionary = { "DEFAULT_FIRST_COLUMN_NAME" : "Default Name" , "display_order" : 1}
const COLUMN_DEFAULT_DICT: Dictionary = {DISPLAY_ORDER : 1, DATATYPE : 3, "is_unique" : true}
const TBL_DEFAULT_TABLE: Dictionary = {ROW : {"DEFAULT_FIRST_KEY_NAME" :  ROW_DEFAULT_DICT}, COLUMN : {"DEFAULT_FIRST_COLUMN_NAME" : COLUMN_DEFAULT_DICT}}

var main_db: Dictionary = {}
var save_path: String = "res://"
var ext: String = ".json"


func get_table_list() -> Array:
	return main_db.keys()


func update_field(new_value: Variant, table: Dictionary, key_name: String, column_name: String) -> bool:
	var success: bool = true
	var new_value_type: int = typeof(new_value)
	
	#VERIFY THAT THE TABLE, KEY, AND COLUMN PATH EXIST
	if !table[ROW].has(key_name):
		print("ERROR: KEY DOES NOT EXIST IN TABLE")
		return !success
	
	if !table[ROW][key_name].has(column_name):
		print("ERROR: COLUMN DOES NOT EXIST IN TABLE")
		return !success
	
	#VERIFY THAT new_value IS THE CORRECT DATATYPE BEFORE UPDATING
	var datatype:int = table[COLUMN][column_name][DATATYPE]
	if datatype != new_value_type:
		print("ERROR: DATATYPES DO NOT MATCH")
		return !success
	
	#UPDATE VALUE
	table[ROW][key_name][column_name] = new_value
	
	return success


@warning_ignore("unused_parameter")
func add_row(new_row_name: String, new_value_dict: Dictionary, table : Dictionary) -> bool:
	var success: bool = true
	var new_row_dict : Dictionary = ROW_DEFAULT_DICT.duplicate_deep()
	var next_row_number : int = 0

	for key in table[ROW].keys():
		# GET NEXT ROW NUMBER
		var display_order : int = table[ROW][key][DISPLAY_ORDER]
		if next_row_number <= display_order:
			next_row_number = display_order + 1
		
		# CHECK IF NAME IS UNIQUE
		if key == new_row_name:
			print("ERROR: KEY ALREADY EXISTS IN TABLE")
			return !success
	
	for column in table[COLUMN].keys():
		if !new_row_dict.has(column):
			# REPLACE DEFAULT VALUE WITH MATCHING VALUE IN NEW_VALUE_DICT
			new_row_dict[column] = "Default Value"
	
	# SET ORDER NUMBER
	new_row_dict[DISPLAY_ORDER] = next_row_number
	
	# ADD ROW TO EXISTING TABLE
	table[ROW][new_row_name] = new_row_dict
	
	return success


func delete_row(key_name: String, table: Dictionary) -> bool:
	var success: bool = true
	var row_dict: Dictionary = table[ROW]
	
	if !row_dict.has(key_name):
		print("ERROR: KEY DOES NOT EXIST IN TABLE")
		return !success
	
	# IF THERE IS ONLY 1 KEY RETURN ERROR
	if row_dict.size() <= 1:
		print("ERROR: TABLE CAN'T HAVE LESS THAN 1 KEY")
		return !success
	
	# REMOVE KEY DICT FROM TABLE
	var delete_key_display_order: int = row_dict[key_name][DISPLAY_ORDER]
	row_dict.erase(key_name)

	# RESET DISPLAY ORDER FOR REMAINING KEYS
	for key in row_dict.keys():
		var display_order: int = row_dict[key][DISPLAY_ORDER]
		if delete_key_display_order < display_order:
			row_dict[key][DISPLAY_ORDER] = display_order - 1
	
	return success


func add_column(new_column_name : String, new_value, table : Dictionary) -> bool:
	var success: bool = true
	var new_column : Dictionary = COLUMN_DEFAULT_DICT.duplicate_deep()
	var next_column_number : int = 1

	# CHECK IF NEW COLUMN NAME EXISTS, IF YES, EXIT AND DISPLAY ERROR
	# ALSO SET THE DISPLAY ORDER OF THE NEW COLUMN
	for selected_column in table[COLUMN].keys():
		var display_order : int = table[COLUMN][selected_column][DISPLAY_ORDER]
		if next_column_number <= display_order:
			next_column_number = display_order + 1
		
		# CHECK IF NAME IS UNIQUE
		if selected_column == new_column_name:
			print("COLUMN ALREADY EXISTS IN TABLE")
			return !success

	# SET ORDER NUMBER
	new_column[DISPLAY_ORDER] = next_column_number

	# LOOP THROUGH ALL KEYS IN ROW AND ADD A FIELD/VALUE PAIR
	for row in table[ROW].keys():
		table[ROW][row][new_column_name] = new_value
	
	# IN TABLE ADD NEW COLUMN INFORMATION
	table[COLUMN][new_column_name] = new_column
	
	return success


func delete_column(column_name: String, table: Dictionary) -> bool:
	var success: bool = true
	var table_column: Dictionary = table[COLUMN]
	var table_row: Dictionary = table[ROW].duplicate_deep()
	
	if !table_column.has(column_name):
		print("ERROR: COLUMN DOES NOT EXIST IN THIS TABLE")
		return !success
	
	if table_column.size()<= 1:
		print("ERROR: TABLE CAN'T HAVE LESS THAN 1 COLUMN")
		return !success
	
	var delete_column_display_order: int = table_column[column_name][DISPLAY_ORDER]
	if !table_column.erase(column_name):
		return !success
	
	#RESET COLUMN DISPLAY ORDER
	for column in table_column.keys():
		var display_order: int = table_column[column][DISPLAY_ORDER]
		if delete_column_display_order < display_order:
			table_column[column][DISPLAY_ORDER] = display_order - 1
	
	for key in table_row:
		if table_row[key].has(column_name):
			table[ROW][key].erase(column_name)
	
	return success


func add_new_table(new_table_name: String, database: Dictionary) -> bool:
	var success: bool = true
	var new_table: Dictionary = TBL_DEFAULT_TABLE.duplicate_deep()
	
	# CHECK FOR DUPLICATE TABLE NAME
	for table_name in database.keys():
		if table_name == new_table_name:
			print("ERROR: TABLE ALREADY EXISTS")
			return !success
	
	# SET UNIQUE STARTING VALUES
	
	
	# ADD TO TBL_Table_List
	if !add_row(new_table_name,{}, main_db[TABLE_LIST]):
		return !success

	# ADD TO DATABASE DICTIONARY
	database[new_table_name] = new_table
	
	return success


func delete_table(table_name: String, database: Dictionary) -> bool:
	var success: bool = true

	if !database.has(table_name):
		print("ERROR: TABLE DOES NOT EXIST IN THE DATABASE")
		return !success
	
	if !FileAccess.file_exists(save_path + table_name + ext):
		print("ERROR: TABLE FILE DOES NOT EXIST")
		return !success
	
	if !delete_row(table_name, main_db[TABLE_LIST]):
		return !success
	
	delete_file_from_disk(table_name, ext)
	database.erase(table_name)
	
	return success


func load_file(file_name) -> Dictionary:
	var return_dict: Dictionary = {}
	var file: FileAccess = FileAccess.open(save_path + file_name + ext, FileAccess.READ)
	var load_json_string = file.get_as_text()
	var json = JSON.new()
	var parse_result: Error = json.parse(load_json_string)
	
	if parse_result != OK:
		print("ERROR: JSON PARSER: ", json.get_error_line())
	else:
		return_dict = json.data
	
	file.close()
	
	return return_dict



func save_file_to_disk(table_name: String) -> bool:
	var success: bool = true
	var save_file = FileAccess.open(save_path + table_name + ext,FileAccess.WRITE)
	if save_file == null:
		save_file.close()
		print("ERROR: FILE DOES NOT EXIST AT THIS PATH OR CAN'T BE OPENED")
		return !success
	
	var save_json_string = JSON.stringify(main_db[table_name], " ")
	save_file.store_string(save_json_string)
	save_file.close()
	
	return success


func delete_file_from_disk(file_name: String, file_extension: String) -> bool:
	var success: bool = DirAccess.remove_absolute(save_path + file_name + file_extension)
	
	return success


func update_main_db(new_db_dict: Dictionary, save_to_disk: bool = true) -> void:
	#I WANT TO UPDATE THIS WHERE YOU CAN PASS IN ONLY TABLES THAT WERE
	#UPDATED SINCE LAST SAVE. NOT REALLY WORTH THE EFFORT RIGHT NOW
	main_db = new_db_dict.duplicate_deep()
	if save_to_disk:
		save_database()


func save_database() -> bool:
	var success: bool = true
	for tbl in main_db.keys():
		if !save_file_to_disk(tbl):
			print("ERROR: ", tbl, " NOT SAVED. CONTINUING WITH NEXT TABLE")
	
	return success


func load_database() -> bool:
	var success: bool = true
	var table_list: Dictionary = load_file(TABLE_LIST)
	
	if table_list == {}:
		print("ERROR LOADING TABLE LIST") 
		return !success
	
	for table_name in table_list[ROW].keys():
		main_db[table_name]  = load_file(table_name)
		if main_db[table_name] == {}:
			print("ERROR: TABLE 'TABLE NAME' IS EMPTY IN DATABASE. CONTINUING WITH NEXT TABLE")
	
	return success
