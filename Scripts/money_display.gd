extends HBoxContainer

var displayed_money: float = 0.0
var money_tween: Tween

@onready var ten_of_thousands_label: Label = $TenOfThousands/TenOfThousandsLabel
@onready var thousand_unit_label: Label = $ThousandUnit/ThousandUnitLabel
@onready var hundred_label: Label = $Hundred/HundredLabel
@onready var ten_label: Label = $Ten/TenLabel
@onready var unit_label: Label = $Unit/UnitLabel
@onready var decimal_1_label: Label = $Decimal1/Decimal1Label
@onready var decimal_2_label: Label = $Decimal2/Decimal2Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameData.money_changed.connect(_on_money_changed)

	displayed_money = GameData.money
	update_money_display(displayed_money)

func _on_money_changed(new_maount: float) -> void:
	animate_money(new_maount)

func update_money_display(money: float) -> void:
	displayed_money = money
	
	var money_string := "%.2f" % money
	
	money_string = money_string.replace(".", "")
	
	money_string = money_string.pad_zeros(7)
	
	ten_of_thousands_label.text = money_string[0]
	thousand_unit_label.text = money_string[1]
	hundred_label.text = money_string[2]
	ten_label.text = money_string[3]
	unit_label.text = money_string[4]
	decimal_1_label.text = money_string[5]
	decimal_2_label.text = money_string[6]

func animate_money(new_amount: float) -> void:
	if money_tween:
		money_tween.kill()
	
	money_tween = create_tween()
	
	money_tween.tween_method(
		update_money_display,
		displayed_money,
		new_amount,
		0.8
	)
