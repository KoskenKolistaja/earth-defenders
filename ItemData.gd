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

var facilities = {
	"repair_station" : repair_station,
	"geo_repair_station" : geo_repair_station,
	"technology_institute" : technology_institute
}


var combat_ship = preload("res://Entities/Player/combat_ship.tscn")
var speeder = preload("res://Entities/Player/speeder.tscn")


var ships = {
	"combat_ship" : combat_ship,
	"speeder" : speeder
}
