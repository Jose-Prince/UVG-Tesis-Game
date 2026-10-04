class_name SceneExit
extends Interactable


@export_file("*.tscn") var destination_scene: String
@export var destination_spawn: String = "PlayerSpawn"


func interact() -> void:
	SceneTransition.change_scene(
		destination_scene,
		destination_spawn
	)
