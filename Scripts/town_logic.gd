extends Node2D

const  PLAYER = preload("res://Prefabs/Player.tscn")

@onready var spawn_1: Marker2D = $Spawn1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = PLAYER.instantiate() as Player
	add_child(player)
	
	player.global_position = spawn_1.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
