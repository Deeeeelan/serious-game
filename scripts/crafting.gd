extends Control

@onready var player = %Player
@onready var ground = %Ground
@onready var gear_manager = %GearManager

var building_section = preload("res://assets/nodes/building_section.tscn")

var materials = ["wood", "stone", "iron", "gold"]

func _ready() -> void:
	for recipe in GameRecipes.building_recipes.values():
		var new_gui = building_section.instantiate()
		var texture: AtlasTexture = new_gui.get_node("TextureRect").texture.duplicate()
		new_gui.get_node("TextureRect").texture = texture
		texture.region = Rect2(recipe.atlas_coords[0] * 32, recipe.atlas_coords[1] * 32, 32, 32)
		var desc = "%s\n" % [recipe.name]
		for mat in materials:
			if mat in recipe:
				desc += "[b]%s:[/b] " % mat + str(recipe[mat]) + " "
		
		var button: Button = new_gui.get_node("Craft")
		button.pressed.connect(func():
			var player_pos = ground.local_to_map(player.position)
			var can_craft = true
			can_craft = player.valid_player_drop_pos(ground, player_pos)
			for mat in materials:
				if mat in recipe and GameStats[mat] < recipe[mat]:
					can_craft = false
			if can_craft:
				if "gen" in recipe:
					if %GearAndGenMap.get_cell_source_id(player_pos) != -1:
						return
				for mat in materials:
					if mat in recipe:
						GameStats[mat] -= recipe[mat]
				if "gear" in recipe:
					gear_manager.placeGear(player_pos)
				elif "gen" in recipe:
					gear_manager.placeTestGen(player_pos , ((recipe.atlas_coords.x - 7) / 2) + 1)
				else:
					if "altid" in recipe:
						ground.set_cell(player_pos, recipe.id, Vector2i(0, 0), recipe.altid)
					else:
						ground.set_cell(player_pos, 0, recipe.atlas_coords)
				print("crafted", recipe.name)
		)
			
		
		new_gui.get_node("RichTextLabel").text = desc
		$ScrollContainer/VBoxContainer.add_child(new_gui)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		if visible:
			visible = false
		else:
			visible = true
