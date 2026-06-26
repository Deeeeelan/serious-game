extends Node

var waves : Dictionary = {
	1: {
		"total": 3,
		"mobs": [
			{
				"path": "res://assets/mobs/enemy_basic.tscn",
				"count": 3,
				"delay": 1.0,
			}
		],
	},
	2: {
		"total": 5,
		"mobs": [
			{
				"path": "res://assets/mobs/enemy_basic.tscn",
				"count": 3,
				"delay": 1.0,
			},
			{
				"path": "res://assets/mobs/enemy_ranged.tscn",
				"count": 2,
				"delay": 1.0,
			}
		],
	},
	3: {
		"total": 6,
		"mobs": [
			{
				"path": "res://assets/mobs/enemy_basic.tscn",
				"count": 6,
				"delay": 1.0,
			}
		],
	},
	4: {
		"total": 1,
		"mobs": [
			{
				"path": "res://assets/mobs/enemy_basic.tscn",
				"count": 1,
				"delay": 1.0,
			}
		],
	},
	5: {
		"total": 12,
		"mobs": [
			{
				"path": "res://assets/mobs/enemy_basic.tscn",
				"count": 12,
				"delay": 0.8,
			}
		],
	},
	6: {
		"total": 20,
		"mobs": [
			{
				"path": "res://assets/mobs/enemy_basic.tscn",
				"count": 20,
				"delay": 0.05,
			}
		],
	},
	7: {
		"total": 12,
		"mobs": [
			{
				"path": "res://assets/mobs/enemy_basic.tscn",
				"count": 12,
				"delay": 0.7,
			}
		],
	},
}
