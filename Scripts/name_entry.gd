extends Control

@export var initial_menu: Array[ArticleData] = []

const SKIN_FRAMES: SpriteFrames = preload("res://Sprites/Character/skin.tres")
const HAIR_FRAMES: Array = [
	preload("res://Sprites/Character/hair_1.tres"),
	preload("res://Sprites/Character/hair_2.tres"),
	preload("res://Sprites/Character/hair_3.tres"),
]
const SHIRT_FRAMES: Array = [
	preload("res://Sprites/Character/shirt_1.tres"),
	preload("res://Sprites/Character/shirt_2.tres"),
]
const PANTS_FRAMES: Array = [
	preload("res://Sprites/Character/pants_1.tres"),
	preload("res://Sprites/Character/pants_2.tres"),
]
const SKIN_COLORS: Array[Color] = [
	Color(1.0, 0.85, 0.70),
	Color(0.90, 0.70, 0.50),
	Color(0.75, 0.55, 0.35),
	Color(0.55, 0.35, 0.20),
	Color(0.35, 0.22, 0.12),
]
const HAIR_COLORS: Array[Color] = [
	Color(0.15, 0.10, 0.05),
	Color(0.35, 0.20, 0.10),
	Color(0.60, 0.35, 0.15),
	Color(0.85, 0.60, 0.25),
	Color(0.80, 0.30, 0.10),
	Color(0.75, 0.75, 0.75),
	Color(0.90, 0.25, 0.25),
]
const CLOTHES_COLORS: Array[Color] = [
	Color(0.20, 0.40, 0.70),
	Color(0.70, 0.20, 0.20),
	Color(0.20, 0.60, 0.30),
	Color(0.80, 0.75, 0.20),
	Color(0.60, 0.20, 0.70),
	Color(0.85, 0.50, 0.15),
	Color(0.30, 0.30, 0.30),
	Color(0.90, 0.90, 0.90),
]

var skin_color_index: int = 0
var hair_style_index: int = 0
var hair_color_index: int = 0
var shirt_style_index: int = 0
var shirt_color_index: int = 0
var pants_style_index: int = 0
var pants_color_index: int = 0

# update these paths to match your exact node names
@onready var player_edit: LineEdit = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/PlayerHDisplay/PlayerEdit
@onready var shop_edit: LineEdit = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/CoffeeShopHDisplay/ShopEdit
@onready var confirm_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ButtonDisplay/ConfirmButton

# preview layers - adjust path to where you placed Preview node
@onready var preview_skin: AnimatedSprite2D = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/Preview/skin
@onready var preview_hair: AnimatedSprite2D = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/Preview/hair
@onready var preview_shirt: AnimatedSprite2D = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/Preview/clothes_top
@onready var preview_pants: AnimatedSprite2D = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/Preview/clothes_bottom

# buttons - replace the paths with your actual node names
@onready var prev_skin_color_btn: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/SkinColorRow/PrevButton
@onready var next_skin_color_btn: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/SkinColorRow/NextButton
@onready var prev_hair_style_btn: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/HairStyleRow/PrevButton
@onready var next_hair_style_btn: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/HairStyleRow/NextButton
@onready var prev_hair_color_btn: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/HairColorRow/PrevButton
@onready var next_hair_color_btn: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/HairColorRow/NextButton
@onready var prev_shirt_style_btn: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/ShirtStyleRow/PrevButton
@onready var next_shirt_style_btn: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/ShirtStyleRow/NextButton
@onready var prev_shirt_color_btn: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/ShirtColorRow/PrevButton
@onready var next_shirt_color_btn: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/ShirtColorRow/NextButton
@onready var prev_pants_style_btn: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/PantsStyleRow/PrevButton
@onready var next_pants_style_btn: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/PantsStyleRow/NextButton
@onready var prev_pants_color_btn: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/PantsColorRow/PrevButton
@onready var next_pants_color_btn: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/PantsColorRow/NextButton

func _ready() -> void:
	GameData.menu = initial_menu
	
	# connect all buttons
	prev_skin_color_btn.pressed.connect(prev_skin_color)
	next_skin_color_btn.pressed.connect(next_skin_color)
	prev_hair_style_btn.pressed.connect(prev_hair_style)
	next_hair_style_btn.pressed.connect(next_hair_style)
	prev_hair_color_btn.pressed.connect(prev_hair_color)
	next_hair_color_btn.pressed.connect(next_hair_color)
	prev_shirt_style_btn.pressed.connect(prev_shirt_style)
	next_shirt_style_btn.pressed.connect(next_shirt_style)
	prev_shirt_color_btn.pressed.connect(prev_shirt_color)
	next_shirt_color_btn.pressed.connect(next_shirt_color)
	prev_pants_style_btn.pressed.connect(prev_pants_style)
	next_pants_style_btn.pressed.connect(next_pants_style)
	prev_pants_color_btn.pressed.connect(prev_pants_color)
	next_pants_color_btn.pressed.connect(next_pants_color)
	
	update_preview()

