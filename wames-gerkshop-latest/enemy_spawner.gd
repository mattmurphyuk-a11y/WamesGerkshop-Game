extends Node2D

const ENEMY = preload("res://enemy.tscn")

@export var spawn_rate := 2.0
@export var spawn_distance := 700.0

var time_since_spawn := 0.0

func _physics_process(delta: float) -> void:
	time_since_spawn += delta
	if time_since_spawn >= spawn_rate:
		time_since_spawn = 0.0
		spawn()

func spawn() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		print("spawner: can't find player")
		return
	var e = ENEMY.instantiate()
	e.player = player
	e.speed = player.SPEED * 0.75
	get_tree().current_scene.add_child(e)
	e.z_index = 5
	var angle = randf() * TAU
	e.global_position = player.global_position + Vector2.RIGHT.rotated(angle) * spawn_distance
	print("spawned enemy at ", e.global_position)
