extends CanvasLayer

@onready var button_join: Button = %ButtonJoin
@onready var button_quit: Button = %ButtonQuit

const WORLD_FOREST = preload("uid://p7owgavxnbl0")




func _ready() -> void:
	button_join.pressed.connect(on_join)
	button_quit.pressed.connect(func(): get_tree().quit())
	
func on_join() -> void:
	var new_world = WORLD_FOREST.instantiate()
	get_tree().current_scene.add_child(new_world)
	hide()
