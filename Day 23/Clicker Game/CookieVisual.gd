extends Control

@export var cookie_color := Color(0.82, 0.55, 0.25)
@export var cookie_dark := Color(0.65, 0.4, 0.15)
@export var cookie_highlight := Color(0.95, 0.75, 0.45)
@export var chip_color := Color(0.25, 0.12, 0.04)
@export var chip_count := 9
@export var seed_val := 12345
@export var enable_idle_animation := true

var _idle_time := 0.0
var _idle_scale := 1.0

func _process(delta: float) -> void:
	if not enable_idle_animation:
		return
	_idle_time += delta
	_idle_scale = 1.0 + sin(_idle_time * 1.5) * 0.015
	queue_redraw()

func _draw() -> void:
	var base_radius: float = minf(size.x, size.y) / 2.0 - 4.0
	var radius: float = base_radius * _idle_scale
	var center: Vector2 = size / 2.0

	# Shadow
	draw_circle(center + Vector2(3, 5), radius, Color(0, 0, 0, 0.3))

	# Cookie body
	draw_circle(center, radius, cookie_color)

	# Inner gradient ring (darker edge)
	draw_arc(center, radius, 0, TAU, 64, cookie_dark, 6.0, true)
	draw_arc(center, radius * 0.85, 0, TAU, 48, cookie_color.lightened(0.05), 2.0, true)

	# Highlight (top-left light reflection)
	var highlight_offset := center + Vector2(-radius * 0.2, -radius * 0.2)
	draw_circle(highlight_offset, radius * 0.35, Color(cookie_highlight, 0.25))

	# Edge bumps (cookie texture)
	var bump_count := 16
	for i in range(bump_count):
		var angle: float = (float(i) / bump_count) * TAU
		var bump_pos: Vector2 = center + Vector2(cos(angle), sin(angle)) * (radius - 3.0)
		draw_circle(bump_pos, 5.0, cookie_dark.lightened(0.05))

	# Chocolate chips
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_val
	for i in range(chip_count):
		var angle: float = rng.randf_range(0, TAU)
		var dist: float = rng.randf_range(radius * 0.1, radius * 0.65)
		var chip_pos: Vector2 = center + Vector2(cos(angle), sin(angle)) * dist
		var chip_radius: float = rng.randf_range(radius * 0.08, radius * 0.15)
		draw_circle(chip_pos, chip_radius + 1.0, Color(0, 0, 0, 0.2))
		draw_circle(chip_pos, chip_radius, chip_color)
		draw_circle(chip_pos + Vector2(-1, -1), chip_radius * 0.4, chip_color.lightened(0.15))
