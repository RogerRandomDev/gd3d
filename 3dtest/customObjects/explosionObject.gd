extends Node3D
class_name ExplosionObject

@export var explosionRadius:float=2.
@export var explosionPower:float=1.

var ignore=null
func _ready():
	call_deferred('explode')


func explode():
	var explosionCheck=PhysicsShapeQueryParameters3D.new()
	explosionCheck.shape=SphereShape3D.new()
	explosionCheck.shape.radius=explosionRadius
	explosionCheck.collision_mask=1
	explosionCheck.transform=global_transform
	var state=get_world_3d().direct_space_state
	var check:=state.intersect_shape(explosionCheck)
	var rayCheck=PhysicsRayQueryParameters3D.new()
	rayCheck.collision_mask=1
	rayCheck.from=global_transform.origin
	for shape in check:
		if shape.collider.is_in_group("moveable")&&!shape.collider==ignore:
			rayCheck.to=shape.collider.global_transform.origin
			var rcheck:=state.intersect_ray(rayCheck)
			if rcheck.get("position")==null:
				rcheck["position"]=shape.collider.position
			var direction=(rcheck.position-position)
			shape.collider.apply_central_impulse(direction.normalized()*min(explosionPower/(direction.length()*4),explosionPower))
	queue_free()
