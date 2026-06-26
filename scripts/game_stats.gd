extends Node

var day: int = 1
var time: int = 0
var current_mobs_defeated : int = 0

var wood: int = 0
var stone: int = 0
var gold: int = 0
var iron: int = 0

var DEBUG = true

func _ready() -> void:
	push_warning("RUNNING DEBUG")
