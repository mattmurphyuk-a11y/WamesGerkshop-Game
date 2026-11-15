extends Marker2D

@export var bullet_scene: PackedScene
@export var fire_rate := 1.0

func _ready() -> void:
	var timer := Timer.new()
	timer.wait_time = fire_rate
	timer.timeout.connect(fire)
	add_child(timer)
	timer.start()

func fire() -> void:
	print("fired")
	if bullet_scene == null:
		print("no bullet scene assigned")
		return
	var b = bullet_scene.instantiate()
	get_tree().current_scene.add_child(b)
	b.global_position = global_position
	b.global_rotation = global_rotation
