extends Camera3D


@export var maxRotation:float=1.41372
@export var sensitivity:float=0.001
@export var rotateObject:NodePath
var in_game=false
var held_damp=0
var pickup_ray=PhysicsRayQueryParameters3D.new()
var holding=null
func _ready():
	if rotateObject==null:
		rotateObject=self.get_path()
	pickup_ray.collision_mask=1


func _physics_process(delta):
	if holding!=null:
		holding.constant_force=(get_hold_point()-holding.position).normalized()*5

func _input(event):
	#pickup item script
	if Input.is_action_just_pressed("interact"):
		grab_item()
		explode()
	#exits to menu
	if Input.is_key_pressed(KEY_ESCAPE):
		in_game=!in_game
		if in_game:
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseMotion&&in_game:
		
		var rotBase=(Vector2(512,300)-get_viewport().get_mouse_position())*sensitivity
		#rotates parent around x, but looking up and down is relative to camera
		get_node(rotateObject).rotation.y+=rotBase.x
		rotation.x=clamp(rotation.x+rotBase.y,-maxRotation,maxRotation)
		get_viewport().warp_mouse(Vector2(512,300))


func grab_item():
	if holding!=null:
		holding.linear_damp=held_damp
		holding.constant_force=Vector3.ZERO
		holding.linear_velocity=get_node(rotateObject).velocity
		holding=null
		return
	#grabs item if not just dropping the current one
	pickup_ray.from=global_transform.origin
	var rot=get_node(rotateObject).rotation+rotation
	pickup_ray.to=get_hold_point()
	var grabbed:=get_world_3d().direct_space_state.intersect_ray(pickup_ray)
	if grabbed&&grabbed.collider.is_in_group("grabable"):
		holding=grabbed.collider
		held_damp=holding.linear_damp
		holding.linear_damp=10
		

#where an item is held relative to you
func get_hold_point():
	return global_transform.origin-Vector3(sin(get_node(rotateObject).rotation.y),-sin(rotation.x),cos(get_node(rotateObject).rotation.y))*1.5


#makes an explosion
func explode():
	var exploder=ExplosionObject.new()
	exploder.position=get_hold_point()
	exploder.explosionPower=2
	exploder.explosionRadius=3
	
	get_node(rotateObject).get_parent().call_deferred('add_child',exploder)
