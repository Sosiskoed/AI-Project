/*


����, ���� ������ map
������ ����� ���������� �������


*/
datum/point
	var/base[2]
	var/connect1[2]
	var/connect2[2]



/datum/space_station
	var/Map[][]
	var/size = 12


	proc/Generate(var/X=1, var/Y=1)
		size = (X+size>world.maxx) ? world.maxx-X : size
		size = (Y+size>world.maxy) ? world.maxy-Y : size

		var/map[size][size]
		var/current_x//������������ ������ ����� �������
		var/current_y
		for(var/x=1, x<=size, x++)	for(var/y=1, y<=size, y++)
			map[x][y] = prob(40) //������� ������� ������� ���������� ����� ��� ����������� ������
			if(map[x][y] && !current_x && !current_y)
				current_x = x
				current_y = y




		for() //����� ��� ���� � �����: ����� �� � � �� � �����
			var/founded
			for(var/i=y+1, y<=size, y++) //������� ���� ������ ����� ������
				if(map[x][i])
					if(istype(map[x][i], datum/point))
						if(istype(map[x][y], datum/point))
							var/datum/point/P1 = map[x][y]
							P1.connect2[1] = x
							P1.connect2[2] = i
						else

							var/datum/point/P2 = map[x][i]
							P2.connect2[1] = x
							P2.connect2[2] = y

					else
						if(istype(map[x][y], datum/point)) //���� ����� ��� ��������� � ��� ����, ��� ���������� ������ �����������
							var/datum/point/P1 = map[x][y]
							P1.connect2[1] = x
							P1.connect2[2] = i
						else //����� ������� � � ����
							var/datum/point/P1 = new
							P1.base[1] = x
							P1.base[2] = y
							P1.connect1[1] = x
							P1.connect1[2] = i
							map[x][y] = P1


						var/datum/point/P2 = new
						P2.base[1] = x
						P2.base[2] = i
						P2.connect1[1] = x
						P2.connect1[2] = y
						map[x][i] = P2


					current_y = i
					founded = 1
					break



			for(var/i=x+1, y<=size, y++) //������ ������
				if(map[x][i])
					if(istype(map[x][i], datum/point))
						if(istype(map[x][y], datum/point))
							var/datum/point/P1 = map[x][y]
							P1.connect2[1] = x
								P1.connect2[2] = i
						else
							var/datum/point/P2 = map[x][i]
						P2.connect2[1] = x
						P2.connect2[2] = y

					else
						if(istype(map[x][y], datum/point)) //���� ����� ��� ��������� � ��� ����, ��� ���������� ������ �����������
							var/datum/point/P1 = map[x][y]
							P1.connect2[1] = x
							P1.connect2[2] = i
						else //����� ������� � � ����
							var/datum/point/P1 = new
							P1.base[1] = x
							P1.base[2] = y
							P1.connect1[1] = x
							P1.connect1[2] = i
							map[x][y] = P1


						var/datum/point/P2 = new
						P2.base[1] = x
						P2.base[2] = i
						P2.connect1[1] = x
						P2.connect1[2] = y
						map[x][i] = P2

					break
