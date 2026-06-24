extends Node

var axe_recipes: Dictionary = {
	Vector2i(3, 2): Vector2i(1, 4),
}

var pickaxe_recipes: Dictionary = {
	Vector2i(2, 2): Vector2i(1, 3),
}

# altid must also have id
var building_recipes: Dictionary = {
	"wood_wall": {
		"name": "Wood Wall",
		"atlas_coords": Vector2i(5, 2),
		"id": 1,
		"altid": 4, 
		"wood": 1,
	},
	"stone_wall": {
		"name": "Stone Wall",
		"atlas_coords": Vector2i(5, 3),
		"id": 1,
		"altid": 5, 
		"stone": 2,
	},
	"iron_wall": {
		"name": "Iron Wall",
		"atlas_coords": Vector2i(5, 4),
		"id": 1,
		"altid": 6, 
		"iron": 2,
		"stone": 3,
	},
}
