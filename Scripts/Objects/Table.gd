extends Interactable


func _ready() -> void:
	super._ready()

	interaction_radius = 80.0


func interact() -> void:
	print("Player interacted with the table!")
