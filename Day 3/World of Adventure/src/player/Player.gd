extends KinematicBody2D


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") 
var move : Vector2
var velocity = 200
var attack : bool

func _ready():
	pass


func _physics_process(delta):
	_move(delta)
	_attack()

func _move(delta):
	var left := int(Input.is_action_pressed("ui_left"))
	var right := int(Input.is_action_pressed("ui_right"))
	
	move.x = (right - left) * velocity
	if not is_on_floor():
		move.y += gravity * delta
	else:
		var up := int(Input.is_action_pressed("ui_up"))
		move.y = -(up * (gravity * 2))
	
	if move != Vector2.ZERO:
		$Body.play("walking")
		if move.x < 0:
			$Body.flip_h = true
			$Body/AreaDamageSword.position.x = -45
		elif move.x > 0:
			$Body.flip_h = false
			$Body/AreaDamageSword.position.x = 45
	else:
		$Body.play("idle")

	
	move = move_and_slide(move, Vector2.UP)

func _attack():
	attack = Input.is_action_pressed("ui_select")
	if attack:
		$Body/AreaDamageSword/CollisionShape2D.disabled = false
		$Body.play("attacking")
		if $Body.flip_h:
			$Body.offset.x = -25
		else:
			$Body.offset.x = 25
	else:
		$Body.offset.x = 0
		$Body/AreaDamageSword/CollisionShape2D.disabled = true

func _on_AreaDamageSword_body_entered(body : Enemy):
	if attack:
		body.disable()
