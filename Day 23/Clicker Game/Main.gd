extends Control

@onready var game_data: Node = $GameData
@onready var upgrade_manager: Node = $UpgradeManager

@onready var score_label: Label = $HBox/LeftPanel/ScoreLabel
@onready var cps_label: Label = $HBox/LeftPanel/CPSLabel
@onready var click_button: Button = $HBox/LeftPanel/ClickButton
@onready var upgrades_list: VBoxContainer = $HBox/RightPanel/Margin/VBox/Scroll/UpgradesList
@onready var win_screen: ColorRect = $WinScreen
@onready var time_label: Label = $WinScreen/VBox/TimeLabel
@onready var restart_button: Button = $WinScreen/VBox/RestartButton

var upgrade_buttons: Array[Button] = []

func _ready() -> void:
	_connect_signals()
	_setup_upgrades_ui()
	_update_labels()
	_update_upgrade_buttons()

func _connect_signals() -> void:
	click_button.pressed.connect(_on_click_button_pressed)
	restart_button.pressed.connect(_on_restart_button_pressed)

	game_data.cookies_changed.connect(_on_cookies_changed)
	game_data.cps_changed.connect(_on_cps_changed)
	game_data.game_won.connect(_on_game_won)

	upgrade_manager.upgrade_purchased.connect(_on_upgrade_purchased)

func _setup_upgrades_ui() -> void:
	var upgrades: Array[Upgrade] = upgrade_manager.get_upgrades()
	for i in range(upgrades.size()):
		var btn: Button = Button.new()
		btn.custom_minimum_size = Vector2(0, 60)
		btn.pressed.connect(_on_upgrade_pressed.bind(i))
		upgrades_list.add_child(btn)
		upgrade_buttons.append(btn)

	var win_btn: Button = Button.new()
	win_btn.custom_minimum_size = Vector2(0, 80)
	win_btn.add_theme_color_override("font_color", Color(1, 0.8, 0, 1))
	win_btn.pressed.connect(_on_win_pressed)
	upgrades_list.add_child(win_btn)
	upgrade_buttons.append(win_btn)

func _process(_delta: float) -> void:
	pass

func _update_labels() -> void:
	score_label.text = "Cookies: " + str(floor(game_data.cookies))
	cps_label.text = "per second: " + str(snapped(game_data.cookies_per_second, 0.1))

func _update_upgrade_buttons() -> void:
	var upgrades: Array[Upgrade] = upgrade_manager.get_upgrades()
	for i in range(upgrades.size()):
		var upg: Upgrade = upgrades[i]
		var btn: Button = upgrade_buttons[i]
		btn.text = upg.get_display_text()
		btn.disabled = game_data.cookies < upg.get_current_cost()

	var win_btn: Button = upgrade_buttons[upgrades.size()]
	win_btn.text = "WIN GAME\nCost: 1,000,000"
	win_btn.disabled = game_data.cookies < game_data.win_cost

func _on_click_button_pressed() -> void:
	game_data.click()

func _on_upgrade_pressed(index: int) -> void:
	if not game_data.is_game_won:
		upgrade_manager.attempt_purchase(index, game_data)

func _on_win_pressed() -> void:
	game_data.attempt_win()

func _on_restart_button_pressed() -> void:
	game_data.reset()
	upgrade_manager.reset_all()
	win_screen.visible = false
	_update_labels()
	_update_upgrade_buttons()

func _on_cookies_changed(_new_amount: float) -> void:
	_update_labels()
	_update_upgrade_buttons()

func _on_cps_changed(_new_cps: float) -> void:
	_update_labels()
	_update_upgrade_buttons()

func _on_game_won(time_taken: float) -> void:
	win_screen.visible = true
	time_label.text = "Time taken: " + str(snapped(time_taken, 0.1)) + " seconds"

func _on_upgrade_purchased(_index: int, _new_cps: float) -> void:
	_update_upgrade_buttons()
