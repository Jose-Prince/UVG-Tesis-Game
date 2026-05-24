extends Control

var keys = [
	"A","B","C","D","E","F","G","H","I",
	"J","K","L","M","N","O","P","Q","R",
	"S","T","U","V","W","X","Y","Z",
	"SPACE","DEL","OK"
]

var written_name := ""

@onready var name_label: Label = $NameLabel
@onready var letter_grid: GridContainer = $LetterGrid

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for key in keys:
		var btn = Button.new()
		btn.text = key
		btn.pressed.connect(_on_key_selected.bind(key))
		letter_grid.add_child(btn)

func _on_key_selected(key):
	match key:
		"SPACE":
			written_name += " "
			
		"DEL":
			if written_name.length() > 0:
				written_name = written_name.substr(0, written_name.length()-1)
			
		"OK":
			pass # TODO: insert name of player and coffee shop
			
		_:
			if written_name.length() < 10:
				written_name += key
	
	name_label.text = written_name + "_"
