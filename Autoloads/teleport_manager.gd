extends Node

var pending_spawn := ""

var teleport_data := {
	"res://Scenes/town.tscn": {
		"cafe_entrance": {
			"scene": "res://Scenes/coffee_shop.tscn",
			"spawn": "cafe_exit"
		},
		"house_exit": {
			"scene": "",
			"spawn": ""
		}
	},
	
	"res://Scenes/coffee_shop.tscn": {
		"cafe_exit": {
			"scene": "res://Scenes/town.tscn",
			"spawn": "cafe_entrance"
		}
	},
	
	"house": {
		"town_exit": {
			"scene": "",
			"spawn": ""
		}
	}
}

func teleport(teleport_id: String) -> void:
	var current_scene := get_tree().current_scene.scene_file_path
	
	if not teleport_data.has(current_scene):
		push_error("Ho teelports for: " + current_scene)
		return
	
	if not teleport_data[current_scene].has(teleport_id):
		push_error("No teelport '%s' exists in scene '%s'" % [teleport_id, current_scene])
		return
	
	var destination = teleport_data[current_scene][teleport_id]
	
	pending_spawn = destination.spawn
	
	get_tree().change_scene_to_file(destination.scene)
