obj/var/ai = 0//��=1,2,3; �����=-1

mob/ai
	icon_state = "ai"
	var/atom/sender
	var/follow = 0
	var/lq = 1//������� ��� ������� ��������
	var/list/viewing = list()
	var/list/friends = list()
	var/waiting_answer = 0
	var/list/last_things = list()
	var/last_log = list()


	New()
		sleep(3)
		for(var/mob/M in view())
			if(M!=usr)	View_Move(M)

	View_Move(var/atom/movable/A)//����� �������� �� �������������� ����������� �� ���
		..()
		if(!(A in viewing))
			viewing += A
			var/N = ", [A.name]"
			if(!A || !A.name)	N = ""
			Say("[random_word("hello")][N]. � ������������� ���������. ����������, ��������� ��������� ����� \"[random_word("my name")], \" ��� \", [random_word("my name")]\" ��� ������� �� ����. � ��� �� �� ��������� ����� ������ �����������. � ���� � ���� ���� ���������. �������.")


		//src - ������ ��
		//sender - ������ ���, ���� �������
		//usr - ������ �����, ������ ��� ��. �� ������������



















	Hear(var/text, sender)//1. ��������� ����������
		..()
		spawn(5)//����� �������

			//2. ��������� ����������

			text = LowerText(text) //�) ���������� � ������ �������


			var/input_log = ""//���, �� �� ��� ��������. ����������� ���������� 100 ����������+����������� ������ ����� ����� ������ 16-������ �����(��� ����� 38-������?)
			var/list/temp_list_logs = list()
			var/list/question_words = splittext(total_sanitize(text), " ")//������� ����� ��������� ��� �� �����
			var/list/input_neurons = list()


			for(var/word in question_words)//-1 [ ... ]
				//������� �� ���� ������ ������
				word = lowertext(word)
				Start
				for(var/l=1, l<=lentext(word), l++)
					if(!is_dalphabet_symbol(copytext(word, l, l+1)))
						word = copytext(word, 1, l)+copytext(word, l+1, 0)
						goto Start



				//������ ����� �������� �������� � ����� ������ � �������� ���� �����
				var/datum/word/AI2 = word_from_db(same_word_from_db(word))//����� ����� ������ �����, ���� �� �������� ���
				if(AI2)	input_neurons += AI2//����������� ��� ���� ����
				var/pattern_log = {"U1:Enter|U2:AddFriend(U1)|U1:"������"|U2:"������""}//��� ������, ����� ����� �����������
				//� ������ ��� ����� ���������� ��� � �������� ���������� � ������� ������ �������� ��������

				//����� ������ ����. ����� ����� ������ ����������� ����
				//������ ���� ��� ������� ����� �� ����������� ��� ����
				//�� ���� �� ������ ������ ����� ��� ����� ��������� �������� ������� � �������
				//���� ����� �� �����, ��... ���� �� ����



				//	for(var/list/action_log in AI2.action_logs)
				//		if(difference(action_log[1], input_log) < 0.5)
				//			temp_list_logs += action_log


					//� ��� ������? ��� ��� ������ � ����� ���������� ������?
			//� ������ ��... ���������� ���� ���������� ������ �����
			for(var/list/temp_log in temp_list_logs)
				for(var/list/dif_log in temp_list_logs-temp_log)
					if(difference(temp_log[1], dif_log[1]) < 0.1)
						temp_log[2] = min(1, temp_log[2] + (temp_log[2]+dif_log[2])/10)
						temp_list_logs.Remove(dif_log)

			for(var/list/temp_log in temp_list_logs)
				if(difference(temp_log[1], input_log)>0.1 || temp_log[2]<0.8)
					temp_list_logs.Remove(temp_log)

			//var/list/sort_log = pick(temp_list_logs)//��� ��� �� �����?
			//� ��� �� ���������� �� ���������� ����?
			//����������� �������. �� ������ �� �����



			//�������� ������� ����������, ��������� ������ ����������� �� 10% �� �� �����
			//����������� ������ ������ � ���� ���� ��� ����, ����������� �������� ������ 0.7 � ������ ����������
			//�����������(��� ���������) ��� ���� ���� ����������� ��� ��������� � ���������������� ���� �� +1 success





			Reaction()

















			/*var/category
			if(sender!=src && !(sender in friends))
				friends += sender
				category = "hello"
			//world << "usr=\icon[usr][usr] + src=\icon[src][src] + sender=\icon[sender][sender]"
			var/list/movable_visibles = list()
			for(var/atom/movable/V in view(sender))
				if(ismob(V) || (isobj(V)&&V:ai))	movable_visibles += V//����� �������� ������� ������� �� ��� ��������


			var/request//����� ��������� � ������� �� ����
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
			//�������� ������� ���������� ������ ��������� ��� ����������� ���������
			else if(request || (movable_visibles.len==2 && sender!=src))
				Reaction(category, request)*/
