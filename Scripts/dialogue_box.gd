extends CanvasLayer

@onready var portrait: TextureRect = $CharacterPortrait
@onready var name_label: Label = $NameBox/MarginContainer/NameLabel
@onready var dialogue_label: Label = $DialoguePanel/ScrollContainer/MarginContainer/DialogueLabel
@onready var scroll_container: ScrollContainer = $DialoguePanel/ScrollContainer

const LETTERS_PER_SECOND: float = 20.0
const PUNCTUATION_PAUSE: float = 0.3
const SCROLL_SPEED: float = 200.0

var full_text: String = ""
var displayed_chars: int = 0
var is_typing: bool = false
var time_accum: float = 0.0
var pause_timer: float = 0.0
var just_skipped: bool = false

func _ready() -> void:
	scroll_container.focus_mode = Control.FOCUS_NONE
	dialogue_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	scroll_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = false

func show_dialogue(character_name: String, text: String, portrait_texture: Texture2D = null) -> void:
	name_label.text = character_name
	dialogue_label.text = ""
	full_text = text
	displayed_chars = 0
	is_typing = true
	time_accum = 0.0
	pause_timer = 0.0
	scroll_container.scroll_vertical = 0
	if portrait_texture:
		portrait.texture = portrait_texture
		portrait.visible = true
	else:
		portrait.visible = false
	visible = true

func hide_dialogue() -> void:
	visible = false
	is_typing = false

func _process(delta: float) -> void:
	if !visible:
		return

	# scrolling always available when dialogue is open
	if Input.is_action_pressed("down"):
		scroll_container.scroll_vertical += int(SCROLL_SPEED * delta)
	elif Input.is_action_pressed("up"):
		scroll_container.scroll_vertical -= int(SCROLL_SPEED * delta)

	# skip typing on Action press
	if Input.is_action_just_pressed("Action"):
		if just_skipped:
			just_skipped = false
			return
		if is_typing:
			skip_to_end()
		return

	if !is_typing:
		return

	# punctuation pause
	if pause_timer > 0.0:
		pause_timer -= delta
		return

	time_accum += delta
	var chars_to_add = int(time_accum * LETTERS_PER_SECOND)

	if chars_to_add > 0:
		time_accum -= chars_to_add / LETTERS_PER_SECOND

		for i in range(chars_to_add):
			if displayed_chars >= full_text.length():
				is_typing = false
				return

			displayed_chars += 1
			dialogue_label.text = full_text.substr(0, displayed_chars)

			# auto scroll to bottom only if player is not scrolling manually
			if !Input.is_action_pressed("up") and !Input.is_action_pressed("down"):
				await get_tree().process_frame
				scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value

			var last_char = full_text[displayed_chars - 1]
			if last_char in [".", "!", "?", ","]:
				pause_timer = PUNCTUATION_PAUSE
				return

func skip_to_end() -> void:
	displayed_chars = full_text.length()
	dialogue_label.text = full_text
	is_typing = false
	just_skipped = true
	await get_tree().process_frame
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value
