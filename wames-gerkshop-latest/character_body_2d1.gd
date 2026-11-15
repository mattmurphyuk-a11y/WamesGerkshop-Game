extends CharacterBody2D

@export var speed := 600.0
var dir: float
var spawnPos: Vector2
var spawnRot: float
var zdex: int

func _ready() -> void:
	global_position = spawnPos
	global_rotation = spawnRot
	z_index = zdex

func _physics_process(delta: float) -> void:
	velocity = Vector2.RIGHT.rotated(dir) * speed
	move_and_slide()
