extends Node

var axe_recipes: Dictionary = {
	Vector2i(3, 2): Vector2i(1, 4),
}

var pickaxe_recipes: Dictionary = {
	Vector2i(2, 2): Vector2i(1, 3),
}

var building_recipes: Dictionary = {
	"wood_wall": {
		"name": "Wood Wall",
		"atlas_coords": Vector2i(0, 0),
		"wood": 1,
	},
	"stonewall": {
		"name": "Stone Wall",
		"atlas_coords": Vector2i(0, 1),
		"wood": 1,
		"stone": 1,
	},
}
