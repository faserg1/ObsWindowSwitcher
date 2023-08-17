extends Node2D

@onready var viewportSprite = $ViewportTexture
@onready var overlaySprite = $OverlayTexture
@onready var viewport = $SubViewport
@onready var viewport2 = $SubViewport2

func _ready():
	var texture1 = viewport.get_texture()
	viewportSprite.texture = texture1
	var texture2 = viewport2.get_texture()
	overlaySprite.texture = texture2
