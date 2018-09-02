/mob/verb/search_path(var/mob/target in world) //������� ������ ����, ������������ �������
	usr.travel_to(target) //�������� ������������ � ����

/mob/proc/travel_to(var/mob/target) //���������, ������� ���������� �� ��� ����������� � ����
	var/list/Way = src.find_path(target) //������ ��������� ������ ����
	for(var/datum/coordinate/C3 in Way) //���� ��� ����������� ���������� ���������� ����� � �������������� ��� ����������
		src.Move(locate(C3.x, C3.y, C3.z)) //����������� �� ��������� �� ���� ����������/����

/mob/proc/find_path(var/mob/target) //��������� ������ ������� ����
	var/list/Best_Way = list() //������ ��������� ������ ������� ����
	var/map = new/list(world.maxx, world.maxy) //����������� �������� ����� (����������� ���������� ��� ������ ���� X � Y)

	for(var/X = 1, X<=world.maxx, X++)	for(var/Y = 1, Y<=world.maxy, Y++)	//���� ��� �������� ���� ������ ����� �� ������������
		map[X][Y] = isopen(locate(X, Y, z)) //������������



	var/datum/coordinate/last_coordinate = new/datum/coordinate(x, y, z) //���������� �������� ���������� +
	Best_Way += last_coordinate //���������� ��������� ����������

	//var/i = 0

	while( !(target in range(1, locate(last_coordinate.x, last_coordinate.y,last_coordinate.z))) ) //���� ��� �� �������� ����� � �������� �����, ����� ���� ����
		//...
		//������ ����� ������� ������ ��������� ������ � ������� �� ����������
		/*i++
		if(i>1000)
			world << "start of end"
			for(var/datum/coordinate/C3 in Best_Way)
				world << "[C3.x]-[C3.y]-[C3.z]"
			return 0
			�������� �� ����������� ���� */


		var/list/nearest_tiles = list() //������ ��������� ������
		var/turf/base_tile = locate(last_coordinate.x, last_coordinate.y, last_coordinate.z) //����� ����� �� ����������� ����� ���� +
		var/list/min_dist //������ ������ ����������� ���� (������?)


		for(var/turf/nearest in orange(1, base_tile)) //��� ��������� ������ �� ���������� 1 �� ����� ���� +
			if(map[nearest.x][nearest.y] == 1) //�������� �� ������������ (���� ����������, �� ������� �� ��������� ���)

				var/is_new_path = 1 //����������, ������������, ��� ���� �����
				for(var/datum/coordinate/C3 in Best_Way) //����, ������� �������� �� ���� ����������� ������ � ������ ����
					if(C3.x == nearest.x && C3.y == nearest.y && C3.z == nearest.z) //�������� �� ��, �������� �� ����������� ������ ���� ���������
						is_new_path = 0 //����� �������������, ��� �� - �� ����� ����
						break //��������� �����

				if(!is_new_path) //���� ���� �����
					continue //�� ����������

				nearest_tiles += list(nearest.x, nearest.y, distance(nearest, target)) //���������� ����������� ��������� � ������ ��������� ������
				if(!min_dist || min_dist[2] > distance(nearest, target)) //�������� ���������� ����� �� ��������� �� ��������� �����
					min_dist = list(new/datum/coordinate(nearest.x, nearest.y, nearest.z), distance(nearest, target)) //����������� ��������� �������������� ������� ����� ��������� ������ � �����

		//��� �� ����� ��������� ���������� �����, ������ �� ������ ������, ����� �� ��� �������� �������� ��� ��������� ���������
		//�������� �������������� � ����������� ��������. �������� ��������� �������� ���������� ���������� �� ����

		if(min_dist) //���� ���� ����������� ���������
			Best_Way += min_dist[1] //��������� � ������� ���� ����������� ��������� �� ����
			last_coordinate = min_dist[1] //���������� ����� ���� �������������� � ����������� ���������
		else
			Best_Way -= Best_Way[Best_Way.len] //� ��������� ������ �� ������� ���� ���������� ��� �����
			map[last_coordinate.x][last_coordinate.y] = 0 //������ ����� ��������������� �� 0
			if(Best_Way.len) //���� ���� ����� ������� ����
				last_coordinate = Best_Way[Best_Way.len] //���������� ����� ���� �������������� � ����� ������� ����

		if(Best_Way == list()) //���� ������ ���� ����
			return 0 //� ������� 0 � ������ ����


	return Best_Way //��� ������������� �������, ������������ ������ ��������� ������� ����

proc/isopen(var/atom/location) //��������� �������� ������ �� �����������
	for(var/atom/O in range(0, location)) //��� ��������� ������
		if(O.density) //���� ��������� �� ����� 0
			return 0 //������� "������������" 0
		if(istype(O, /obj/wall)) //���� �����
			return 0 //������� �� �� �����

	return 1 //������� ������������ 1 ����� �������� ���� ��� ��� ������� ��������

