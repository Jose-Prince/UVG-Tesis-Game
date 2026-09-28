extends TextureButton

@onready var shop_items: Control = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_pressed() -> void:
	shop_items.hide()
	
	DialogueManager.show_dialogue_balloon(load("res://Dialogues/seller_dialogue.dialogue"), "goodbye")
	
