extends Node

# * Signals

# * Variables
# Folder to save the logs
const _LOGS_FILE_TEMP := "user://logs/%04d.txt"
# Folder to save the logs
const _LOGS_ENTRY_TEMP := "{month}/{day} {hour}:{minute}:{second} \n  {text}"
# Random session id, generated at game start
var _session_id: int
# Indicates if the logger is enabled
var _enabled := false
# File to save the current session
var _session_file: File
# Array to keep as buffer of strings
var _buffer: PoolStringArray
# Size limit for the buffer array before saving it to file
var _buffer_limit: int

# * Functions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	_session_id = randi() % 10000
	_session_file = File.new()
	_buffer = PoolStringArray()
	_buffer_limit = 20
	while _session_file.file_exists(_LOGS_FILE_TEMP % _session_id):
		_session_id = randi() % 10000


# Starts to log the session
func start_logging() -> void:
	if not _enabled:
		_session_file.open(_LOGS_FILE_TEMP % _session_id, File.WRITE)
		_enabled = true
		log_entry("Logging started.")
		update_file()
		print("Logging Started")


# Ends the current logging session
func end_logging() -> void:
	if _enabled:
		log_entry("Logging finished.")
		update_file()
		_enabled = false
		_session_file.close()
		print("Logging Finished")


# Logs an entry to file
func log_entry(text: String) -> void:
	if _enabled:
		var data = OS.get_datetime()
		data["text"] = text
		_buffer.append(_LOGS_ENTRY_TEMP.format(data))
		if _buffer.size() == _buffer_limit:
			var text_to_file = _buffer.join("\n")
			_session_file.store_string(text_to_file)
			_buffer.resize(0)


# Forces to write the buffer to the file
func update_file() -> void:
	if _enabled:
		var text_to_file = _buffer.join("\n") + "\n"
		_session_file.store_string(text_to_file)
		_buffer.resize(0)
