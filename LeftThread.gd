@tool
extends Node3D


var time :float=0.0
@export var speed:float =2.0:
	set(new_value):
			#is_dirty=true
			speed=new_value
var offset:float=0.25

@export var Mesh_that_follow_the_Path:MeshInstance3D
#$ParentForPathNode3D/LeftThread_Path3D

@onready var links:Array =$LeftThread_Path3D.get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time+=delta
	var count:int =0
	for index in links:
		if index is PathFollow3D:
			index.progress=speed*time+(offset*count)
			count+=1
	
	pass
