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

const SWATCH_SIZE := Vector2(24, 24)

var skin_color_index: int = 0
var hair_style_index: int = 0
var hair_color_index: int = 0
var shirt_style_index: int = 0
var shirt_color_index: int = 0
var pants_style_index: int = 0
var pants_color_index: int = 0
var is_rebuilding := false

@onready var player_edit: LineEdit = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/PlayerHDisplay/PlayerEdit
@onready var shop_edit: LineEdit = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/CoffeeShopHDisplay/ShopEdit
@onready var confirm_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ButtonDisplay/ConfirmButton

@onready var preview_skin: AnimatedSprite2D = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/Preview/skin
@onready var preview_hair: AnimatedSprite2D = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/Preview/hair
@onready var preview_shirt: AnimatedSprite2D = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/Preview/clothes_top
@onready var preview_pants: AnimatedSprite2D = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/Preview/clothes_bottom

@onready var prev_hair_style_btn: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HairStyleRow/PrevButton
@onready var next_hair_style_btn: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HairStyleRow/NextButton
@onready var prev_shirt_style_btn: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/ShirtStyleRow/PrevButton
@onready var next_shirt_style_btn: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/ShirtStyleRow/NextButton
@onready var prev_pants_style_btn: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/PantsStyleRow/PrevButton
@onready var next_pants_style_btn: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/PantsStyleRow/NextButton

@onready var skin_color_row: HBoxContainer = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/VBoxSkinColor/SkinColorRow
@onready var hair_color_row: HBoxContainer = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/VBoxHairColor/HairColorRow
@onready var shirt_color_row: HBoxContainer = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/VBoxShirtColor/ShirtColorRow
@onready var pants_color_row: HBoxContainer = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/VBoxPantsColor/PantsColorRow

func _ready() -> void:
	GameData.menu = initial_menu

	prev_hair_style_btn.pressed.connect(prev_hair_style)
	next_hair_style_btn.pressed.connect(next_hair_style)
	prev_shirt_style_btn.pressed.connect(prev_shirt_style)
	next_shirt_style_btn.pressed.connect(next_shirt_style)
	prev_pants_style_btn.pressed.connect(prev_pants_style)
	next_pants_style_btn.pressed.connect(next_pants_style)

	await get_tree().process_frame
	rebuild_all_swatches()
	update_preview()

func build_color_swatches(container: HBoxContainer, colors: Array, current_index: int, callback: Callable) -> void:
	for child in container.get_children():
		child.queue_free()

	for i in colors.size():
		var btn := Button.new()
		btn.custom_minimum_size = SWATCH_SIZE

		var normal_style := StyleBoxFlat.new()
		normal_style.bg_color = colors[i]
		normal_style.corner_radius_top_left = 2
		normal_style.corner_radius_top_right = 2
		normal_style.corner_radius_bottom_left = 2
		normal_style.corner_radius_bottom_right = 2

		if i == current_index:
			normal_style.border_width_left = 2
			normal_style.border_width_right = 2
			normal_style.border_width_top = 2
			normal_style.border_width_bottom = 2
			normal_style.border_color = Color.WHITE

		var hover_style := normal_style.duplicate()
		hover_style.border_width_left = 1
		hover_style.border_width_right = 1
		hover_style.border_width_top = 1
		hover_style.border_width_bottom = 1
		hover_style.border_color = Color(0.8, 0.8, 0.8)

		btn.add_theme_stylebox_override("normal", normal_style)
		btn.add_theme_stylebox_override("hover", hover_style)
		btn.add_theme_stylebox_override("pressed", normal_style)
		btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())

		var index := i
		btn.pressed.connect(func(): callback.call(index))

		container.add_child(btn)

func rebuild_all_swatches() -> void:
	if is_rebuilding:
		return
	is_rebuilding = true

	build_color_swatches(skin_color_row, SKIN_COLORS, skin_color_index, func(i: int):
		skin_color_index = i
		update_preview()
		rebuild_all_swatches()
	)
	build_color_swatches(hair_color_row, HAIR_COLORS, hair_color_index, func(i: int):
		hair_color_index = i
		update_preview()
		rebuild_all_swatches()
	)
	build_color_swatches(shirt_color_row, CLOTHES_COLORS, shirt_color_index, func(i: int):
		shirt_color_index = i
		update_preview()
		rebuild_all_swatches()
	)
	build_color_swatches(pants_color_row, CLOTHES_COLORS, pants_color_index, func(i: int):
		pants_color_index = i
		update_preview()
		rebuild_all_swatches()
	)

	is_rebuilding = false

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

func prev_hair_style() -> void:
	hair_style_index = (hair_style_index - 1 + HAIR_FRAMES.size()) % HAIR_FRAMES.size()
	update_preview()
func next_hair_style() -> void:
	hair_style_index = (hair_style_index + 1) % HAIR_FRAMES.size()
	update_preview()

func prev_shirt_style() -> void:
	shirt_style_index = (shirt_style_index - 1 + SHIRT_FRAMES.size()) % SHIRT_FRAMES.size()
	update_preview()
func next_shirt_style() -> void:
	shirt_style_index = (shirt_style_index + 1) % SHIRT_FRAMES.size()
	update_preview()

func prev_pants_style() -> void:
	pants_style_index = (pants_style_index - 1 + PANTS_FRAMES.size()) % PANTS_FRAMES.size()
	update_preview()
func next_pants_style() -> void:
	pants_style_index = (pants_style_index + 1) % PANTS_FRAMES.size()
	update_preview()

func _on_confirm_button_pressed() -> void:
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
