extends Node

var waves : Dictionary = {
	1: {
		"total": 3,
		"mobs": [
			{
				"path": "res://assets/mobs/enemy_basic.tscn",
				"count": 3,
				"delay": 1.0,
				"boss": 1,
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
		"total": 10,
		"mobs": [
			{
				"path": "res://assets/mobs/enemy_ranged.tscn",
				"count": 4,
				"delay": 0.5,
			},
			{
				"path": "res://assets/mobs/enemy_basic.tscn",
				"count": 6,
				"delay": 1.0,
			},

		],
	},
	4: {
		"total": 18,
		"mobs": [
			{
				"path": "res://assets/mobs/enemy_ranged.tscn",
				"count": 5,
				"delay": 0.5,
			},
			{
				"path": "res://assets/mobs/enemy_basic.tscn",
				"count": 5,
				"delay": 0.5,
			},
			{
				"path": "res://assets/mobs/enemy_ranged.tscn",
				"count": 4,
				"delay": 0.7,
			},
			{
				"path": "res://assets/mobs/enemy_basic.tscn",
				"count": 4,
				"delay": 0.7,
			},
		],
	},
	5: {
		"total": 32,
		"mobs": [
			{
				"path": "res://assets/mobs/enemy_basic.tscn",
				"count": 12,
				"delay": 0.8,
			},
			{
				"path": "res://assets/mobs/enemy_ranged.tscn",
				"count": 12,
				"delay": 0.2,
			},
			{
				"path": "res://assets/mobs/enemy_basic.tscn",
				"count": 8,
				"delay": 0.8,
			},
		],
	},
	6: {
		"total": 35,
		"mobs": [
			{
				"path": "res://assets/mobs/enemy_ranged.tscn",
				"count": 35,
				"delay": 0.05,
			}
		],
	},
	7: {
		"total": 52,
		"mobs": [
			{
				"path": "res://assets/mobs/enemy_basic.tscn",
				"count": 10,
				"delay": 0.7,
			},
			{
				"path": "res://assets/mobs/enemy_ranged.tscn",
				"count": 10,
				"delay": 0.5,
			},
			{
				"path": "res://assets/mobs/enemy_basic.tscn",
				"count": 1,
				"delay":  6,
			},
			{
				"path": "res://assets/mobs/enemy_basic.tscn",
				"count": 1,
				"boss": 1,
				"delay": 3,
			},
			{
				"path": "res://assets/mobs/enemy_ranged.tscn",
				"count": 20,
				"delay": 0.05,
			},
			{
				"path": "res://assets/mobs/enemy_basic.tscn",
				"count": 10,
				"delay":  1,
			},
		],
	},
}