func update_preview() -> void:
	preview_skin.sprite_frames = SKIN_FRAMES
	preview_skin.modulate = SKIN_COLORS[skin_color_index]
	preview_skin.play("idle")

	preview_hair.sprite_frames = HAIR_FRAMES[hair_style_index]
	preview_hair.modulate = HAIR_COLORS[hair_color_index]
	preview_hair.play("idle")

	preview_shirt.sprite_frames = SHIRT_FRAMES[shirt_style_index]
	preview_shirt.modulate = CLOTHES_COLORS[shirt_color_index]
	preview_shirt.play("idle")

	preview_pants.sprite_frames = PANTS_FRAMES[pants_style_index]
	preview_pants.modulate = CLOTHES_COLORS[pants_color_index]
	preview_pants.play("idle")

# skin color
func prev_skin_color() -> void:
	skin_color_index = (skin_color_index - 1 + SKIN_COLORS.size()) % SKIN_COLORS.size()
	update_preview()
func next_skin_color() -> void:
	skin_color_index = (skin_color_index + 1) % SKIN_COLORS.size()
	update_preview()

# hair style
func prev_hair_style() -> void:
	hair_style_index = (hair_style_index - 1 + HAIR_FRAMES.size()) % HAIR_FRAMES.size()
	update_preview()
func next_hair_style() -> void:
	hair_style_index = (hair_style_index + 1) % HAIR_FRAMES.size()
	update_preview()

# hair color
func prev_hair_color() -> void:
	hair_color_index = (hair_color_index - 1 + HAIR_COLORS.size()) % HAIR_COLORS.size()
	update_preview()
func next_hair_color() -> void:
	hair_color_index = (hair_color_index + 1) % HAIR_COLORS.size()
	update_preview()

# shirt style
func prev_shirt_style() -> void:
	shirt_style_index = (shirt_style_index - 1 + SHIRT_FRAMES.size()) % SHIRT_FRAMES.size()
	update_preview()
func next_shirt_style() -> void:
	shirt_style_index = (shirt_style_index + 1) % SHIRT_FRAMES.size()
	update_preview()

# shirt color
func prev_shirt_color() -> void:
	shirt_color_index = (shirt_color_index - 1 + CLOTHES_COLORS.size()) % CLOTHES_COLORS.size()
	update_preview()
func next_shirt_color() -> void:
	shirt_color_index = (shirt_color_index + 1) % CLOTHES_COLORS.size()
	update_preview()

# pants style
func prev_pants_style() -> void:
	pants_style_index = (pants_style_index - 1 + PANTS_FRAMES.size()) % PANTS_FRAMES.size()
	update_preview()
func next_pants_style() -> void:
	pants_style_index = (pants_style_index + 1) % PANTS_FRAMES.size()
	update_preview()

# pants color
func prev_pants_color() -> void:
	pants_color_index = (pants_color_index - 1 + CLOTHES_COLORS.size()) % CLOTHES_COLORS.size()
	update_preview()
func next_pants_color() -> void:
	pants_color_index = (pants_color_index + 1) % CLOTHES_COLORS.size()
	update_preview()

func _on_confirm_button_pressed() -> void:
	# save appearance to GameData
	GameData.player_skin_color = SKIN_COLORS[skin_color_index]
	GameData.player_hair_color = HAIR_COLORS[hair_color_index]
	GameData.player_hair_style = hair_style_index
	GameData.player_shirt_style = shirt_style_index
	GameData.player_shirt_color = CLOTHES_COLORS[shirt_color_index]
	GameData.player_pants_style = pants_style_index
	GameData.player_pants_color = CLOTHES_COLORS[pants_color_index]

	randomize()
	var date = Time.get_datetime_dict_from_system()
	var start_month = date["month"] - 1
	var start_day = date["day"]

	for article in initial_menu:
		GameData.menu_ids.append(article.id)

	SaveManager.save_especific_data(GameData.game_slot, "world", {"day_index": randi_range(0, 6), "num_day": start_day, "month": start_month, "year": 1})
	SaveManager.save_especific_data(GameData.game_slot, "player", {
		"name": GameData.player_name,
		"money": 0,
		"popularity": 0,
		"appearance": {
			"skin_color": GameData.player_skin_color,
			"hair_color": GameData.player_hair_color,
			"hair_style": GameData.player_hair_style,
			"shirt_style": GameData.player_shirt_style,
			"shirt_color": GameData.player_shirt_color,
			"pants_style": GameData.player_pants_style,
			"pants_color": GameData.player_pants_color,
		}
	})
	SaveManager.save_especific_data(GameData.game_slot, "coffee_shop", {"name": GameData.shop_name, "menu_ids": GameData.menu_ids})

	GameData.load_to_data(SaveManager.load_game(GameData.game_slot))
	get_tree().change_scene_to_file("res://Scenes/coffee_shop.tscn")

func _on_player_edit_text_changed(new_text: String) -> void:
	GameData.player_name = new_text

func _on_shop_edit_text_changed(new_text: String) -> void:
	GameData.shop_name = new_text
