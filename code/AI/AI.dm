obj/var/ai = 0//ИИ=1,2,3; игрок=-1

mob
	ai
		icon_state = "ai"
		var/send
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
				Say("[random_word()][N]. Я искусственный интеллект. Пожалуйста, используй обращениЯ вроде \"[random_word("my name")], \" или \", [random_word("my name")]\" длЯ общениЯ со мной. И так же не используй более одного предложениЯ. У менЯ с этим пока трудности. Спасибо.")


		//src - всегда ИИ
		//sender - всегда тот, кого услышал
		//usr - иногда игрок, иногда сам ИИ. Не использовать

		Hear(var/text, var/atom/s)
			..()
			spawn(5)//Время реакции
				send = lowertextru(text)
				sender = s
				var/category
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
					Reaction(category, request)
//Добавить функцию принятия раздражения - уменьшить вероятность сообщения, выданного ИИ

		proc//С маленькой буквы - дочерние процессы
			Follow()
				Say("[random_word("yes", 0.3)], босс")
				follow = 1
				while(follow!=0 && !(sender in range(0)))
					sleep(2)
					walk_to(src, sender)

//Название категории подразумевает высоковероятный ответ... Но надо ли?


			Reaction(var/probe_category, var/request)//Обработка универсального ответа на обращение
				//Если можно задавать вопросы, то спросить, приветствие ли это
				//Если нельзя, то просто проверить статистику или взять на веру первое слово

				//Стандартизация сигнала-выражения
				var/signal = cleaning_signal(send)
				var/lang = detected_language_ruen(text)
				//Выбор категории сигнала
				var/list/datum/AI_word/LIST = list()
				for(var/category in AI_categories)//Находим все возможные категории и отфильтровываем по вероятности
					var/datum/AI_word/AI2 = word_from_db(signal, category, 0)
					if(AI2)//Слово найдено. Теперь процесс добавления в лист
						for(var/datum/AI_word/subAI2 in LIST)
							if(probe(AI2)-probe(subAI2)>0.1)
								LIST -= subAI2
								goto ADD
							if(!LIST.len) goto ADD
							goto jump; ADD; LIST += AI2; jump //Чтобы избавиться от длинного ифа




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
					probe_category = input(sender, msg, "Category", "hello") in AI_categories+"CANCEL"
					if(probe_category == "CANCEL")	goto End
					jumpy
					word2db(signal, probe_category, lang)
					LIST += word_from_db(signal, probe_category, 0)

				var/datum/AI_word/word = pick(LIST)

				//Отдельно ответ, отдельно обучение
				//Создать категорию сигнала заминки

				//Реакция-ответ на сигнал
				switch(word.category)
					if("hello")
						Hello()
					if("yes", "no")
						if(waiting_answer == 1)
							waiting_answer = 0
							if(word.category == "no")	Learn_Answer(last_things[2], 0)
							else 						Learn_Answer(last_things[2], 1)
							goto End
						//else nonunderstand_reaction()
					if("follow me")
						Follow()
					if("goodbye")
						Goodbye()


				//Цикл для обучения
				if(lq && !waiting_answer && !new_word)	for(var/datum/AI_word/AI2 in LIST)//Сравнение полученного приветствия с памятью
					if(difference(signal, AI2.word)==0)
						Say("[probe2text(probe(AI2))]ероЯтно, что выражение \"[signal]\" принадлежит к категории [word.category]. Оно сейчас им ЯвлЯетсЯ?")
						waiting_answer = 1
						last_things.Cut()
						last_things += signal
						last_things += word.category
						break
				End

			Hello()
				Say("[random_word()], [sender.name]")

			Goodbye()
				Say("[random_word("goodbye")], [sender.name]")
				if(sender in friends)	friends -= sender

			Learn_Answer(var/category, var/answer = 1)
				//Взять текст из файла. Найти место изменения. Изменить. Удалить файл. Создать новый с этим текстом
				var/datum/AI_word/word = word_from_db(last_things[1], category, 0)
				word.success += answer
				word.all += 1
				Say("Ответ принЯт и вероЯтность изменена до [probe(word)]. Благодарю.")
				//Нужно сделать ссылку на правильный выбор категории
				//Поиск наиболее вероятных категорий и выдать их по порядку на выбор, пока юзер не согласится?
