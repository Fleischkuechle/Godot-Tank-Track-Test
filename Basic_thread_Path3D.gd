@tool
extends Path3D
var time :float=0.0
@export var speed:float =2.0:
	set(new_value):
			#is_dirty=true
			speed=new_value
			
#@export var offset:float=0.25:
	#set(new_value):
		#offset=new_value


@export var Node_that_follow_the_Path:Node3D
#$ParentForPathNode3D/LeftThread_Path3D
@onready var PathFollower_list:Array =self.get_children()

@export var distance_between_planks: float=0.25: 
	set(new_value):
		is_dirty=true
		distance_between_planks=new_value
		#distance_between_planks = clamp(new_value,0,1)
		
		
@export var Path3D_to_follow:Path3D
#@export var mm_instance_3D:MultiMeshInstance3D
#@onready var mm_instance_3DReady:MultiMeshInstance3D=mm_instance_3D
var is_dirty:bool=false



# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_dirty:
		print('updating because dirty')
		_update_thread()
		is_dirty=false
	
	
	
	time+=delta
	var count:int =0
	for index in PathFollower_list:
		if index is PathFollow3D:
			index.progress=speed*time+(distance_between_planks*count)
			count+=1
	
	pass


func _update_thread():
	var path_length:float = self.curve.get_baked_length()
	var new_count = floor(path_length / distance_between_planks)
	print("new count",new_count)
	var last_child_index=self.get_child_count()-1
	print("lastchildIndex",last_child_index)
	if new_count > last_child_index:
		#we need to add pathfollow3d elements
		var child=self.get_child(0,true)
		var difference=new_count-last_child_index
		print("difference=",difference)
			#print(sceneroot.name)		
		var sceneroot=get_tree().edited_scene_root
		#var path =self.get_path()
		#var parent=  sceneroot.get_node(path)
		for i in range(0,difference):
			print('trying to add pathfollow3D new')
			var new_child:PathFollow3D=PathFollow3D.new()
			#sceneroot.add_child(new_child,true)
			#self.add_child(new_child,true)
			#new_child.owner=sceneroot
			print(self.name)
			var myselve=sceneroot.find_child(self.name)
			
			###myselve.add_child(new_child,true)
			#new_child.owner=sceneroot
			
			#new_child.owner=myselve
			#sceneroot.add_child(new_child,true)
			last_child_index=self.get_child_count()-1
			child=self.get_child(0,true)
			if child is PathFollow3D:
				var duplicated_child= child.duplicate(8)
				#duplicated_child.add_child(Node_that_follow_the_Path)
				#self.add_child(duplicated_child,true)
				#duplicated_child.owner =self
				self.add_child(duplicated_child,true)
				#myselve.add_child(duplicated_child,true)
				
				duplicated_child.owner=sceneroot
		PathFollower_list =self.get_children()
	else:
		var child=self.get_child(last_child_index)
		var difference=last_child_index-new_count
		for i in range(0,difference):
			last_child_index=self.get_child_count()-1
			var last_child = self.get_child(last_child_index)
			self.remove_child(last_child)
		#
			
		#remove childs
		
	#var mm:MultiMesh=mm_instance_3D.multimesh
	#mm.instance_count=count
	#var offset:float=distance_between_planks/2
	#
	#for i in range(0,count):
		#var curve_distance:float= offset+distance_between_planks * i
		#var position:Vector3 = curve.sample_baked(curve_distance,true)
		#
		##this is for orientation of the multimesh
		#var basis:Basis=Basis()
		#var up:Vector3 =curve.sample_baked_up_vector(curve_distance,true)
		#
		#var forward:Vector3 =position.direction_to(curve.sample_baked(curve_distance+0.1,true))
		#
		#basis.y=up
		#basis.x=forward.cross(up).normalized()
		#basis.z=-forward
		#
		#var transform:Transform3D=Transform3D(basis,position)
		#mm.set_instance_transform(i,transform)



func _on_curve_changed():
	is_dirty=true
