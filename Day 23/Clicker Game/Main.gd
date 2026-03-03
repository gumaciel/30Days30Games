extends Control

@onready var game_data: Node = $GameData
@onready var upgrade_manager: Node = $UpgradeManager

@onready var score_label: Label = $HBox/LeftPanel/ScoreArea/ScoreLabel
@onready var cps_label: Label = $HBox/LeftPanel/ScoreArea/CPSLabel
@onready var click_power_label: Label = $HBox/LeftPanel/ScoreArea/ClickPowerLabel
@onready var click_button: Button = $HBox/LeftPanel/CookieArea/ClickButton
@onready var upgrades_list: VBoxContainer = $HBox/RightPanel/Margin/VBox/Scroll/UpgradesList
@onready var win_screen: ColorRect = $WinScreen
@onready var time_label: Label = $WinScreen/CenterVBox/TimeLabel
@onready var stats_label: Label = $WinScreen/CenterVBox/StatsLabel
@onready var restart_button: Button = $WinScreen/CenterVBox/RestartButton
@onready var milestone_label: Label = $MilestoneLabel
@onready var golden_cookie_layer: Control = $GoldenCookieLayer

var upgrade_buttons: Array[Button] = []
var main_cookie: Control
var click_tween: Tween
var milestone_tween: Tween
var _golden_timer := 0.0

func _ready() -> void:
	_setup_cookie_visual()
	_connect_signals()
	_setup_upgrades_ui()
	_update_labels()
	_update_upgrade_buttons()
	milestone_label.modulate.a = 0.0
	_golden_timer = randf_range(15.0, 45.0)

func _setup_cookie_visual() -> void:
	var cookie_script := load("res://CookieVisual.gd")
	main_cookie = Control.new()
	main_cookie.set_script(cookie_script)
	main_cookie.name = "CookieVisual"
	main_cookie.mouse_filter = Control.MOUSE_FILTER_IGNORE
	click_button.add_child(main_cookie)
	main_cookie.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main_cookie.set_deferred("custom_minimum_size", click_button.size)
	click_button.text = ""

func _connect_signals() -> void:
	click_button.pressed.connect(_on_click_button_pressed)
	restart_button.pressed.connect(_on_restart_button_pressed)

	game_data.cookies_changed.connect(_on_cookies_changed)
	game_data.cps_changed.connect(_on_cps_changed)
	game_data.click_power_changed.connect(_on_click_power_changed)
	game_data.game_won.connect(_on_game_won)
	game_data.milestone_reached.connect(_on_milestone_reached)

	upgrade_manager.upgrade_purchased.connect(_on_upgrade_purchased)

func _setup_upgrades_ui() -> void:
	var upgrades: Array[Upgrade] = upgrade_manager.get_upgrades()
	for i in range(upgrades.size()):
		var btn := _create_upgrade_button()
		btn.pressed.connect(_on_upgrade_pressed.bind(i))
		upgrades_list.add_child(btn)
		upgrade_buttons.append(btn)

	# Win button
	var win_btn := _create_upgrade_button()
	win_btn.add_theme_color_override("font_color", Color(1, 0.84, 0, 1))
	win_btn.add_theme_color_override("font_hover_color", Color(1, 0.9, 0.3, 1))
	win_btn.pressed.connect(_on_win_pressed)
	upgrades_list.add_child(win_btn)
	upgrade_buttons.append(win_btn)

func _create_upgrade_button() -> Button:
	var btn := Button.new()
	btn.custom_minimum_size = Vector2(0, 70)
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT

	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.12, 0.12, 0.18, 0.8)
	style.border_color = Color(0.25, 0.25, 0.35, 0.6)
	style.set_border_width_all(1)
	style.set_corner_radius_all(8)
	style.set_content_margin_all(12)
	btn.add_theme_stylebox_override("normal", style)

	var hover_style := style.duplicate()
	hover_style.bg_color = Color(0.18, 0.18, 0.28, 0.9)
	hover_style.border_color = Color(0.4, 0.4, 0.6, 0.8)
	btn.add_theme_stylebox_override("hover", hover_style)

	var pressed_style := style.duplicate()
	pressed_style.bg_color = Color(0.1, 0.1, 0.15, 0.9)
	btn.add_theme_stylebox_override("pressed", pressed_style)

	var disabled_style := style.duplicate()
	disabled_style.bg_color = Color(0.08, 0.08, 0.1, 0.5)
	disabled_style.border_color = Color(0.15, 0.15, 0.2, 0.3)
	btn.add_theme_stylebox_override("disabled", disabled_style)

	btn.add_theme_font_size_override("font_size", 16)

	return btn

