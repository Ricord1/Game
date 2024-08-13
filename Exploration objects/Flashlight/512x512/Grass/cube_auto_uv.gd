extends Node

export var x_axis : bool = true
export var y_axis : bool = true
export var z_axis : bool = true
export var parent : NodePath
export var mesh : NodePath

# Automatically adjusts the UV coordinates of a cube mesh based on its parent's scale.
func cube_auto_uv():
	# Check if the parent and mesh nodes exist
	if parent and mesh:
		var parent_node: Spatial = get_node(parent)
		var mesh_node: Node = get_node(mesh)
		var surface_array: Array = mesh_node.get_mesh().surface_get_arrays(0)

		# Adjust UV coordinates along the x-axis
		if x_axis:
			for i in [8, 9, 10, 11, 12, 13, 14, 15]: # Left and right
				surface_array[Mesh.ARRAY_TEX_UV][i] *= Vector2(parent_node.scale.z, parent_node.scale.y)

		# Adjust UV coordinates along the y-axis
		if y_axis:
			for i in [16, 17, 18, 19, 20, 21, 22, 23]: # Top and bottom
				surface_array[Mesh.ARRAY_TEX_UV][i] *= Vector2(-parent_node.scale.x, -parent_node.scale.z)

		# Adjust UV coordinates along the z-axis
		if z_axis:
			for i in [0, 1, 2, 3, 4, 5, 6, 7]: # Front and back
				surface_array[Mesh.ARRAY_TEX_UV][i] *= Vector2(parent_node.scale.x, parent_node.scale.y)

		# Create a new mesh with adjusted UV coordinates
		var new_mesh: ArrayMesh = ArrayMesh.new()
		new_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
		mesh_node.set_mesh(new_mesh)

func _ready():
	# Automatically adjust UV coordinates when the node is ready
	cube_auto_uv()
