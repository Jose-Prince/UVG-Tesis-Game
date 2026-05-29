extends Control

var keys = [
	"A","B","C","D","E","F","G","H","I",
	"J","K","L","M","N","O","P","Q","R",
	"S","T","U","V","W","X","Y","Z",
]

var written_name := ""
var is_uppercase := true
var letter_buttons: Array[Button] = []

@onready var name_edit: LineEdit = $MarginContainer/VBoxContainer/NameEdit
@onready var letter_grid: GridContainer = $MarginContainer/VBoxContainer/LetterGrid

@onready var capital_button: Button = $MarginContainer/VBoxContainer/BottomButtons/LetterSizeContainer/CapitalButton
@onready var small_button: Button = $MarginContainer/VBoxContainer/BottomButtons/LetterSizeContainer/SmallButton

@onready var del_button: Button = $MarginContainer/VBoxContainer/BottomButtons/HBoxContainer/DelButton
@onready var confirm_button: Button = $MarginContainer/VBoxContainer/BottomButtons/HBoxContainer/ConfirmButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for key in keys:
		var btn = Button.new()
		
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.size_flags_vertical = Control.SIZE_EXPAND_FILL
		btn.focus_mode = Control.FOCUS_ALL

		btn.text = key
		btn.pressed.connect(_on_letter_pressed.bind(btn))
		
		letter_buttons.append(btn)
		letter_grid.add_child(btn)
		
	capital_button.pressed.connect(_on_capital_pressed)
	small_button.pressed.connect(_on_small_pressed)
	del_button.pressed.connect(_on_del_pressed)
	confirm_button.pressed.connect(_on_confirm_pressed)
	
	setup_focus_navigation()
	setup_bottom_navigation()
	
	letter_buttons[0].grab_focus()
	
	update_name_label()

func _input(event: InputEvent) -> void:
	if event.is_pressed() && not event.is_echo():
		name_edit.grab_focus()

func _on_letter_pressed(btn: Button):
	if written_name.length() >= 10:
		return
		
	written_name+= btn.text
	update_name_label()
	
func _on_capital_pressed():
	is_uppercase = true
	
	for btn in letter_buttons:
		btn.text = btn.text.to_upper()

func _on_small_pressed():
	is_uppercase = false
	
	for btn in letter_buttons:
		btn.text = btn.text.to_lower()

func _on_del_pressed():
	if written_name.length() > 0:
		written_name = written_name.substr(
			0,
			written_name.length() - 1
		)
		
	update_name_label()

func _on_confirm_pressed():
	print("Nombre confirmado:", written_name)
	# TODO guardar nombre jugador / café
	
func update_name_label():
	name_edit.text = written_name + "_"

func setup_focus_navigation():
	var cols = letter_grid.columns
	
	for i in range(letter_buttons.size()):
		var btn = letter_buttons[i]
		
		# left movement
		if i % cols != 0:
			btn.focus_neighbor_left = btn.get_path_to(letter_buttons[i - 1])
			
		# right movement
		if (i + 1) % cols != 0 && i + 1 < letter_buttons.size():
			btn.focus_neighbor_right = btn.get_path_to(letter_buttons[i + 1])
		
		# down movement
		if i + cols < letter_buttons.size():
			btn.focus_neighbor_bottom = btn.get_path_to(letter_buttons[i + cols])
		
		# up movement
		if i - cols >= 0:
			btn.focus_neighbor_top = btn.get_path_to(letter_buttons[i - cols])

func setup_bottom_navigation():
	capital_button.focus_neighbor_right = capital_button.get_path_to(small_button)
	
	small_button.focus_neighbor_left = small_button.get_path_to(capital_button)
	small_button.focus_neighbor_right = small_button.get_path_to(del_button)
	
	del_button.focus_neighbor_left = del_button.get_path_to(small_button)
	del_button.focus_neighbor_right = del_button.get_path_to(confirm_button)
	
	confirm_button.focus_neighbor_left = confirm_button.get_path_to(del_button)
