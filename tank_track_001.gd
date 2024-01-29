@tool
extends Node3D
var time :float=0.0
@export var speed:float =2.0:
	set(new_value):
			speed=new_value

@export var Node_that_follow_the_Path:Node3D
#$ParentForPathNode3D/LeftThread_Path3D
@onready var PathFollower_list:Array =Path3D_to_follow.get_children()

@export var distance_between_planks: float=0.25: 
	set(new_value):
		is_dirty=true
		distance_between_planks=new_value

@export var Path3D_to_follow:Path3D
var is_dirty:bool=false



# Called when the node enters the scene tree for the first time.
func _ready():
	is_dirty=true
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
	var path_length:float = Path3D_to_follow.curve.get_baked_length()
	var new_count = floor(path_length / distance_between_planks)
	print("new count",new_count)
	var last_child_index=Path3D_to_follow.get_child_count()-1
	print("lastchildIndex",last_child_index)
	if new_count > last_child_index:
		#we need to add pathfollow3d elements
		var child=Path3D_to_follow.get_child(0,true)
		var difference=new_count-last_child_index
		print("difference=",difference)
			#print(sceneroot.name)		
		var sceneroot=get_tree().edited_scene_root
		#var path = Path3D_to_follow.get_path()
		#var parent=  sceneroot.get_node(path)
		for i in range(0,difference):
			print('trying to add pathfollow3D new')
			
			#last_child_index= Path3D_to_follow.get_child_count()-1
			#child= Path3D_to_follow.get_child(last_child_index)
			if child is PathFollow3D:
				var duplicated_child= child.duplicate()
				Path3D_to_follow.add_child(duplicated_child,true)
				duplicated_child.owner=sceneroot
		PathFollower_list = Path3D_to_follow.get_children()
	else:
		var child= Path3D_to_follow.get_child(last_child_index)
		var difference=last_child_index-new_count
		for i in range(0,difference):
			last_child_index= Path3D_to_follow.get_child_count()-1
			var last_child = Path3D_to_follow.get_child(last_child_index)
			Path3D_to_follow.remove_child(last_child)

#func _on_curve_changed():
	#is_dirty=true


func _on_path_3d_curve_changed():
	print("udating is dirty")
	is_dirty=true
