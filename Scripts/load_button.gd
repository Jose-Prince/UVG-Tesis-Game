extends Button

var days = ["Mon.", "Tue.", "Wed.", "Thu.", "Fri.", "Sat.", "Sun."]
var months = [
	"January", "February", "March", "April", "May", "June",
	"July", "August", "September", "October", "November", "December"
]

var slot: int

const SKIN_FRAMES: SpriteFrames = preload(
	"res://Assets/Sprites/character/player_skin.tres"
)

const HAIR_FRAMES: Array[SpriteFrames] = [
	preload("res://Assets/Sprites/character/hair_1.tres"),
	preload("res://Assets/Sprites/character/hair_2.tres"),
	preload("res://Assets/Sprites/character/hair_3.tres"),
]

const SHIRT_FRAMES: Array[SpriteFrames] = [
	preload("res://Assets/Sprites/character/shirt_1.tres"),
	preload("res://Assets/Sprites/character/shirt_2.tres"),
]

const PANTS_FRAMES: Array[SpriteFrames] = [
	preload("res://Assets/Sprites/character/pants_1.tres"),
	preload("res://Assets/Sprites/character/pants_2.tres"),
]

# Player Sprite
@onready var skin: TextureRect = $MarginContainer/HBoxContainer/Panel/skin
@onready var clothes_bottom: TextureRect = $MarginContainer/HBoxContainer/Panel/clothes_bottom
@onready var clothes_top: TextureRect = $MarginContainer/HBoxContainer/Panel/clothes_top
@onready var hair: TextureRect = $MarginContainer/HBoxContainer/Panel/hair

@onready var player_label: Label = $MarginContainer/HBoxContainer/GridContainer/PlayerLabel
@onready var shop_label: Label = $MarginContainer/HBoxContainer/GridContainer/ShopLabel
@onready var money_label: Label = $MarginContainer/HBoxContainer/GridContainer/MoneyLabel
@onready var date_label: Label = $MarginContainer/HBoxContainer/GridContainer/DateLabel

@onready var delete_file_button: Button = $MarginContainer/HBoxContainer/DeleteFileButton

func _ready() -> void:
	pressed.connect(SfxManager.play_click)

func _process(_delta: float) -> void:
	var color := get_theme_color("font_color")
	
	if has_focus():
		color = get_theme_color("font_focus_color")
	elif is_hovered():
		color = get_theme_color("font_hover_color")
	
	_set_labels_color(color)

func apply_appearance(appearance: Dictionary) -> void:
	if appearance.is_empty():
		return

	var hair_style := int(appearance.get("hair_style", 0))
	var shirt_style := int(appearance.get("shirt_style", 0))
	var pants_style := int(appearance.get("pants_style", 0))

	# Skin
	skin.texture = SKIN_FRAMES.get_frame_texture("walk_down", 0)
	skin.modulate = _parse_color(
		appearance.get("skin_color", "(1.0, 1.0, 1.0, 1.0)")
	)

	# Hair
	hair.texture = HAIR_FRAMES[hair_style].get_frame_texture("walk_down", 0)
	hair.modulate = _parse_color(
		appearance.get("hair_color", "(1.0, 1.0, 1.0, 1.0)")
	)

	# Shirt
	clothes_top.texture = SHIRT_FRAMES[shirt_style].get_frame_texture("walk_down", 0)
	clothes_top.modulate = _parse_color(
		appearance.get("shirt_color", "(1.0, 1.0, 1.0, 1.0)")
	)

	# Pants
	clothes_bottom.texture = PANTS_FRAMES[pants_style].get_frame_texture("walk_down", 0)
	clothes_bottom.modulate = _parse_color(
		appearance.get("pants_color", "(1.0, 1.0, 1.0, 1.0)")
	)

func _set_labels_color(color: Color) -> void:
	player_label.add_theme_color_override("font_color", color)
	shop_label.add_theme_color_override("font_color", color)
	money_label.add_theme_color_override("font_color", color)
	date_label.add_theme_color_override("font_color", color)

func setup(
	save_slot: int,
	player_name: String,
	shop_name: String,
	money: int,
	day_index: int,
	num_day: int,
	month: int,
	year: int,
	appearance: Dictionary
) -> void:
	slot = save_slot
	
	var month_name: String = months[month]
	var day: String = days[day_index]
	
	player_label.text = player_name
	shop_label.text = "Coffee Shop: %s" % shop_name
	money_label.text = "Money: $%d" % money
	date_label.text = "%s %d, %s, Year %d" % [
		day,
		num_day,
		month_name,
		year
	]
	
	apply_appearance(appearance)

func _parse_color(value) -> Color:
	if value is Color:
		return value
	
	if value is Dictionary:
		return Color(
			float(value.get("r", 1.0)),
			float(value.get("g", 1.0)),
			float(value.get("b", 1.0)),
			float(value.get("a", 1.0))
		)
	
	if value is String:
		var clean_value = value.strip_edges()
		
		clean_value = clean_value.trim_prefix("(").trim_suffix(")")
		
		var values = clean_value.split(",")
		
		if values.size() != 4:
			return Color.WHITE
		
		return Color(
			float(values[0]),
			float(values[1]),
			float(values[2]),
			float(values[3])
		)
	
	return Color.WHITE

func _on_delete_file_button_pressed() -> void:
	SfxManager.play_click()
	SaveManager.delete_save(slot)
	
	get_tree().reload_current_scene()

func _on_delete_file_button_mouse_entered() -> void:
	delete_file_button.grab_focus()

func _on_mouse_entered() -> void:
	grab_focus()
