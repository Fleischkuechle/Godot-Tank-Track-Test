@tool
extends Path3D
var time :float=0.0
var is_on=false
@onready var first_init=true
@export var on:bool =false
	#get:
		#is_on=on
		#is_dirty=true
			#on=new_value
		#is_dirty=true
		
@export var speed:float =2.0:
	set(new_value):
			speed=new_value
@export var distance_between_planks: float=0.25: 
	set(new_value):
		is_dirty=true
		distance_between_planks=new_value
			
#@export var Tscn_that_follow_the_Path:PackedScene:
	#set(new_tscn):
		#print("changed Tscn")
		#Tscn_that_follow_the_Path=new_tscn
		#change_node_in_PathToFollow()
#@export var Node_that_follow_the_Path:Node3D:
	#set(new_node):
		#if new_node:
			#Node_that_follow_the_Path=new_node
##@export var Node_that_follow_the_Path:Node3D:
	#set(new_node):
		#
		#Node_that_follow_the_Path=new_node
		
#$ParentForPathNode3D/LeftThread_Path3D
@onready var PathFollower_list:Array =self.get_children()

#

#@export var Path3D_to_follow:Path3D
var is_dirty:bool=false
var PathFollow3D_Node:PathFollow3D
var TrackElement:Node3D


func change_node_in_PathToFollow():
	print("change_node_in_PathToFollow ")
	#Node_that_follow_the_Path=Tscn_that_follow_the_Path.instantiate()
	replace_track_elements()
	#removing 
	#PathFollow3D_Node.remove_child(0)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	remove_all_children()
	if on:
		replace_track_elements()
	is_dirty=true
	#PathFollow3D_Node=PathFollow3D.new()
	#PathFollow3D_Node.name="PathFollow3D_Node"
	#if PathFollow3D_Node:
		#TrackElement=Tscn_that_follow_the_Path.instantiate()
		#PathFollow3D_Node.add_child(TrackElement)
	#var sceneroot=get_tree().edited_scene_root
	#sceneroot.add_child(PathFollow3D_Node,true)
	#PathFollow3D_Node.owner=sceneroot
	#is_dirty=true
	pass # Replace with function body.
func replace_track_elements():
	
	var sceneroot=get_tree().edited_scene_root
	remove_all_children()
	#PathFollow3D_Node=PathFollow3D.new()
	#PathFollow3D_Node.name="PathFollow3D_Node"
	#if PathFollow3D_Node:
		#TrackElement=Tscn_that_follow_the_Path.instantiate()
		#PathFollow3D_Node.add_child(TrackElement)
	#
	#sceneroot.add_child(PathFollow3D_Node,true)
	#PathFollow3D_Node.owner=sceneroot
	is_dirty=true
func add_Pathfollow3DNode():
	var sceneroot=get_tree().edited_scene_root
	PathFollow3D_Node=PathFollow3D.new()
	PathFollow3D_Node.name="PathFollow3D_Node"
	if PathFollow3D_Node:
		#TrackElement=Tscn_that_follow_the_Path.instantiate()
		#PathFollow3D_Node.add_child(TrackElement)
	
		self.add_child(PathFollow3D_Node,true)
		PathFollow3D_Node.owner=sceneroot
	
func  remove_all_children():
	var sceenparent=get_tree().edited_scene_root
	print('ChildCount:',self.get_child_count())
	if self.get_child_count()>1:
		var upperRange=self.get_child_count()
		
		for i in range(1,upperRange):
			#for i in get_children():
			
				#last_child_index=self.get_child_count()-1
			var tmp_child = self.get_child(i)
			tmp_child.queue_free()
			print("removing child:",i)
			#sceenparent.remove_child.call_deferred(tmp_child)
			#sceenparent.remove_child(tmp_child)
		#sceenparent=get_tree().edited_scene_root
		print("Number of children: ",self.get_child_count())
		PathFollower_list.clear()
		PathFollower_list =self.get_children()
	else:
		if self.get_child_count()<1:
			add_Pathfollow3DNode()
		PathFollower_list =self.get_children()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if first_init:
		remove_all_children()
		_update_thread()
		first_init=false
	
	
	
	if is_on:
		
		
		if Engine.is_editor_hint():
			if is_dirty:
				print('updating because dirty')
				_update_thread()
				is_dirty=false
	time+=delta
	var count:int =0
	PathFollower_list =self.get_children()
	for index in PathFollower_list:
		if index is PathFollow3D:
			index.progress=speed*time+(distance_between_planks*count)
			count+=1
		
		
	if on and not is_on:
		is_on=true
		is_dirty=true
	if not on and is_on:
		is_on=false
		#is_dirty=true
	pass


func _update_thread():
	#remove_all_children()
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
			print('Adding pathfollow3D duplicate from child(0)')
			
			#last_child_index=self.get_child_count()-1
			#child=self.get_child(last_child_index)
			if child is PathFollow3D:
				var duplicated_child= child.duplicate()
				self.add_child(duplicated_child,true)
				duplicated_child.owner=sceneroot
		PathFollower_list.clear()
		PathFollower_list =self.get_children()
	else:
		var child=self.get_child(last_child_index)
		var difference=last_child_index-new_count
		for i in range(0,difference):
			last_child_index=self.get_child_count()-1
			var last_child = self.get_child(last_child_index)
			self.remove_child(last_child)

func _on_curve_changed():
	is_dirty=true
