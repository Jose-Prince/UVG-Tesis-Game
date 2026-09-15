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

var dots := 0
var full_text := "%s %d, %s, Year %d" % [days[GameData.day_index], GameData.num_day, months[GameData.month], GameData.year] 

@onready var texture_rect: AnimatedTextureRect = $VBoxContainer/HBoxContainer2/TextureRect
@onready var save_label: Label = $VBoxContainer/HBoxContainer2/SaveLabel
@onready var date_label: Label = $VBoxContainer/HBoxContainer/DateLabel
@onready var write_sound: AudioStreamPlayer = $WriteSound
@onready var clic_sound: AudioStreamPlayer = $ClicSound
@onready var scene_transition: CanvasLayer = $SceneTransition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SaveManager.day_start.emit()
	
	texture_rect.play_animation(true)
	
	await scene_transition.pixelate_out(0.6).finished
	await write_text()
	
	clic_sound.play()
	
	await clic_sound.finished
	
	save_label.set_base_text("File saved")
	
	await get_tree().create_timer(0.5).timeout
	await scene_transition.pixelate_in(0.6).finished
	
	get_tree().change_scene_to_file("res://Scenes/coffee_shop.tscn")

func write_text():
	write_sound.pitch_scale = randf_range(2.0, 3.0)

	for i in full_text:
		date_label.text += i
		if i != " ":
			write_sound.play()
			await write_sound.finished
