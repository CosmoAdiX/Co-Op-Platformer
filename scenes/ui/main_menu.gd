extends CanvasLayer

@onready var button_join: Button = %ButtonJoin
@onready var button_quit: Button = %ButtonQuit

func _ready() -> void:
	button_join.pressed.connect(on_join)
	button_quit.pressed.connect(on_quit)
	
func on_join() -> void:
	print("JOINED LIL BRO!")
func on_quit() -> void:
	print("GTFO BRO!!!")
