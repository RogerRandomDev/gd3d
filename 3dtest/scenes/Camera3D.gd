extends Camera3D


@export var maxRotation:float=1.25664
@export var sensitivity:float=0.001

var in_game=false
func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		in_game=!in_game
		if in_game:
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseMotion&&in_game:
		var rotBase=(Vector2(512,300)-get_viewport().get_mouse_position())*sensitivity
		rotation.y+=rotBase.x
		rotation.x=clamp(rotation.x+rotBase.y,-maxRotation,maxRotation)
		get_viewport().warp_mouse(Vector2(512,300))
