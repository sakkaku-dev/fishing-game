class_name RopePart
extends RigidBody2D

@onready var pin := $CollisionShape2D/PinJoint2D

func connect_part(part: PhysicsBody2D):
	part.global_position = pin.global_position
	pin.node_b = part.get_path()
