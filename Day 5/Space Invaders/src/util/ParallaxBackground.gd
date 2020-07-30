extends ParallaxBackground

func _process(delta):
	$ParallaxLayer.motion_offset.y += 100 * delta
