extends Node
class_name AnimationTreeSwitcher

var animationTree 
var animationState

func _init(a_animationTree):
	animationTree = a_animationTree
	animationState = animationTree.get("parameters/playback")
	animationTree.active = true
	
func switch_animation(state, vector):
	match state:
		Global.States.MOVE, Global.States.WANDER, Global.States.CHASE:
			animationTree.set("parameters/Idle/blend_position", vector)
			animationTree.set("parameters/Move/blend_position", vector)
			animationTree.set("parameters/Attack/blend_position", vector)
			animationState.travel("Move")
		Global.States.IDLE:
			animationState.travel("Idle")
		Global.States.ATTACK:
			animationState.travel("Attack")
