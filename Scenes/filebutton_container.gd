extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var max_slot = SaveManager.get_save_count()
	
	for slot in range(1, max_slot + 1):
		var button = Button.new()
		
		button.text = "Game %d" % slot
		
		add_child(button)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
