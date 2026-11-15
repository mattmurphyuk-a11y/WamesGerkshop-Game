extends Area2D

@export var hit_radius := 40.0

var speed := 300.0
var player: Node2D
var slow_timer := 0.0
var bullets_hit: Array = []

func _physics_process(delta: float) -> void:
	if player == null:
		return

	for b in player.bullets:
		if is_instance_valid(b) and not bullets_hit.has(b):
			if global_position.distance_to(b.global_position) < hit_radius:
				bullets_hit.append(b)
				slow_timer = 3.0
				print("Lord Loaf hit")
				player.play_hit_sound

	var current_speed = speed
	if slow_timer > 0.0:
		slow_timer -= delta
		current_speed = speed * 2.0 / 3.0

	var dir = (player.global_position - global_position).normalized()
	global_position += dir * current_speed * delta