func _process(delta: float) -> void:
	if game_data.is_game_won:
		return

	_golden_timer -= delta
	if _golden_timer <= 0.0:
		_spawn_golden_cookie()
		_golden_timer = randf_range(25.0, 60.0)

func _update_labels() -> void:
	score_label.text = game_data.format_number(game_data.cookies) + " cookies"
	cps_label.text = "per second: " + game_data.format_number(game_data.cookies_per_second)
	click_power_label.text = "click power: " + str(game_data.click_power)

func _update_upgrade_buttons() -> void:
	var upgrades: Array[Upgrade] = upgrade_manager.get_upgrades()
	for i in range(upgrades.size()):
		var upg: Upgrade = upgrades[i]
		var btn: Button = upgrade_buttons[i]
		btn.text = upg.get_display_text()
		btn.disabled = game_data.cookies < upg.get_current_cost()

		if not btn.disabled:
			btn.modulate = Color(1.0, 1.0, 1.0, 1.0)
		else:
			btn.modulate = Color(0.6, 0.6, 0.6, 0.7)

	var win_idx := upgrades.size()
	var win_btn: Button = upgrade_buttons[win_idx]
	win_btn.text = "🏆 WIN THE GAME\n" + game_data.format_number(game_data.win_cost) + " cookies"
	win_btn.disabled = game_data.cookies < game_data.win_cost
	if not win_btn.disabled:
		win_btn.modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		win_btn.modulate = Color(0.6, 0.6, 0.6, 0.7)

func _on_click_button_pressed() -> void:
	game_data.click()
	_animate_click()

func _animate_click() -> void:
	if click_tween and click_tween.is_valid():
		click_tween.kill()

	click_tween = create_tween()
	click_tween.set_trans(Tween.TRANS_BACK)
	click_tween.set_ease(Tween.EASE_OUT)
	click_button.pivot_offset = click_button.size / 2
	click_button.scale = Vector2(0.88, 0.88)
	click_tween.tween_property(click_button, "scale", Vector2(1.0, 1.0), 0.25)

	_spawn_click_particles()

func _spawn_click_particles() -> void:
	var particle_count := randi_range(2, 4)
	for n in range(particle_count):
		var container := Node2D.new()
		container.global_position = click_button.global_position + (click_button.size / 2) + Vector2(randf_range(-50, 50), randf_range(-50, 50))
		add_child(container)

		var cookie_script := load("res://CookieVisual.gd")
		var mini_cookie := Control.new()
		mini_cookie.set_script(cookie_script)
		mini_cookie.set("enable_idle_animation", false)
		mini_cookie.set("seed_val", randi())
		mini_cookie.set("chip_count", 3)
		mini_cookie.custom_minimum_size = Vector2(30, 30)
		mini_cookie.position = Vector2(-15, -15)
		container.add_child(mini_cookie)

		var ft_tween := create_tween().set_parallel()
		var target_x := container.position.x + randf_range(-120, 120)
		var target_y := container.position.y - randf_range(100, 200)

		ft_tween.tween_property(container, "position", Vector2(target_x, target_y), 0.7).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		ft_tween.tween_property(container, "modulate:a", 0.0, 0.7)
		ft_tween.tween_property(mini_cookie, "rotation", randf_range(-PI, PI), 0.7)
		ft_tween.chain().tween_callback(container.queue_free)

	# Floating text
	var text_container := Node2D.new()
	text_container.global_position = click_button.global_position + (click_button.size / 2) + Vector2(randf_range(-30, 30), -20)
	add_child(text_container)

	var floating_text := Label.new()
	floating_text.text = "+" + str(game_data.click_power)
	floating_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	floating_text.add_theme_font_size_override("font_size", 32)
	floating_text.add_theme_color_override("font_color", Color(1.0, 0.95, 0.8))
	floating_text.add_theme_color_override("font_outline_color", Color(0.4, 0.2, 0.05))
	floating_text.add_theme_constant_override("outline_size", 6)
	floating_text.position = Vector2(-20, -30)
	text_container.add_child(floating_text)

	var text_tween := create_tween().set_parallel()
	text_tween.tween_property(text_container, "position:y", text_container.position.y - 80, 0.6).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	text_tween.tween_property(text_container, "modulate:a", 0.0, 0.6).set_delay(0.2)
	text_tween.chain().tween_callback(text_container.queue_free)

