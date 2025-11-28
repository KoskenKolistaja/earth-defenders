@tool
extends EditorScript

# Customize these:
const TARGET_NODE_PATH := "Positions"  # path to your planet node
const NUM_POINTS := 20
const RADIUS := 5.0
const NODE_NAME_PREFIX := ""
const FACING_DIRECTION := Vector3(0, 0, 1)  # which hemisphere (front side)

func _run():
	var scene_root = get_editor_interface().get_edited_scene_root()
	if not scene_root:
		push_error("No edited scene open!")
		return

	var target: Node3D = scene_root.get_node_or_null(TARGET_NODE_PATH)
	if not target:
		push_error("Target node not found: %s" % TARGET_NODE_PATH)
		return

	# Remove existing children with the same prefix
	for child in target.get_children():
		if child.name.begins_with(NODE_NAME_PREFIX):
			child.queue_free()

	var points_created = 0
	var i = 0
	while points_created < NUM_POINTS and i < NUM_POINTS * 6:
		var local_pos = get_fibonacci_sphere_position(i, NUM_POINTS * 2) * RADIUS

		# Only keep points on the desired side of the sphere
		if local_pos.normalized().dot(FACING_DIRECTION.normalized()) > 0.0:
			var global_pos = target.global_position + local_pos
			var node = Node3D.new()
			node.name = "%s%d" % [NODE_NAME_PREFIX, points_created + 1]
			target.add_child(node)
			node.owner = scene_root
			node.global_position = global_pos
			node.look_at(target.global_position, Vector3.UP)
			points_created += 1
		i += 1



func get_fibonacci_sphere_position(i: int, n: int) -> Vector3:
	var phi = (sqrt(5.0) + 1.0) / 2.0
	var angle = 2.0 * PI * i / phi
	var y = 1.0 - (i / float(n - 1)) * 2.0
	var r = sqrt(1.0 - y * y)
	var x = cos(angle) * r
	var z = sin(angle) * r
	return Vector3(x, y, z)
