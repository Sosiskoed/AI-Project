/datum/planet/proc/Temperature()
	//���������� ����������� ����� ���������� ����� � ���� ����������: ������� �������� � �������
	//��� ����� ������������� �� ������ ������� "���������" �����������(����������� �� ���������� �� ��������)
	//���� � ������� ����� ���������, ���������� ����������� ����� ��������� � �.


	//�� ���� ������ ���� �������� ����� ���� �� �������� ������� � �������� ����������� ����� ��������� ���������, ������� ������ � ��� �����

	var/equator_range = max_Y/2 // ���������� �� ������ �� ��������


	//� ������� ���� ����� ������ ������� ��� ������ � ��������� ���������

	for(var/X=1, X<=max_X, X++)	for(var/Y=1, Y<=max_Y, Y++)
		var/datum/planet_location/PL = map[X][Y]
		//������� ����� ������������ ������������ �� �������� � ����������� �� ������
		var/dif_temp = (middle_temperature*(2-star_orbit_fault))-(middle_temperature*(star_orbit_fault))
		//������� ����������� ��� ������ �������
		var/middle_local_temp = middle_temperature*star_orbit_fault + dif_temp * ((Y<=equator_range) ? Y/equator_range : (2-(Y/equator_range)))



		PL.temperature_year_min = max(0, middle_local_temp - rand(0, round(middle_local_temp*0.05)))
		PL.temperature_year_max = max(0, middle_local_temp + rand(0, round(middle_local_temp*0.05)))

		if(Y>equator_range) //��� ���������������� ���������
			var/temp_t = PL.temperature_year_min
			PL.temperature_year_min = PL.temperature_year_max
			PL.temperature_year_max = temp_t


		Sleeper(1, 2500)