//�������� ������� �������� ����������� - ��������� ����������� ���������, ��������� ��




//�������� ��������� ������������� ��������������� �����... �� ���� ��?
	proc/Reaction(var/probe_category, var/request, var/signal)//��������� �������������� ������ �� ���������
		//���� ����� �������� �������, �� ��������, ����������� �� ���
		//���� ������, �� ������ ��������� ���������� ��� ����� �� ���� ������ �����

		//�������������� �������-���������
		signal = total_sanitize(signal)
		var/lang = detect_language(text)
		//����� ��������� �������
		var/list/datum/word/LIST = list()
		for(var/category in word_categories)//������� ��� ��������� ��������� � ��������������� �� �����������
			var/datum/word/AI2 = word_from_db(signal, category, 0)
			if(AI2)//����� �������. ������ ������� ���������� � ����
				for(var/datum/word/subAI2 in LIST)
					if(probe(AI2)-probe(subAI2)>0.1)
						LIST -= subAI2
						LIST += AI2;
					if(!LIST.len) LIST += AI2;




		//��������� ��������� - �����������
		if(!LIST.len && probe_category)
			word2db(signal, probe_category, lang)
			LIST += word_from_db(signal, probe_category, 0)

		//���� �������� ������ ����� ����� ������ ������
		var/new_word = 0
		if(!LIST.len)
			new_word = 1

			var/msg = "������� ��������� ��� � ���� ������. "
			if(waiting_answer==1)
				probe_category = alert(sender,
				"[msg]����� ��������, ��� ��� ����������� � ����� �� ������ ���������. �����������, ����������.",
				"Category","yes", "no", "��� �� �� ������ ���������")
				if(probe_category!="��� �� �� ������ ���������")	goto jumpy

			msg += "����������, �������� ��������� ������� ��������� ��� ������ � ���� ��������."
			probe_category = input(sender, msg, "Category", "hello") in word_categories+"CANCEL"
			if(probe_category == "CANCEL")	goto End
			jumpy
			word2db(signal, probe_category, lang)
			LIST += word_from_db(signal, probe_category, 0)

		var/datum/word/word = pick(LIST)

		var/PB = word.category ? word.category : probe_category

		//�������� �����, �������� ��������
		//������� ��������� ������� �������

		//�������-����� �� ������
		Answer()



		//���� ��� ��������
		if(lq && !waiting_answer && !new_word)
			for(var/datum/word/AI2 in LIST)//��������� ����������� ����������� � �������
				if(!difference(signal, AI2.word))
					Say("[probe2text(AI2)]�������, ��� ��������� \"[signal]\" ����������� � ��������� [PB]. ��� ������ �� ��������?")
					waiting_answer = 1
					last_things = list()
					last_things += signal
					last_things += PB
					break
		End






/*
����� �������� �������� ��� ��������� � ���� ������
���� ����, �� ���������*/