//По идее, это должно сохранять массивные обьекты без вложенных массивов

proc/save_aiknowledge()
	for(var/datum/AI_knowledge/AI0 in AI_knowledges)
		for(var/datum/word_category/category in AI0.categories)
			fdel("database/main/[AI0.language]/[category.name].txt")

			var/list/datum/word/sublist = list()//Сортировка

			for(var/datum/word/WORD in category.words)//Сортировка по вероятности
				var/datum/word/subWORD = sublist.len ? sublist[length(sublist)] : null

				if(!subWORD || probe(WORD) < probe(subWORD))
					sublist += WORD
				else
					sublist.Insert(1, WORD)

			save_simplelist(sublist, "database/main/[AI0.language]/[category.name].txt")

			if(AIDB_to_reserve==1)
				fdel("database/reserve/[AI0.language]/[category.name].txt")
				save_simplelist(sublist, "database/reserve/[AI0.language]/[category.name].txt")



proc/save_simplelist(var/list/L, var/savepath)
	var/T
	for(var/datum/word/W in L)
		T += "[W.word]|[W.success]_[W.all]\n"
	fdel(savepath)
	text2file(T, savepath)



//--------------------------------------------------------------------------------------
//      Принцип сохранения прост: Время загрузки сконцентрировано в начале и конце
//--------------------------------------------------------------------------------------



proc/load_aiknowledge()
	for(var/lang in languages) //Создаем хранилище баз знаний, сегментированное по языкам
		var/datum/AI_knowledge/AI0 = new
		AI0.language = lang
		AI_knowledges += AI0

	for(var/datum/AI_knowledge/AI0 in AI_knowledges)//Заполняем это хранилище в соответствии с имеющимися языками
		for(var/category in word_categories)//Место категории в этом листе определяется не по имени, а по месту в другом листе
			var/datum/word_category/AI1 = new
			AI1.name = category
			AI1.language = AI0.language
			AI1.words = list_from_file("database/[AIDB_from_reserve ? "reserve" : "main"]/[AI1.language]/[category].txt", category, AI0.language)
			for(var/datum/word/AI2 in AI1.words)
				AI2.language = AI1.language
			AI0.categories += AI1



proc/list_from_file(var/savepath, var/ctgr, var/lang)//Извлечения БД->Лист по диапазону вероятности
	var/list/words = list()

	for(var/S in splittext(file2text(savepath), "\n"))
		var/datum/word/WORD = new/datum/word()
		WORD.word 		= copytext(S, 1, findtext(S, "|"))
		WORD.success 	= text2num(copytext(S, findtext(S, "|")+1, findtext(S, "_")))
		WORD.all		= text2num(copytext(S, findtext(S, "_")+1))
		WORD.language = lang
		WORD.category = ctgr
		if(WORD.word && WORD.success && WORD.all && WORD.language && WORD.category)
			words += WORD

	return words



	//if(copytext(log, i, i+1)!="\n")	text += copytext(log, i, i+1)
	//if(copytext(log, i, i+1)=="\n" || i==lentext(log))
	//if(text && probe(text)>=min_p && probe(text)<=max_p)	LIST += text
	//text = ""

/*




guest1523827786 = object(".0")
	.0
		type = /mob/player
		name = "Arthur"
		key = "guest1523827786"


*/


