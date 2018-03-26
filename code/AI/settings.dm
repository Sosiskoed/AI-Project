//! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !
//-------------------------------------------


//Значения 0=нет и 1=да
var/AIDB_from_reserve = 0//Не обеспечивает обновление БД. Это на случай того, если в результате
//манипуляций код начнет удалять БД и вам надоест вручную восстанавливать её из резерва
//Однако, БД все равно выгружается в основную папку.
var/AIDB_to_reserve = 0//Пользоваться аккуратно. Это обеспечивает обновление резервной базы данных вместе с основной.
//В случае, если код сломан, вы потеряете все накопленные данные из БД без возможности быстрого возврата

//На случай феноменальной косорукости кодера, оставил
//резервный шаблон БД, в котором хоть что-то, но есть. Только заполненное вручную.
//Он защищен от автообновления


//-------------------------------------------
//! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !






var/list/datum/AI_knowledge/AI_knowledges = list()
var/list/word_categories = list("hello",
		"yes",
		"no",
		"follow me",
		"understand",
		"goodbye",
		"my name",
		"hate word")

var/list/neuron_question_words = list()
var/list/neuron_word_categories = list()







datum/AI_knowledge
	var/language
	var/list/categories = list()

datum/word_category
	var/name
	var/list/words = list()
	var/language = "ru"

datum/word//Вход - только слово. Значит это три нейрона
	var/word
	var/success
	var/all
	var/language = "ru"
	var/category




world/Start()//Загрузка знаний из БД
	load_aiknowledge()
	..()

world/HourLoop()
	save_aiknowledge()
	..()

world/End()
	save_aiknowledge()
	..()



/*
Итак, я могу сделать конкретное число нейронов, или же сделать динамичное число
Динамика кажется проще, но лишь потому, что я наверно чего то не понимаю


*/


