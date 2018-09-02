proc
	//����� ��������
	//����� �������������� ���������


//  ------------����� ������------------

	list_words_from_db(var/category, var/min_p = 0, max_p = 1, neuron, var/lang)//���������� ��->���� �� ��������� �����������
		var/list/LIST = list()

		var/list/datum/AI_knowledge/AI0 = list()

		if(lang)	AI0 += AI_knowledges[languages.Find(lang)]
		else		AI0  = AI_knowledges

		var/list/datum/word_category/AI1 = list()
		for(var/datum/AI_knowledge/ai0 in AI0)
			if(category)	AI1 += ai0.categories[word_categories.Find(category)]
			else			AI1  = ai0.categories

		var/list/datum/word/AI2 = list()
		for(var/datum/word_category/ai1 in AI1)
			AI2 += ai1.words



		for(var/datum/word/ai3 in AI2)
			if(probe(ai3)>=min_p && probe(ai3)<=max_p)
				switch(neuron)
					if(1)	LIST += ai3.word
					if(2)	LIST += probe(ai3)
					else	LIST += ai3
		return LIST





//  ------------����� ���������------------

	word_from_db(var/search, var/category, var/neuron, var/lang)//��������� ������������ ����� �� �� ������ � ���������
		var/list/datum/AI_knowledge/AI0 = list()

		//���� ���� �� ������, �� ������ �� ���� ����������
		if(lang)	AI0 += AI_knowledges[languages.Find(lang)]
		else		AI0  = AI_knowledges

		var/list/datum/word_category/AI1 = list()
		for(var/datum/AI_knowledge/ai0 in AI0)
			if(category)	AI1 += ai0.categories[word_categories.Find(category)]
			else			AI1  = ai0.categories

		var/list/datum/word/AI2 = list()
		for(var/datum/word_category/ai1 in AI1)
			AI2 += ai1.words

		for(var/datum/word/ai2 in AI2)
			if(ai2.word == search)
				switch(neuron)
					if(1)	return ai2.word			//��������� ������
					if(2)	return probe(ai2)		//��� �����������
					else	return ai2				//��� ��� �����
		return 0




	same_word_from_db(var/search, var/diapason=0.2)//������� �������� ������� �� ������ ����� � ���������� TEXT
		var/list/words = list_words_from_db(neuron=1)
		var/list/candidates = list()
		for(var/word in words)
			if(word == search)	return word//���� ����� ����� ����, �� ������� ��� ��
			if(findtext(search, word))//������� ���������� �� ������ ������
				var/maxlen = max(lentext(word),lentext(search))
				var/minlen = min(lentext(word),lentext(search))
				candidates += list(word = min(1, 0.1 + minlen / maxlen))
				words.Remove(word)
				continue
			if(abs(lentext(search)-lentext(word)) > 1)//����� �� ����� �����(�������� ���� ������ �����+��������)
				words.Remove(word)

		for(var/word in words)
			//�������� �����, ��� ���������� ������ ���������� ������ ���� ������ 50%
			var/same = 0
			for(var/i=1, i<lentext(search), i++)
				for(var/iw=1, iw<lentext(word), iw++)
					if("[ascii2text(i)][ascii2text(i+1)]"=="[ascii2text(iw)][ascii2text(iw+1)]")
						same++
			if(same/lentext(search) > 0.5)
				candidates += list(word = same/lentext(search))

		//������ ����� ������������� �� ������������ ����������� � ������� ��������� ����� ���������� � ��������� 0.2

		var/max_same = 0
		for(var/word in candidates)
			if(max_same < candidates[word])
				max_same = candidates[word]

		for(var/word in candidates)
			if(max_same-diapason > candidates[word])
				candidates.Remove(word)

		if(candidates.len)	return pick(candidates)
		else				return 0






	random_word(var/category, var/step=0.1, var/probe=1, var/neuron=1, var/lang="ru")//��������� �������������� ����� �� ����� ��� ��������
		if(src)	lang=src:language
		else	lang=usr.language


		if(!category)	category = pick(word_categories)

		var/datum/word/AI2
		while(!AI2 && probe >= -step)
			probe -= step
			var/list/datum/word/LIST = list_words_from_db(category, probe, neuron=0, lang=lang)
			if(length(LIST))	AI2 = pick(LIST)
		//world << AI2.word
		if(!AI2)	return 0
		switch(neuron)//�������� ����. ��� ����� ������� ����� ���� ��� ��������. ������ ������������� ����������
			if(1)	return AI2.word
			if(2)	return AI2.success
			if(3)	return AI2.all
			if(4)	return AI2.success/AI2.all
			else	return AI2//��� ������� �������� ���������� ��� �������


	word2db(var/word, var/category, var/lang = "ru", var/success=1, var/all=2)
		var/datum/AI_knowledge/AI0 = AI_knowledges[languages.Find(lang)]
		var/datum/word_category/AI1 = AI0.categories[word_categories.Find(category)]

		var/datum/word/WORD = new
		WORD.word = word//�������
		WORD.success = success
		WORD.all = all
		WORD.category = category

		AI1.words += WORD




//  ------------����� �������������� ���������------------

	probe(var/datum/word/AI2)
		return AI2.success/AI2.all


	probe2text(var/p)
		switch(probe(p))
			if(0 to 0.26)		return "�����"
			if(0.26 to 0.51)	return "������� �"
			if(0.51 to 0.76)	return "�"
			else				return "����� �"


	difference(var/signal, var/text)//�������� ������� � ��������� �� ������ ���������� ��� ��
		if(signal == text)	return 0//���� ����� ���������, �� ������� ��� ��
		if(findtext(signal, text))//������� ���������� �� ������ ������
			return 0

		var/same = 0
		for(var/i=1, i<lentext(signal), i++)
			for(var/iw=1, iw<lentext(text), iw++)
				if("[ascii2text(i)][ascii2text(i+1)]"=="[ascii2text(iw)][ascii2text(iw+1)]")
					same++
		if(same/lentext(signal) > 0.6)
			return 0

		if(abs(lentext(signal)-lentext(text)) > 1)//����� �� ����� �����(�������� ���� ������ �����+��������)
			return 1



		return 1







//������� ��� �������� ����� �������� - ���� �������������� ���������� �����



