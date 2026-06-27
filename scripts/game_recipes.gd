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
		"wood": 6,
		"stone": 6,
		"gold": 10,
	},
	"explosive_turret": {
		"name": "Explosive Turret",
		"atlas_coords": Vector2i(8, 3),
		"id": 1,
		"altid": 8, 
		"wood": 10,
		"stone": 14,
		"gold": 30,
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
	"sturdy_wall": {
		"name": "Sturdy Wall",
		"atlas_coords": Vector2i(5, 4),
		"id": 1,
		"altid": 6, 
		"wood": 4,
		"stone": 6,
	},
	"axe": {
		"name": "Axe",
		"atlas_coords": Vector2i(4, 3),
		"id": 1,
		"altid": 2, 
		"wood": 4,
	},
	"pickaxe": {
		"name": "Pickaxe",
		"atlas_coords": Vector2i(4, 4),
		"id": 1,
		"altid": 3, 
		"wood": 6,
	},
	"gen1": {
		"name": "Generator 1",
		"gen": true,
		"atlas_coords": Vector2i(7, 0),
		"wood": 10,
		"stone": 10,
		"gold": 25,
	},
	"gen2": {
		"name": "Generator 2",
		"gen": true,
		"atlas_coords": Vector2i(9, 0),
		"wood": 15,
		"stone": 15,
		"gold": 50,
	},
	"gen3": {
		"name": "Generator 3",
		"gen": true,
		"atlas_coords": Vector2i(11, 0),
		"wood": 20,
		"stone": 20,
		"gold": 75,
	},
}
