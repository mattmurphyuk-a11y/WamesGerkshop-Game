extends Control

const GAME_SCENE = "res://Saturday.tscn"

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var bg = ColorRect.new()
	bg.color = Color(0.15, 0.1, 0.08)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var row = HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 40)
	row.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(row)

	var menu = VBoxContainer.new()
	menu.alignment = BoxContainer.ALIGNMENT_CENTER
	menu.add_theme_constant_override("separation", 15)
	row.add_child(menu)

	var title = Label.new()
	title.text = "Your Toast!"
	title.add_theme_font_size_override("font_size", 48)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu.add_child(title)

	var subtitle = Label.new()
	subtitle.text = "made by wames gerkshop\na meme game about toasters and the power of lord loaf"
	subtitle.add_theme_font_size_override("font_size", 16)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subtitle.custom_minimum_size = Vector2(320, 0)
	menu.add_child(subtitle)

	var play = Button.new()
	play.text = "PLAY"
	play.custom_minimum_size = Vector2(200, 50)
	play.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	play.add_theme_font_size_override("font_size", 24)
	play.pressed.connect(_on_play)
	menu.add_child(play)

	var quit = Button.new()
	quit.text = "QUIT"
	quit.custom_minimum_size = Vector2(200, 50)
	quit.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	quit.add_theme_font_size_override("font_size", 24)
	quit.pressed.connect(_on_quit)
	menu.add_child(quit)

	var board = Label.new()
	board.add_theme_font_size_override("font_size", 16)
	board.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	board.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	if GameData.scores.is_empty():
		board.text = "LEADERBOARD\nno scores yet"
	else:
		var t = "LEADERBOARD"
		for i in GameData.scores.size():
			var s = GameData.scores[i]
			t += "\n%d. %d" % [i + 1, s["score"]]
		board.text = t
	row.add_child(board)

	play.grab_focus()

func _on_play() -> void:
	get_tree().change_scene_to_file(GAME_SCENE)

func _on_quit() -> void:
	get_tree().quit()
