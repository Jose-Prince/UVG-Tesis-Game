extends Node

var game_slot := 0
var player_name := ""
var money := 0

var shop_name := ""

var month := 0
var day := ""
var num_day := 0
var year := 0

func load_to_data(data: Dictionary):
	player_name = data["player"]["name"]
	money = data["player"]["money"]

	shop_name = data["coffee_shop"]["name"]

	day = data["world"]["day"]
	num_day = data["world"]["num_day"]
	month = data["world"]["month"]
	year = data["world"]["year"]
	
