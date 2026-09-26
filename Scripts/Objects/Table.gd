class_name Table
extends Interactable


@export var customer_spot: Marker2D

var occupied: bool = false


func _ready() -> void:
	super._ready()

	interaction_radius = 80.0


func interact() -> void:
	print("Player interacted with the table!")


func get_customer_spot() -> Vector2:
	return customer_spot.global_position
