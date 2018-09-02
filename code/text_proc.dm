var/list/ru_alphabet_low    = list(//224-255
224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255
)
var/list/ru_alphabet_high   = list(//192-223
192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223
)
var/list/ru_alphabet_extra  = list(
128,129,131,138,140,141,142,143,153,,154,156,157,161,162,165,168,170,182,184,186
)


var/list/eng_alphabet_low   = list(//97-122
97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122
)
var/list/eng_alphabet_high  = list(//65-90
65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90
)
var/list/eng_alphabet_extra = list(
144,158,159,163,167,175,178,179,180,181,185,188,189,190,191
)


var/list/digits				= list(//48-57
48,49,50,51,52,53,54,55,56,57
)


/mob/verb/rhtml_decode(msg as text)
	msg = replacetext(msg, "<", "&lt;")
	msg = replacetext(msg, ">", "&gt;")
	msg = replacetext(msg, "�", "&#255;")
	world << msg
	usr << browse(msg, "window=test_text;size=300x300")


var/sleeper_timer = 0
proc
	Sleeper(var/time_of_sleep = 1, var/frequency=2500)
		if(sleeper_timer%frequency == 0) //�����������
			sleep(time_of_sleep)
		sleeper_timer++



	ExText(var/text)//������� ��������� �����
		var/t = text2ascii(copytext(text, 1, 2))
		if(t in ru_alphabet_low+eng_alphabet_low)
			t -= 32
		return ascii2text(t)+copytext(text, 2)

	LowerText(var/T)//������������� ����������� lowertext
		T = lowertext(T)
		var/text
		for(var/i=1, i<=lentext(T), i++)
			var/t = text2ascii(copytext(T, i, i+1))
			if(t in ru_alphabet_high)
				t += 32
			text += ascii2text(t)
		return text

	detect_language(var/text)//��� ����������� �����������-��������. ��� ��������� ������� �������� ����
		var/ru  = 0
		var/eng = 0

		for(var/i=1, i<=lentext(text), i++)
			if(text2ascii(copytext(text, i, i+1)) in ru_alphabet_low+ru_alphabet_high+ru_alphabet_extra)
				ru++
			if(text2ascii(copytext(text, i, i+1)) in eng_alphabet_low+eng_alphabet_high+eng_alphabet_extra)
				eng++

		if(ru  == max(ru, eng))		return "ru"
		if(eng == max(ru, eng))		return "en"

	total_sanitize(var/text)//������ ����� � �������
		for(var/i, i<=lentext(text), i++)
			while(copytext(text, 1, 2)==" ")
				text = copytext(text, 2)

			var/k=text2ascii(copytext(text, i, i+1))
			if(copytext(text, i, i+2)=="  " || (copytext(text, i, i+1)!=" " && k<65 && k>90 && k<97 && k>122))
				text = copytext(text, 1, i)+copytext(text, i+2)
			return text

	distance(var/A, var/B, var/x2, var/y2)	//����� ���� ������ � ���������� ����
		if(istype(A, /atom) && istype(B, /atom))
			return sqrt( (A:x-B:x)*(A:x-B:x) + (A:y-B:y)*(A:y-B:y) )
		else
			return sqrt( (A-x2)*(A-x2) + (A-y2)*(A-y2) )

	math_distance(var/x1, var/x2, var/y1, var/y2)
		return sqrt( (x1-x2)*(x1-x2) + (y1-y2)*(y1-y2) )

	is_dalphabet_symbol(var/char)
		var/cnum
		if(isnum(char))		cnum = char
		else				cnum = text2ascii(char)

		if(cnum in (ru_alphabet_low+ru_alphabet_high+ru_alphabet_extra + eng_alphabet_low+eng_alphabet_high+eng_alphabet_extra+digits) )
			return 1
		else
			return 0
