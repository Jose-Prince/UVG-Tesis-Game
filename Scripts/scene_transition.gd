extends Node

var spawn_point_name: String = ""


func change_scene(scene_path: String, spawn_point: String) -> void:
	spawn_point_name = spawn_point
	get_tree().change_scene_to_file(scene_path)
