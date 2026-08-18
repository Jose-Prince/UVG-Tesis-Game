extends Control

@export var frame1: AtlasTexture
@export var frame2: AtlasTexture
@export var frame3: AtlasTexture
@export var frame4: AtlasTexture
@export var frame5: AtlasTexture
@export var frame6: AtlasTexture

@export var frame_duration := 0.2

var open_hour := 0
var close_hour := 0

var is_close := false

@onready var title: Label = $MarginContainer2/MarginContainer/VBoxContainer/Title
@onready var time: Label = $MarginContainer2/MarginContainer/VBoxContainer/Time
@onready var texture_rect: TextureRect = $MarginContainer2/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	open_hour = GameData.open_hour
	close_hour = GameData.closed_hour
	
	texture_rect.texture = frame1
	
	update_time()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_time() -> void:
	time.text = "%s - %s" % [
		format_hour(open_hour),
		format_hour(close_hour)
	]

func format_hour(hour: int) -> String:
	var period := "AM"
	var display_hour := hour
	
	if hour >= 12:
		period = "PM"
		
	if display_hour > 12:
		display_hour -= 12
		
	return "%02d:00 %s" % [display_hour, period]

func play_animation() -> void:
	title.visible = false
	time.visible = false
	
	var frames: Array[AtlasTexture] = [
		frame1,
		frame2,
		frame3,
		frame4,
		frame5,
		frame6
	]
	
	for frame in frames:
		texture_rect.texture = frame
		await get_tree().create_timer(frame_duration).timeout
		
	texture_rect.flip_h = true
	
	# Play animation backwards
	play_animation_backwards()

func play_animation_backwards() -> void:
	var frames: Array[AtlasTexture] = [
		frame6,
		frame5,
		frame4,
		frame3,
		frame2,
		frame1
	]
		
	for frame in frames:
		texture_rect.texture = frame
		await get_tree().create_timer(frame_duration).timeout
	
	texture_rect.flip_h = false
	
	title.visible = true
	time.visible = true

func _on_time_gui_shop_closed() -> void:
	if is_close:
		title.text = "CLOSED"
		play_animation()

func _on_time_gui_shop_opened() -> void:
	title.text = "OPEN"
	is_close = true
	play_animation()
