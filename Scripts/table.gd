extends StaticBody2D

var chairs : Array[Node2D]
var isAvailable : bool = true

func get_free_chair():
	for chair in chairs:
		if chair.isFree:
			return chair
	return null

func update_availability():
	isAvailable = get_free_chair() != null

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("chair"):
		chairs.append(body)
		print("Añadiendo silla")
