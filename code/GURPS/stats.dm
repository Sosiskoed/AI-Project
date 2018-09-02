/datum/gurps/dice
	var/count = 1
	var/mod = 0
	New(var/Count = 1, var/Mod, var/dice)
		..()
		count = Count
		mod = Mod


//����� �������� ������� ���� ����������. �������


//� ������� ���������(��� ������� ����������) ����� �����������, ������� ����� �������������� ��� ������ ��������� ������� ���������
//������ �������� ���������� ���� ������� ��� ������� ������������� ��������, �� ����������� ���������� �����������(�� ������������)
//������ ������� ����� ����� ��� ���������: ��������� ���� � ��������� �����������



/datums/gurps/stats	//��� ������ ����� ����������� ������ �� ���� ��������� �����, � �� �������������� ����, �� ������ ����� ����

	points
		var/base = 25 //����������� �� ��������� �������
		var/permanent_mod = 0 //�������, ����������� �� ����� � �����
		var/exp = 0 //�� ���� � ��������, �� ���������
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

		ST		//������ �� ������� ��� � ����������� ���������(����� ����������� ����)
			var/result = 10
		DX
		IQ
		HT//����������� �������� ��� ������� ������ HT/10

	proc/process()
		return//��� ����� �������� ����� �������� ��� ���������� ������

/datums/gurps/stats/secondary_attributes
	damage//��� ������ ��������� ���, ��� ������� �� ������ � ���� ��
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



	BL//���� �� ��� �� ����������, ����� �� ���� ������ ���������� ������
		var/LL_simple_none		//����� ���������� �����, ������� (ST+round(pts/3))*(ST+round(pts/3))/5
		var/LL_one_handed_light //�� 2 ������� � ������ ���
		var/lift_two_handed 	//�� 8 ������
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

			lift_shove_and_knock	 = round(base_ST*12)//������ ��� ��������
			lift_run_shove_and_knock = round(base_ST*24)//������ ��� �������� � �������
			lift_carry_back			 = round(base_ST*15)
			lift_shift_slightly		 = round(base_ST*50)

			load_medium	 = round(base_ST*3)
			load_heavy 	 = round(base_ST*6)
			load_heavy_x = round(base_ST*10)


	HP	//�� ����� ���������� �������� +-30% �� ST ��� �������������� �����������
		var/result
		var/pts = 0
		var/mod = 0
		var/cost = 2

		process(var/new_pts = 0, var/new_mod = 0, var/ST, var/SM)
			pts += new_pts
			mod += new_mod
			result = ST + mod + (pts/2) + (pts/20) * min(8, max(0, SM))

/*	������ ����� ������� �������� ��������� �������� �� ���� ���� ����� ��/3, ��� ��/2 ��� ���� ��� ����.
��� �������� �������� �� ������ ����������� �����������, ���������� � ������ ���� ���������, � � ������ ����������
������������� �����������, ��� ����� ���� ������� �� �����. ������ ��� ����������� ���������� �������!
�������� ������ � �������� ����������� ����� ���� �� ����������� ���������

   ��������� ����
����� ��������� ���, ��� �������� ������� ����� ����� �������� ��� ���� ���� ������ �� 1 ��, ���������� � �����.
��������� ������� ��� ��������������. ���� �������, ������ ������������ �������������� �������: ����� � ��� ��������
����� 1/3 ��, �� ������ ��������� ������������ ����, ���������� ������������, �� ����������� ��������� �������:
(�) ����������� ����; (�) ���������� ����������� ����������, ����� ���������� ����� ����;
��� (�) ��������� �� ���� ���� ����������� ��������� 1/3 ����� ��.*/


	FP	//�� ����� ���������� �������� +-30% �� HT ��� �������������� �����������
	ER  //Energy Reserve. Based on IQ. Only for magic. ER = IQ + pts/1

	Perception
		Hearing
		Vision
		Smell
		Touch

	Will
		Fear

	Speed	//�� ������ +- �� ������� ��� ����
		BaseMove
			//��� ���������� �������� � ������ G ����� ��������� load � ��� ��� �������
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


	weight//�����, ������, �������, ����� �������
		var/pattern[3]

	SM//������, ������, ���������� 0
		var/height
		var/pattern[3]//��������, ����, �������
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
	status//titul, ����������
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