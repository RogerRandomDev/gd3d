extends RigidDynamicBody3D


const SPEED = 5.0
const JUMP_linear_velocity = 4.5

var is_on_floor=true
# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

signal item_dropped(body:Node)
signal item_grabbed(body:Node)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor:
		linear_velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor:
		linear_velocity.y = JUMP_linear_velocity
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		linear_velocity.x = move_toward(linear_velocity.x, direction.x * SPEED,delta*20)
		linear_velocity.z = move_toward(linear_velocity.z, direction.z * SPEED,delta*20)
	elif is_on_floor:
		linear_velocity.x = move_toward(linear_velocity.x, 0, SPEED*0.125)
		linear_velocity.z = move_toward(linear_velocity.z, 0, SPEED*0.125)
	
	


func _integrate_forces(state):
	is_on_floor=false
	for s in state.get_contact_count():
		match state.get_contact_local_position(0):
			Vector3(0,-1,0):
				is_on_floor=true
