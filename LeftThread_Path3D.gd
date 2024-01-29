@tool
extends Path3D

#var my_prop: get = get_my_prop, set = set_my_prop

@export var distance_between_planks: float=1.0: 
	set(new_value):
		is_dirty=true
		distance_between_planks=new_value
		#distance_between_planks = clamp(new_value,0,1)
		
		
@export var Path3D_to_follow:Path3D
@export var mm_instance_3D:MultiMeshInstance3D
#@onready var mm_instance_3DReady:MultiMeshInstance3D=mm_instance_3D
var is_dirty:bool=false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_dirty:
		_update_multimesh()
		is_dirty=false

func _update_multimesh():
	var path_length:float = curve.get_baked_length()
	var count = floor(path_length / distance_between_planks)
	
	var mm:MultiMesh=mm_instance_3D.multimesh
	mm.instance_count=count
	var offset:float=distance_between_planks/2
	
	for i in range(0,count):
		var curve_distance:float= offset+distance_between_planks * i
		var position:Vector3 = curve.sample_baked(curve_distance,true)
		
		#this is for orientation of the multimesh
		var basis:Basis=Basis()
		var up:Vector3 =curve.sample_baked_up_vector(curve_distance,true)
		
		var forward:Vector3 =position.direction_to(curve.sample_baked(curve_distance+0.1,true))
		
		basis.y=up
		basis.x=forward.cross(up).normalized()
		basis.z=-forward
		
		var transform:Transform3D=Transform3D(basis,position)
		mm.set_instance_transform(i,transform)
		
		
		
		
		
		
		
		


func _on_curve_changed():
	is_dirty=true
