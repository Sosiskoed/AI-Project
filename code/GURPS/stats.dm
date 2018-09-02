/datum/gurps/dice
	var/count = 1
	var/mod = 0
	New(var/Count = 1, var/Mod, var/dice)
		..()
		count = Count
		mod = Mod


//Можно закодить базовые сеты персонажей. Шаблоны


//У каждого параметра(Или раздела параметров) будут зависимости, которые будут обрабатываться при каждом изменении данного параметра
//Каждый параметр обозначает лишь границы без влияния внутриигровых факторов, за исключением постоянных модификаций(Не инвалидности)
//Каждый атрибут может иметь два параметра: Вложенные очки и отдельная модификация



/datums/gurps/stats	//Все навыки будут вычисляться строго за счет вложенных очков, а не фимксированной базы, на случай смены тела

	points
		var/base = 25 //Зависимость от стартовой локации
		var/permanent_mod = 0 //Награда, переносимая из жизни в жизнь
		var/exp = 0 //За опыт и например, за биографию
		var/result = 25

		process(var/new_exp = 0, var/new_permanent = 0, var/TL, var/city_people)
			if(TL && city_people)
				base = 75 - min( 50, max(0, (10*TL)+round(city_people/10)) )

			permanent_mod += new_permanent
			exp += new_exp
			result = base + exp + permanent_mod



	atributes
		//var/result = 10
		var/cost = 10
		var/mod = 0
		var/base = 10
		var/pts

		ST		//Влияет на внешний вид и особенности поведения(Вроде примитивной речи)
			var/result = 10
		DX
		IQ
		HT//Модификатор здоровья для органов равный HT/10

	proc/process()
		return//Тут нужно написать общий алгоритм для вычисления статов

/datums/gurps/stats/secondary_attributes
	damage//Под раздел заносится все, что зависит от одного и того же
		var/datum/gurps/dice/thrust
		var/datum/gurps/dice/swing

		process(var/ST)
			var/swing1;		var/swing2 = 0
			var/thrust1;	var/thrust2 = 0

			switch(ST)
				if(0)
					thrust1 = 0
				if(1 to 18)
					thrust1 = 1
				if(19 to 26)
					thrust1 = 2
				if(27 to 34)
					thrust1 = 3
				if(35 to 44)
					thrust1 = 4
				if(45 to 54)
					thrust1 = 5
				if(55 to 59)
					thrust1 = 6
				else
					thrust1 = max(0, round(ST/10)+1)


			switch(ST)
				if(1 to 2)
					thrust2 = -6; swing2 = -5
				if(3 to 4)
					thrust2 = -5; swing2 = -4
				if(5 to 6)
					thrust2 = -4; swing2 = -3
				if(7 to 8)
					thrust2 = -3; swing2 = -2
				if(9 to 18)			thrust2 = round((ST-7)/2)  - 3
				if(19 to 26)		thrust2 = round((ST-17)/2) - 2
				if(27 to 34)		thrust2 = round((ST-25)/2) - 2
				if(35 to 38)
					thrust2 = round((ST-33)/2) - 2;		swing2 = round((ST-33)/2)
				if(39 to 44, 65 to 69)
					thrust2 = 1;	swing2 = -1
				if(45 to 49, 55 to 59)
					thrust2 = 0;	swing2 = 1
				if(50 to 54)
					thrust2 = 2;	swing2 = -1
				if(60 to 64)
					thrust2 = -1;	swing2 = 0
				else
					if(ST-round(ST/10)>=5 && ST-round(ST/10)<=9)
						thrust2 = 2
						swing2 = 2
					else
						thrust2 = 0
						swing2 = 0

			switch(ST)
				if(9 to 12)		swing2 = ST-10
				if(13 to 16)	swing2 = ST-14
				if(17 to 20)	swing2 = ST-18
				if(21 to 24)	swing2 = ST-22
				if(25 to 26)	swing2 = ST-26
				if(27 to 30)	swing2 = round((ST-25)/2)
				if(31 to 34)	swing2 = round((ST-33)/2)

			switch(ST)
				if(0)			swing1 = 0
				if(1 to 12)		swing1 = 1
				if(13 to 16)	swing1 = 2
				if(17 to 20)	swing1 = 3
				if(21 to 24)	swing1 = 4
				if(25 to 30)	swing1 = 5
				if(31 to 38)	swing1 = 6
				if(39 to 59)	swing1 = 7
				else			swing1 = max(0, round(ST/10)+3)

			thrust = new/datum/gurps/dice(thrust1, thrust2)
			swing  = new/datum/gurps/dice(swing1, swing2)



	BL//Надо бы как то обьединить, чтобы не было лишних вычислений формул
		var/LL_simple_none		//Время поднимания груза, равного (ST+round(pts/3))*(ST+round(pts/3))/5
		var/LL_one_handed_light //За 2 секунды и легкий вес
		var/lift_two_handed 	//За 8 секунд
		var/lift_shove_and_knock
		var/lift_run_shove_and_knock
		var/lift_carry_back
		var/lift_shift_slightly

		var/load_medium
		var/load_heavy
		var/load_heavy_x

		process(var/ST, var/ExtraBL)
			var/base_ST = ExtraBL + (ST*ST)/5

			LL_simple_none			 = round(base_ST)
			LL_one_handed_light		 = round(base_ST*2)
			lift_two_handed			 = round(base_ST*8)

			lift_shove_and_knock	 = round(base_ST*12)//Толчок или таскание
			lift_run_shove_and_knock = round(base_ST*24)//Толчок или таскание с разбега
			lift_carry_back			 = round(base_ST*15)
			lift_shift_slightly		 = round(base_ST*50)

			load_medium	 = round(base_ST*3)
			load_heavy 	 = round(base_ST*6)
			load_heavy_x = round(base_ST*10)


	HP	//ЕЖ может колебаться максимум +-30% от ST без неестественных модификаций
		var/result
		var/pts = 0
		var/mod = 0
		var/cost = 2

		process(var/new_pts = 0, var/new_mod = 0, var/ST, var/SM)
			pts += new_pts
			mod += new_mod
			result = ST + mod + (pts/2) + (pts/20) * min(8, max(0, SM))

