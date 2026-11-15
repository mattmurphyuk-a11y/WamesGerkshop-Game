extends CharacterBody2D

const SPEED = 300.0
const BULLET = preload("res://bullet.tscn")
const ENEMY = preload("res://enemy.tscn")
const LORD_LOAF = preload("res://lord_loaf.tscn")
const HIT_SOUND = preload("res://PixelArt/spinopel-impact-on-metal-411695.mp3")

@export var fire_rate := 1.0
@export var bullet_speed := 600.0
@export var spawn_rate := 2.0
@export var spawn_distance := 700.0
@export var touch_radius := 30.0
@export var min_spawn_rate := 0.3
@export var spawn_ramp := 0.015

var time_since_shot := 0.0
var time_since_spawn := 0.0
var bullets: Array = []
var enemies: Array = []
var is_dead := false
var game_time := 0.0
var kills := 0

func _ready() -> void:
	spawn_lord_loaf()

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	var direction = Input.get_vector("left", "right", "forward", "backwards")
	if direction.x > 0:
		$AnimatedSprite2D.flip_h = true
	elif direction.x < 0:
		$AnimatedSprite2D.flip_h = false
	velocity = direction * SPEED
	move_and_slide()

	time_since_shot += delta
	if time_since_shot >= fire_rate:
		time_since_shot = 0.0
		fire()

	game_time += delta
	var current_spawn_rate = max(min_spawn_rate, spawn_rate - game_time * spawn_ramp)

	time_since_spawn += delta
	if time_since_spawn >= current_spawn_rate:
		time_since_spawn = 0.0
		spawn_enemy()

	for b in bullets:
		if is_instance_valid(b):
			b.global_position += Vector2.RIGHT.rotated(b.global_rotation) * b.get_meta("speed") * delta

	check_touch()

func fire() -> void:
	var b = BULLET.instantiate()
	b.set_meta("speed", bullet_speed)
	get_tree().current_scene.add_child(b)
	b.z_index = 10
	b.global_position = global_position
	b.global_rotation = (get_global_mouse_position() - global_position).angle()
	bullets.append(b)

func spawn_enemy() -> void:
	var e = ENEMY.instantiate()
	e.player = self
	e.speed = SPEED * 0.75
	get_tree().current_scene.add_child(e)
	e.z_index = 5
	var angle = randf() * TAU
	e.global_position = global_position + Vector2.RIGHT.rotated(angle) * spawn_distance
	enemies.append(e)

func spawn_lord_loaf() -> void:
	var l = LORD_LOAF.instantiate()
	l.player = self
	l.speed = SPEED
	get_tree().current_scene.add_child.call_deferred(l)
	l.z_index = 6
	var angle = randf() * TAU
	l.global_position = global_position + Vector2.RIGHT.rotated(angle) * spawn_distance
	enemies.append(l)

func check_touch() -> void:
	for e in enemies:
		if is_instance_valid(e) and not e.get("dead"):
			if global_position.distance_to(e.global_position) < touch_radius:
				die()
				return

func die() -> void:
	is_dead = true
	kills = 0
	for e in enemies:
		if is_instance_valid(e) and e.get("dead") == true:
			kills += 1
	var seconds = int(game_time)
	var score = seconds * kills
	GameData.add_score(seconds, kills)

	var layer = CanvasLayer.new()
	layer.process_mode = Node.PROCESS_MODE_ALWAYS

	var box = VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 30)
	box.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(box)

	var label = Label.new()
	label.text = "YOU DIED\nScore: %d  (%ds x %d kills)" % [score, seconds, kills]
	label.add_theme_font_size_override("font_size", 48)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(label)

	var button = Button.new()
	button.text = "RETURN TO TITLE"
	button.custom_minimum_size = Vector2(300, 60)
	button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	button.add_theme_font_size_override("font_size", 28)
	button.pressed.connect(_on_return_to_title)
	box.add_child(button)

	get_tree().current_scene.add_child(layer)
	button.grab_focus()
	get_tree().paused = true

func _on_return_to_title() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://title.tscn")

func play_hit_sound() -> void:
	var s = AudioStreamPlayer.new()
	s.stream = HIT_SOUND
	add_child(s)
	s.finished.connect(s.queue_free)
	s.play()
