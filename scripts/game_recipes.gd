extends Node

var axe_recipes: Dictionary = {
	Vector2i(3, 2): Vector2i(1, 4),
}

var pickaxe_recipes: Dictionary = {
	Vector2i(2, 2): Vector2i(1, 3),
}

# altid must also have id
var building_recipes: Dictionary = {
	"gear": {
		"name": "Gear",
		"atlas_coords": Vector2i(9, 2),
		"gear": true,
		"wood":1,
	},
	"turret": {
		"name": "Turret",
		"atlas_coords": Vector2i(8, 2),
		"id": 1,
		"altid": 7, 
		"wood": 8,
		"stone": 8,
		"gold": 20,
	},
	"explosive_turret": {
		"name": "Explosive Turret",
		"atlas_coords": Vector2i(8, 3),
		"id": 1,
		"altid": 8, 
		"wood": 12,
		"stone": 18,
		"gold": 40,
	},
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
	"axe": {
		"name": "Axe",
		"atlas_coords": Vector2i(4, 3),
		"id": 1,
		"altid": 2, 
		"wood": 6,
	},
	"pickaxe": {
		"name": "Pickaxe",
		"atlas_coords": Vector2i(4, 4),
		"id": 1,
		"altid": 3, 
		"wood": 8,
	},
	"gen1": {
		"name": "Generator 1",
		"gen": true,
		"atlas_coords": Vector2i(7, 0),
		"wood": 10,
		"stone": 10,
		"gold": 45,
	},
	"gen2": {
		"name": "Generator 2",
		"gen": true,
		"atlas_coords": Vector2i(9, 0),
		"wood": 20,
		"stone": 20,
		"gold": 100,
	},
	"gen3": {
		"name": "Generator 3",
		"gen": true,
		"atlas_coords": Vector2i(11, 0),
		"wood": 30,
		"stone": 30,
		"gold": 150,
	},
}
