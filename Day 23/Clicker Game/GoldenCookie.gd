extends Control

signal clicked(bonus: float)

var _time := 0.0
var _lifetime := 8.0
var _bonus_multiplier := 0.1

func _ready() -> void:
	custom_minimum_size = Vector2(50, 50)
	mouse_filter = Control.MOUSE_FILTER_STOP
	gui_input.connect(_on_gui_input)

	var spawn_tween := create_tween()
	spawn_tween.tween_property(self , "modulate:a", 1.0, 0.3).from(0.0)

func _process(delta: float) -> void:
	_time += delta
	if _time >= _lifetime:
		_fade_out()
		set_process(false)
	queue_redraw()

func _draw() -> void:
	var radius: float = minf(size.x, size.y) / 2.0
	var center: Vector2 = size / 2.0

	var glow_alpha := 0.15 + sin(_time * 6.0) * 0.1
	draw_circle(center, radius * 1.3, Color(1.0, 0.85, 0.0, glow_alpha))

	var golden := Color(1.0, 0.84, 0.0)
	var golden_dark := Color(0.85, 0.65, 0.0)
	var scale_pulse := 1.0 + sin(_time * 4.0) * 0.05

	draw_circle(center, radius * scale_pulse, golden)
	draw_arc(center, radius * scale_pulse, 0, TAU, 32, golden_dark, 3.0, true)

	var star_color := Color(1.0, 1.0, 0.8, 0.9)
	_draw_star(center, radius * 0.5 * scale_pulse, star_color)

func _draw_star(center: Vector2, star_radius: float, color: Color) -> void:
	var points: PackedVector2Array = []
	for i in range(10):
		var angle: float = (float(i) / 10.0) * TAU - PI / 2.0
		var r: float = star_radius if i % 2 == 0 else star_radius * 0.4
		points.append(center + Vector2(cos(angle), sin(angle)) * r)
	draw_colored_polygon(points, color)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit(_bonus_multiplier)
		_pop_and_remove()

func _pop_and_remove() -> void:
	set_process(false)
	var tween := create_tween().set_parallel()
	tween.tween_property(self , "scale", Vector2(1.5, 1.5), 0.2)
	tween.tween_property(self , "modulate:a", 0.0, 0.2)
	tween.chain().tween_callback(queue_free)

func _fade_out() -> void:
	var tween := create_tween()
	tween.tween_property(self , "modulate:a", 0.0, 0.5)
	tween.tween_callback(queue_free)

func setup(bonus_mult: float, lifetime: float = 8.0) -> void:
	_bonus_multiplier = bonus_mult
	_lifetime = lifetime
