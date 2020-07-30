extends Node2D


var life = 5 setget _set_life
export (Texture) var life_texture

func _ready():
	update()

func _set_life(value):
	life = value  
	update() 

func _draw():
	for i in range(0, life):
		draw_texture(life_texture, Vector2(i * life_texture.get_width(), 0))
