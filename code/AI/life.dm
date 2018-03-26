obj/var/ai = 0//ИИ=1,2,3; игрок=-1

mob/ai
	icon_state = "ai"
	var/atom/sender
	var/follow = 0
	var/lq = 1//Триггер для функции обучения
	var/list/viewing = list()
	var/list/friends = list()
	var/waiting_answer = 0
	var/list/last_things = list()


	New()
		sleep(3)
		for(var/mob/M in view())
			if(M!=usr)	View_Move(M)

	View_Move(var/atom/movable/A)//Потом улучшить до множественного приветствия за раз
		..()
		if(!(A in viewing))
			viewing += A
			var/N = ", [A.name]"
			if(!A || !A.name)	N = ""
			Say("[random_word("hello")][N]. Я искусственный интеллект. Пожалуйста, используй обращениЯ вроде \"[random_word("my name")], \" или \", [random_word("my name")]\" длЯ общениЯ со мной. И так же не используй более одного предложениЯ. У менЯ с этим пока трудности. Спасибо.")


		//src - всегда ИИ
		//sender - всегда тот, кого услышал
		//usr - иногда игрок, иногда сам ИИ. Не использовать



















	Hear(var/text, sender)//1. Получение информации
		..()
		spawn(5)//Время реакции

			//2. Обработка информации

			text = LowerText(text) //А) Приведение в нижний регистр


			var/input_log = ""//Лог, он же тип ситуации. Ограничимся последними 100 действиями+обозначение других логов каким нибудь 16-ричным кодом(Или лучше 38-ричным?)
			var/list/temp_list_logs = list()
			var/list/question_words = splittext(total_sanitize(text), " ")//Сначала нужно разделить все на слова



			for(var/word in question_words)//-1 [ ... ]
				//Дальше нужно провести аналогию с базой данных и вставить сюда датум
				var/datum/word/AI2 = word_from_db(same_word_from_db(word))//Нужно найти схожее слово, если не найдется это
				if(AI2)
					neuron_question_words += AI2
					//Дальше цикл для каждого слова по определению его типа
					//То есть из общего списка логов для слова извлекаем наиболее похожие с текущим
					//Если таких не будет, то... Пока не знаю

				//	for(var/list/action_log in AI2.action_logs)
				//		if(difference(action_log[1], input_log) < 0.5)
				//			temp_list_logs += action_log


					//И что дальше? Что мне делать с этими временными логами?
			//А дальше мы... Сравниваем весь полученный список логов
			for(var/list/temp_log in temp_list_logs)
				for(var/list/dif_log in temp_list_logs-temp_log)
					if(difference(temp_log[1], dif_log[1]) < 0.1)
						temp_log[2] = min(1, temp_log[2] + (temp_log[2]+dif_log[2])/10)
						temp_list_logs.Remove(dif_log)

			for(var/list/temp_log in temp_list_logs)
				if(difference(temp_log[1], input_log)>0.1 || temp_log[2]<0.8)
					temp_list_logs.Remove(temp_log)

			//var/list/sort_log = pick(temp_list_logs)//Что это за ересь?
			//А как же вычисление по количеству букв?
			//ОБЯЗАТЕЛЬНО ГЛЯНУТЬ. НЕ РЕШЕНО ДО КОНЦА



			//Наиболее похожие складываем, прибавляя данную вероятность на 10% от их суммы
			//Увеличиваем статус успеха у всех слов для лога, вероятность которого больше 0.7 в данном вычислении
			//Увеличиваем(Или добавляем) для всех слов вероятность для входящего и отсортированного лога на +1 success





			Reaction()

















			/*var/category
			if(sender!=src && !(sender in friends))
				friends += sender
				category = "hello"
			//world << "usr=\icon[usr][usr] + src=\icon[src][src] + sender=\icon[sender][sender]"
			var/list/movable_visibles = list()
			for(var/atom/movable/V in view(sender))
				if(ismob(V) || (isobj(V)&&V:ai))	movable_visibles += V//Потом добавить триггер наличия ИИ для обьектов


			var/request//поиск обращения и очистка от него
			for(var/ainame in list_words("my name", 0.3))
				if(findtext(send, "[ainame],", 1, lentext(ainame)+2))
					request = ainame
					send = copytext(send, lentext(ainame)+2)
					world << send
				else if(findtext(send, ", [ainame]", -lentext(ainame)-2))
					request = ainame
					send = copytext(send, 1, -lentext(ainame)-2)
			//world << "usr=[usr] + src=[src] + sender=[sender] + request=\"[request]\""


			if(findtext(send, "start learning"))
				Say(random_word("understand", 0.3))
				lq = 1
			else if(findtext(send, "stop learning"))
				Say(random_word("understand", 0.3))
				lq = 0
			//Добавить функцию восприятия старых сообщений для запоминания обращений
			else if(request || (movable_visibles.len==2 && sender!=src))
				Reaction(category, request)*/
