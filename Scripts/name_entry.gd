extends Control

signal names_confirmed(player_name, cafe_name)

@onready var name_edit: LineEdit = $MarginContainer/VBoxContainer/MarginContainer/NameTag/MarginContainer/VBoxContainer/NameEdit
@onready var coffeeshop_edit: LineEdit = $MarginContainer/VBoxContainer/CoffeeshopEdit

@onready var confirm_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/ConfirmButton

func _ready() -> void:
	confirm_button.pressed.connect(_on_confirm_pressed)

func _on_confirm_pressed():
	names_confirmed.emit(
		name_edit.text,
		coffeeshop_edit.text
	)