func _spawn_golden_cookie() -> void:
	var golden_script := load("res://GoldenCookie.gd")
	var golden := Control.new()
	golden.set_script(golden_script)
	golden.custom_minimum_size = Vector2(60, 60)

	var area_size := golden_cookie_layer.size
	golden.position = Vector2(
		randf_range(50, area_size.x - 110),
		randf_range(50, area_size.y - 110)
	)
	golden.pivot_offset = Vector2(30, 30)
	golden.call("setup", 0.1, 10.0)
	golden.connect("clicked", _on_golden_cookie_clicked)
	golden_cookie_layer.add_child(golden)

func _on_golden_cookie_clicked(bonus_mult: float) -> void:
	var bonus := maxf(game_data.cookies * bonus_mult, 100.0)
	game_data.cookies += bonus
	game_data.total_cookies_earned += bonus
	_show_milestone("Golden Cookie! +" + game_data.format_number(bonus), Color(1.0, 0.84, 0.0))

func _show_milestone(text: String, color: Color = Color(1, 0.84, 0)) -> void:
	if milestone_tween and milestone_tween.is_valid():
		milestone_tween.kill()

	milestone_label.text = text
	milestone_label.add_theme_color_override("font_color", color)
	milestone_label.modulate.a = 0.0

	milestone_tween = create_tween()
	milestone_tween.tween_property(milestone_label, "modulate:a", 1.0, 0.3)
	milestone_tween.tween_interval(2.0)
	milestone_tween.tween_property(milestone_label, "modulate:a", 0.0, 0.5)

func _on_upgrade_pressed(index: int) -> void:
	if not game_data.is_game_won:
		if upgrade_manager.attempt_purchase(index, game_data):
			_animate_upgrade_purchase(upgrade_buttons[index])

func _animate_upgrade_purchase(btn: Button) -> void:
	var tween := create_tween()
	tween.tween_property(btn, "modulate", Color(0.5, 1.0, 0.5, 1.0), 0.1)
	tween.tween_property(btn, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2)

func _on_win_pressed() -> void:
	game_data.attempt_win()

func _on_restart_button_pressed() -> void:
	game_data.reset()
	upgrade_manager.reset_all()
	win_screen.visible = false
	_golden_timer = randf_range(15.0, 45.0)
	_update_labels()
	_update_upgrade_buttons()

func _on_cookies_changed(_new_amount: float) -> void:
	_update_labels()
	_update_upgrade_buttons()

func _on_cps_changed(_new_cps: float) -> void:
	_update_labels()
	_update_upgrade_buttons()

func _on_click_power_changed(_new_power: float) -> void:
	_update_labels()

func _on_game_won(time_taken: float) -> void:
	win_screen.visible = true
	var minutes := int(time_taken / 60.0)
	var seconds := int(time_taken) - minutes * 60
	time_label.text = "Time: " + str(minutes) + "m " + str(seconds) + "s"
	stats_label.text = "Total clicks: " + str(game_data.total_clicks) + "\nTotal cookies: " + game_data.format_number(game_data.total_cookies_earned)

func _on_milestone_reached(milestone_name: String, _milestone_value: float) -> void:
	_show_milestone("🎉 " + milestone_name + "!", Color(0.4, 1.0, 0.6))

func _on_upgrade_purchased(_index: int, _new_cps: float) -> void:
	_update_upgrade_buttons()
