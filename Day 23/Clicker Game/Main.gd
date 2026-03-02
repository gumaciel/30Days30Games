extends Control

var cookies: float = 0.0
var cookies_per_second: float = 0.0
var time_played: float = 0.0
var game_won: bool = false
var win_cost: float = 1_000_000.0

var upgrades = [
	{"name": "Cursor", "base_cost": 15, "cost": 15, "cps": 0.1, "count": 0, "multiplier": 1.15},
	{"name": "Grandma", "base_cost": 100, "cost": 100, "cps": 1.0, "count": 0, "multiplier": 1.15},
	{"name": "Farm", "base_cost": 1100, "cost": 1100, "cps": 8.0, "count": 0, "multiplier": 1.15},
	{"name": "Mine", "base_cost": 12000, "cost": 12000, "cps": 47.0, "count": 0, "multiplier": 1.15},
	{"name": "Factory", "base_cost": 130000, "cost": 130000, "cps": 260.0, "count": 0, "multiplier": 1.15}
]

@onready var score_label: Label = $HBox/LeftPanel/ScoreLabel
@onready var cps_label: Label = $HBox/LeftPanel/CPSLabel
@onready var click_button: Button = $HBox/LeftPanel/ClickButton
@onready var upgrades_list: VBoxContainer = $HBox/RightPanel/Margin/VBox/Scroll/UpgradesList
@onready var win_screen: ColorRect = $WinScreen
@onready var time_label: Label = $WinScreen/VBox/TimeLabel
@onready var restart_button: Button = $WinScreen/VBox/RestartButton

var upgrade_buttons = []

func _ready() -> void:
	click_button.pressed.connect(_on_click_button_pressed)
	restart_button.pressed.connect(_on_restart_button_pressed)
	_setup_upgrades()
	update_ui()

func _setup_upgrades() -> void:
	for i in range(upgrades.size()):
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(0, 60)
		btn.pressed.connect(func(): _on_upgrade_pressed(i))
		upgrades_list.add_child(btn)
		upgrade_buttons.append(btn)

	var win_btn = Button.new()
	win_btn.custom_minimum_size = Vector2(0, 80)
	win_btn.theme_override_colors_font_color = Color(1, 0.8, 0, 1)
	win_btn.pressed.connect(_on_win_pressed)
	upgrades_list.add_child(win_btn)
	upgrade_buttons.append(win_btn)

func _process(delta: float) -> void:
	if game_won:
		return

	time_played += delta
	if cookies_per_second > 0:
		cookies += cookies_per_second * delta
		update_ui()

	_update_upgrade_buttons()

func update_ui() -> void:
	score_label.text = "Cookies: " + str(floor(cookies))
	cps_label.text = "per second: " + str(snapped(cookies_per_second, 0.1))

func _update_upgrade_buttons() -> void:
	for i in range(upgrades.size()):
		var upg = upgrades[i]
		var btn = upgrade_buttons[i]
		btn.text = upg["name"] + " (" + str(upg["count"]) + ")\nCost: " + str(floor(upg["cost"])) + " | CPS: +" + str(upg["cps"])
		btn.disabled = cookies < upg["cost"]

	var win_btn = upgrade_buttons[upgrades.size()]
	win_btn.text = "WIN GAME\nCost: 1,000,000"
	win_btn.disabled = cookies < win_cost

func _on_click_button_pressed() -> void:
	if game_won: return
	cookies += 1.0
	update_ui()
	_update_upgrade_buttons()

func _on_upgrade_pressed(index: int) -> void:
	if game_won: return
	var upg = upgrades[index]
	if cookies >= upg["cost"]:
		cookies -= upg["cost"]
		cookies_per_second += upg["cps"]
		upg["count"] += 1
		upg["cost"] = upg["base_cost"] * pow(upg["multiplier"], upg["count"])
		update_ui()
		_update_upgrade_buttons()

func _on_win_pressed() -> void:
	if cookies >= win_cost and not game_won:
		cookies -= win_cost
		game_won = true
		win_screen.visible = true
		time_label.text = "Time taken: " + str(snapped(time_played, 0.1)) + " seconds"

func _on_restart_button_pressed() -> void:
	cookies = 0.0
	cookies_per_second = 0.0
	time_played = 0.0
	game_won = false
	win_screen.visible = false

	for upg in upgrades:
		upg["count"] = 0
		upg["cost"] = upg["base_cost"]

	update_ui()
	_update_upgrade_buttons()
