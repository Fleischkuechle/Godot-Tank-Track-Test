extends Label

@export  var vehicle_path:NodePath 
#@onready var vehicle:RigidBody3D= self.get_node(vehicle_path) as RigidBody3D
@onready var vehicle:RigidBody3D

func _ready():
	vehicle= self.get_node(vehicle_path) as RigidBody3D
	#var vehicle:RigidBody3D=get_node(vehicle) as RigidBody3D
	pass


func _physics_process(delta: float) -> void:
	#var velocety:float =vehicle.linear_velocity.z
	#var basiszs:float= vehicle.global_transform.basis.z
	var vector:Vector3=vehicle.linear_velocity*vehicle.global_transform.basis.z
	var speed : float = vector.z
	text = "%d KM/H" % [speed * 3.6]