/*	Обычно чтобы сломать придаток требуется потерять за один удар свыше ЕЖ/3, или ЕЖ/2 для руки или ноги.
Для большего реализма вы можете отслеживать повреждения, полученные в каждую зону поражения, и в случае накопления
вышеуказанных повреждений, эта часть тела выходит из строя. Однако это увеличивает количество записей!
Неплохой способ – помечать повреждения части тела на изображении персонажа

   Последняя рана
Может случиться так, что серьёзно раненый герой будет вырублен или даже убит ударом на 1 ЕЖ, полученным в стопу.
Некоторые находят это нереалистичным. Если желаете, можете использовать необязательное правило: когда у вас остается
менее 1/3 ЕЖ, вы можете полностью игнорировать раны, полученные конечностями, за исключением следующих случаев:
(а) критический удар; (б) полученных повреждений достаточно, чтобы покалечить часть тела;
или (с) нанесённое за один удар повреждение превышает 1/3 ваших ЕЖ.*/


	FP	//ЕУ может колебаться максимум +-30% от HT без неестественных модификаций
	ER  //Energy Reserve. Based on IQ. Only for magic. ER = IQ + pts/1

	Perception
		Hearing
		Vision
		Smell
		Touch

	Will
		Fear

	Speed	//Не больше +- от базовой для расы
		BaseMove
			//Для вычисления скорости в разных G нужно вычислить load и уже его влияние
			var/none
			var/light
			var/medium
			var/heavy
			var/heavy_x

			var/air = 0;		var/air_mod = 0
			var/ground = 1;		var/ground_mod = 0
			var/water = 0.2;	var/water_mod = 0
		Dodge
			var/none
			var/light
			var/medium
			var/heavy
			var/heavy_x

	MainHand



/datums/gurps/stats/constitution
	var/manipulators
	var/race


	weight//Худой, полный, толстый, очень толстый
		var/pattern[3]

	SM//Карлик, гигант, изначально 0
		var/height
		var/pattern[3]//Название, цена, влияние
		var/result = 0

	age
		var/current
		var/max
		var/old[3]
		var/adult
		var/child[3]

	appearance


/datums/gurps/stats/social
	var/biography

	TL
	Culture
	Language
	wealth
	reputation
	status//titul, привилегии
	rank
	privilege
	constraints
	friends
	enemies
	names

/datums/gurps/stats/advantages

/datums/gurps/stats/disadvantages

/datums/gurps/stats/skills

/datums/gurps/stats/magic

/datums/gurps/stats/psi