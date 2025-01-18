extends RigidBody3D
class_name vein_node

@export var is_fixed: bool = true
@export var is_grabbable: bool = true

func _ready() -> void:
	freeze = is_fixed
