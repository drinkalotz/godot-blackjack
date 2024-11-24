extends Node3D
const texture_scale = Vector3(0.9, 0.9, 0.9)
const texture_offset = Vector3(0.5, 0.5, 0.5)
@onready var front: MeshInstance3D = $front
const card_asset_path: String = 'assets/cards/%s'
var card_score = 0
var card_score_alt = 0

func set_card(card_path: String, card_score_out: int, card_alt_score_out: int):
	var front_material = StandardMaterial3D.new() 
	card_score = card_score_out
	card_score_alt = card_alt_score_out
	var image = Image.new()
	var err = image.load(card_asset_path % card_path)
	if err != OK:
		print('error loading texture')
	else:
		front_material.albedo_texture = ImageTexture.create_from_image(image)
		front_material.uv1_triplanar = true
		front_material.uv1_offset = texture_offset
		front_material.uv1_scale = texture_scale
		front.material_override = front_material
		

	
