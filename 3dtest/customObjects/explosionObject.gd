extends Node3D
class_name ExplosionObject

@export var explosionRadius:float=2.
@export var explosionPower:float=1.


func _ready():
	call_deferred('explode')


func explode():
	var explosionCheck=PhysicsShapeQueryParameters3D.new()
	explosionCheck.shape=SphereShape3D.new()
	explosionCheck.shape.radius=explosionRadius
	explosionCheck.collision_mask=1
	explosionCheck.transform=global_transform
	var check:=get_world_3d().direct_space_state.intersect_shape(explosionCheck)
	for shape in check:
		if shape.collider.is_in_group("moveable"):
			var direction=(shape.collider.position-position)
			shape.collider.apply_central_impulse(direction.normalized()*min(explosionPower/(direction.length()*4),explosionPower))
	queue_free()
