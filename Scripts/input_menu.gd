extends Control

@onready var UpLabel: Label = $InputContainer/UpContainer/UpLabel
@onready var UpCurrentLabel: Label = $InputContainer/UpContainer/UpCurrentLabel

@onready var DownLabel: Label = $InputContainer/DownContainer/DownLabel
@onready var DownCurrentLabel: Label = $InputContainer/DownContainer/DownCurrentLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UpLabel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	UpCurrentLabel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	UpCurrentLabel.text = InputMap.action_get_events("up")[0].as_text()
	
	DownLabel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	DownCurrentLabel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	DownCurrentLabel.text = InputMap.action_get_events("down")[0].as_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