//Добавить функцию принятия раздражения - уменьшить вероятность сообщения, выданного ИИ




//Название категории подразумевает высоковероятный ответ... Но надо ли?
	proc/Reaction(var/probe_category, var/request, var/signal)//Обработка универсального ответа на обращение
		//Если можно задавать вопросы, то спросить, приветствие ли это
		//Если нельзя, то просто проверить статистику или взять на веру первое слово

		//Стандартизация сигнала-выражения
		signal = total_sanitize(signal)
		var/lang = detect_language(text)
		//Выбор категории сигнала
		var/list/datum/word/LIST = list()
		for(var/category in word_categories)//Находим все возможные категории и отфильтровываем по вероятности
			var/datum/word/AI2 = word_from_db(signal, category, 0)
			if(AI2)//Слово найдено. Теперь процесс добавления в лист
				for(var/datum/word/subAI2 in LIST)
					if(probe(AI2)-probe(subAI2)>0.1)
						LIST -= subAI2
						LIST += AI2;
					if(!LIST.len) LIST += AI2;




		//Наводящее обращение - приветствие
		if(!LIST.len && probe_category)
			word2db(signal, probe_category, lang)
			LIST += word_from_db(signal, probe_category, 0)

		//Блок обучения новому слову через прямой вопрос
		var/new_word = 0
		if(!LIST.len)
			new_word = 1

			var/msg = "Данного выражениЯ нет в моей памЯти. "
			if(waiting_answer==1)
				probe_category = alert(sender,
				"[msg]Очень вероЯтно, что оно принадлежит к одной из данных категорий. Подтвердите, пожалуйста.",
				"Category","yes", "no", "Это не из данных категорий")
				if(probe_category!="Это не из данных категорий")	goto jumpy

			msg += "Пожалуйста, выберите категорию данного выражениЯ длЯ помощи в моем обучении."
			probe_category = input(sender, msg, "Category", "hello") in word_categories+"CANCEL"
			if(probe_category == "CANCEL")	goto End
			jumpy
			word2db(signal, probe_category, lang)
			LIST += word_from_db(signal, probe_category, 0)

		var/datum/word/word = pick(LIST)

		var/PB = word.category ? word.category : probe_category

		//Отдельно ответ, отдельно обучение
		//Создать категорию сигнала заминки

		//Реакция-ответ на сигнал
		Answer()



		//Цикл для обучения
		if(lq && !waiting_answer && !new_word)
			for(var/datum/word/AI2 in LIST)//Сравнение полученного приветствия с памятью
				if(!difference(signal, AI2.word))
					Say("[probe2text(AI2)]ероЯтно, что выражение \"[signal]\" принадлежит к категории [PB]. Оно сейчас им ЯвлЯетсЯ?")
					waiting_answer = 1
					last_things = list()
					last_things += signal
					last_things += PB
					break
		End






/*
Нужен комплекс процедур для обращения к базе данных
База есть, но сумбурная*/