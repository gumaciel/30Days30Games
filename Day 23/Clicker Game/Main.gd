extends Control

var cookies: int = 0
var cookies_per_second: int = 0
var upgrade_cost: int = 10
var upgrade_cost_multiplier: float = 1.15

@onready var score_label: Label = $ScoreLabel
@onready var cps_label: Label = $CookiesPerSecondLabel
@onready var click_button: Button = $ClickButton
@onready var upgrade_button: Button = $UpgradeButton
@onready var timer: Timer = $Timer

func _ready() -> void:
	update_ui()
	click_button.pressed.connect(_on_click_button_pressed)
	upgrade_button.pressed.connect(_on_upgrade_button_pressed)
	timer.timeout.connect(_on_timer_timeout)

func update_ui() -> void:
	score_label.text = "Cookies: " + str(cookies)
	cps_label.text = "per second: " + str(cookies_per_second)
	upgrade_button.text = "Buy Auto Clicker (Cost: " + str(upgrade_cost) + ")"

	if cookies >= upgrade_cost:
		upgrade_button.disabled = false
	else:
		upgrade_button.disabled = true

func _on_click_button_pressed() -> void:
	cookies += 1
	update_ui()

func _on_upgrade_button_pressed() -> void:
	if cookies >= upgrade_cost:
		cookies -= upgrade_cost
		cookies_per_second += 1
		upgrade_cost = int(upgrade_cost * upgrade_cost_multiplier)
		update_ui()

func _on_timer_timeout() -> void:
	if cookies_per_second > 0:
		cookies += cookies_per_second
		update_ui()
