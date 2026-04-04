extends CanvasLayer

@onready var menu: Control = %Menu
@onready var button_leave: Button = %ButtonLeave
@onready var label_session: Label = %LabelSession
@onready var button_copy_session: Button = %ButtonCopySession
@onready var hit_marker: Label = %HitMarker
@onready var option_button_color: OptionButton = %OptionButtonColor

var COLORS: Array[Color] = [
	Color.MAGENTA,
	Color.GREEN,
	Color.GREEN_YELLOW,
	Color.HOT_PINK,
	Color.CRIMSON,
	Color.DODGER_BLUE,
	Color.BLACK,
	Color.SADDLE_BROWN,
	Color.DIM_GRAY,
	Color.AQUAMARINE
]

# Called when the node enters the scene tree for the first time. Ok
func _ready() -> void:
	menu.hide()
	hit_marker.hide()
	


	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	button_leave.pressed.connect(func(): Network.leave_server())
	button_copy_session.pressed.connect(func(): DisplayServer.clipboard_set(Network.tube_client.session_id))
	DisplayServer.clipboard_set(Network.tube_client.session_id)
	label_session.text = Network.tube_client.session_id
	
	for single_color in COLORS:
		var new_texture1 = GradientTexture2D.new()
		var gradient = Gradient.new()
		new_texture1.gradient = gradient
		gradient.add_point(0, single_color)
		gradient.remove_point(1)		
		option_button_color.add_icon_item(new_texture1, "")
