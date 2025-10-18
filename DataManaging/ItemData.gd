extends Node

var missile_launcher = preload("res://Entities/Weapons/missile_launcher.tscn")
var rocket_launcher = preload("res://Entities/Weapons/rocket_launcher.tscn")
var vacuum_gun = preload("res://Entities/Weapons/vacuum_gun.tscn")
var blaster = preload("res://Entities/Weapons/blaster.tscn")
var rifle = preload("res://Entities/Weapons/rifle.tscn")


var weapons = {
	"missile_launcher" : missile_launcher,
	"rocket_launcher" : rocket_launcher,
	"vacuum_gun" : vacuum_gun,
	"blaster" : blaster,
	"rifle" : rifle
}



var repair_station = preload("res://Entities/Buildings/repair_station.tscn")
var geo_repair_station = preload("res://Entities/Buildings/geo_repair_station.tscn")
var technology_institute = preload("res://Entities/Buildings/technology_institute.tscn")
var bank = preload("res://Entities/Buildings/bank.tscn")

var facilities = {
	"repair_station" : repair_station,
	"geo_repair_station" : geo_repair_station,
	"technology_institute" : technology_institute,
	"bank" : bank
}


var combat_ship = preload("res://Entities/Player/combat_ship.tscn")
var speeder = preload("res://Entities/Player/speeder.tscn")


var ships = {
	"combat_ship" : combat_ship,
	"speeder" : speeder
}



var item_prices = {
	"speeder" : 500,
	"combat_ship" : 500,
	"repair_station" : 200,
	"geo_repair_station" : 500,
	"technology_institute" : 200,
	"bank" : 200,
	"none" : 0,
}



var item_info = {
	"speeder" : "Speeder is an agile ship equipped with the most advanced propulsion technology making it the fastest ship type in the galaxy.  Just keep in mind its stripped-down armor makes it vulnerable for blast damage.",
	"combat_ship" : "Combat ship is an solid all-arounder that can take you moderately fast from point a to b. It has pretty strong armor making it capable of surviving some damage.",
	"repair_station" : "Repair station is an earth installation that uses ion ray technology to carry required supplies and energy to maintain any ship in the earths lower orbit. No landings needed!",
	"geo_repair_station" : "Geo repair station doesn't have anything to do with ships or the ongoing war with Martians. It is a vast set of infrastructure needed to patch up possible damage caused to a planet. It is expensive but it is much needed to protect the most valuable asset: Earth.",
	"technology_institute" : "Technology is essential when trying to defend against extraterrestial threats. The right advancements in weapon technology might be the key to change the tide of a battle or even a war. Technology institute grants you xp multipliers.",
	"bank" : "Investments might seem irrelevant during war but right economical decisions will help you outlast the enemy. Banks provide you with a steady flow of money.",
	"none" : "",
}
