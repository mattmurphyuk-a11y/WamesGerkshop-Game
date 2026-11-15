extends Area2D

var speed := 225.0
var player: Node2D
var dead := false

func _ready() -> void:
	$Dead.hide()
	area_entered.connect(_on_hit)
	body_entered.connect(_on_hit)

func _physics_process(delta: float) -> void:
	if dead or player == null:
		return
	var dir = (player.global_position - global_position).normalized()
	global_position += dir * speed * delta

func _on_hit(other: Node) -> void:
	if dead or not other.has_meta("speed"):
		return
	dead = true
	$Alive.hide()
	$Dead.show()
	other.set_meta("speed", other.get_meta("speed") * 0.5)
	set_deferred("monitoring", false)
	player.play_hit_sound()
