extends Control

var months = [
	"January", "February", "March", "April",
	"May", "June", "July", "August",
	"September", "October", "November", "Decemmber"
]

var days = [
	"Mon.", "Tue.", "Wed.", "Thu.",
	"Fri.", "Sat.", "Sun."
]

@onready var date_label: Label = $VBoxContainer/HBoxContainer/DateLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	date_label.text = "%s %d, %s, Year %d" % [days[GameData.day_index], GameData.num_day, months[GameData.month], GameData.year] 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
