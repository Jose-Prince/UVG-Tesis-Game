extends Node2D

const  PLAYER = preload("res://Prefabs/player.tscn")

@onready var spawn_points: Node = $SpawnPoints

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = PLAYER.instantiate() as Player
	add_child(player)
	
	var spawn_id = TeleportManager.pending_spawn
	
	for spawn in spawn_points.get_children():
		if spawn_id == "":
			
			break
		if spawn.spawn_id == spawn_id:
			player.global_position = spawn.global_position
	
	TeleportManager.pending_spawn = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
