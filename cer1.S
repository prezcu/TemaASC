.data
	n: .long 0
	m: .long 0
	m_matrix: .long 0
	n_matrix: .long 0
	p: .long 0
	k: .long 0
	aux: .long 0
	count: .long 0
	col_vecini: .long 0
	lin_vecini: .long 0
	index: .long 0
	linie: .long 0
	coloana: .long 0
	matrix: .fill 400, 4, 0
	vecini: .fill 400, 4, 0
	formatString: .asciz "%d"
	textAfisat: .asciz "Variabila n este: %d \n"
	newLine: .asciz "\n"
	afisElem: .asciz "%d "
	afisEvolutie: .asciz "Evolutia nr %d:\n"

.text

.global main
main:
	pushl $m
	pushl $formatString
	call scanf
	popl %ebx
	popl %ebx

	addl $2, m #matrice extinsa
	movl m, %eax #matrice neextinsa
	subl $1, %eax
	movl %eax, m_matrix

	pushl $n
	pushl $formatString
	call scanf
	popl %ebx
	popl %ebx

	addl $2, n #matrice extinsa
	movl n, %eax #matrice neextinsa
	subl $1, %eax
	movl %eax, n_matrix


	pushl $p
	pushl $formatString
	call scanf
	popl %ebx
	popl %ebx

	movl $0, index
	xor %ecx, %ecx
	lea matrix, %edi


et_citire:
	movl index, %ecx
	cmp %ecx, p
	je et_kapa

	pushl $linie
	pushl $formatString
	call scanf
	popl %ebx
	popl %ebx
	addl $1, linie

	pushl $coloana
	pushl $formatString
	call scanf
	popl %ebx
	popl %ebx
	addl $1, coloana


	movl linie, %eax
	xor %edx, %edx
	mull n
	addl coloana, %eax

	lea matrix, %edi
	movl $1, (%edi, %eax, 4)

	incl index
	jmp et_citire

et_kapa:

	pushl $k
	pushl $formatString
	call scanf
	popl %ebx
	popl %ebx

	jmp et_evolutie


et_afisare:
	#Nr evolutiei
	movl count, %ebx
	pushl %ebx
	pushl $afisEvolutie
	call printf
	popl %ebx
	popl %ebx

	pushl $0
	call fflush
	popl %ebx

	movl $1, linie
	for_linie:
	movl linie, %ecx
	cmp m_matrix, %ecx
	je et_evo_cont

	movl $1, coloana
		for_coloana:
		movl coloana, %ecx
		cmp n_matrix, %ecx
		je et_afis_cont

		#inseram in ebx elementul de pe matrix[linie][coloana]
		xor %edx, %edx
		movl linie, %eax
		mull n
		addl coloana, %eax
		lea matrix, %edi
		movl (%edi, %eax, 4), %ebx

		#afisam pe ecran elementul matrix[linie][coloana]
		pushl %ebx
		pushl $afisElem
		call printf
		popl %ebx
		popl %ebx

		pushl $0
		call fflush
		popl %ebx

		incl coloana
		jmp for_coloana

et_afis_cont:
	movl $4, %eax
	movl $1, %ebx
	movl $newLine, %ecx
	movl $2, %edx
	int $0x80

	incl linie
	jmp for_linie


et_evolutie:
bp0:
	movl count, %ecx
	cmp k, %ecx
	je et_exit


	#Construim pt fiecare elem vecinii
	et_vecini:
	movl $1, linie

	for_linie_matrix:
	movl linie, %ecx
	cmp m_matrix, %ecx
	je et_constr_evo

		movl $1, coloana

		for_coloana_matrix:
		movl coloana, %ecx
		cmp n_matrix, %ecx
		je et_matrix_cont

		#Reseteam vecini[linie][coloana] cu 0 de la evol prec
		xorl %edx, %edx
		movl linie, %eax
		mull n
		addl coloana, %eax
		lea vecini, %edi
		movl $0, (%edi, %eax, 4)
		#Resetare

			movl linie, %ecx
			add $1, %ecx
			movl %ecx, lin_vecini
			sub $2, %ecx

			for_linie_vecini:
			cmp lin_vecini, %ecx
			jg et_skip_afisare_vecini

				movl coloana, %ebx
				add $1, %ebx
				movl %ebx, col_vecini
				sub $2, %ebx

				for_coloana_vecini:
				cmp col_vecini, %ebx
				jg for_linie_vecini_cont
bp1:
				#adunare vecini la elem
				#ecx linie vecin, ebx coloana vecin
				#linie/coloana e linia/coloana la care vrem sa calc vecinii
				
				#adunam in matrix[lin][col] toti vecinii de pe 3x3 in afara de el
				cmp linie, %ecx
				jne et_vecini_adunare
				cmp coloana, %ebx
				je et_vecini_neadunare

				et_vecini_adunare:

				movl %ecx, aux

				#salvam in ecx acum valoarea unui vecin al elem din matrix
				#desi refolosim un registru care retinea linia vecinului am zis sa nu ma joc
				#cu alti registrii si sa stric ceva

				xor %edx, %edx
				movl %ecx, %eax
				mull n
				addl %ebx, %eax
				lea matrix, %edi
				movl (%edi, %eax, 4), %ecx

				#adunam valoarea vecinului la vecini[lin][col] (0 nu influenteaza)

				xor %edx, %edx
				movl linie, %eax
				mull n
				addl coloana, %eax
				lea vecini, %edi
				addl %ecx, (%edi, %eax, 4)

				movl aux, %ecx
				movl (%edi, %eax, 4), %edx
				bp2:

				et_vecini_neadunare:

				incl %ebx
				jmp for_coloana_vecini

			for_linie_vecini_cont:
			incl %ecx
			jmp for_linie_vecini


		et_afisare_vecini:
		#inseram in ebx vecini[linie][coloana]
		xor %edx, %edx
		movl linie, %eax
		mull n
		addl coloana, %eax
		lea vecini, %edi
		movl (%edi, %eax, 4), %ebx

		#afisam pe ecran elementul vecini[linie][coloana]
		pushl %ebx
		pushl $afisElem
		call printf
		popl %ebx
		popl %ebx

		pushl $0
		call fflush
		popl %ebx

		et_skip_afisare_vecini:

		incl coloana
		jmp for_coloana_matrix #dupa ce afisam vecini trecem la urm elem din matrix nu?

	et_matrix_cont:
	#	movl $4, %eax
	#	movl $1, %ebx
	#	movl $newLine, %ecx
	#	movl $2, %edx
	#	int $0x80
		
		incl linie
		jmp for_linie_matrix


	#Construim evolutia
	et_constr_evo: #182
	
	movl $1, linie

	for_linie_constr:
		movl linie, %ecx
		cmp m_matrix, %ecx
		je et_evo_afis

		movl $1, coloana

		for_coloana_constr:
		movl coloana, %ecx
		cmp n_matrix, %ecx
		je et_constr_cont

		xorl %edx, %edx
		movl linie, %eax
		mull n
		addl coloana, %eax
		lea matrix, %edi
		movl (%edi, %eax, 4), %ebx

		cmp $0, %ebx
		je et_zero

		et_unu:

		lea vecini, %edi
		movl (%edi, %eax, 4), %ebx
		
		cmp $2, %ebx
		je et_skip
		cmp $3, %ebx
		je et_skip

		lea matrix, %edi
		movl $0, (%edi, %eax, 4)

		jmp et_skip

		et_zero:

		lea vecini, %edi
		movl (%edi, %eax, 4), %ebx
		cmp $3, %ebx
		jne et_skip

		lea matrix, %edi
		movl $1, (%edi, %eax, 4)

		et_skip:

		incl coloana
		jmp for_coloana_constr

	et_constr_cont:
		incl linie
		jmp for_linie_constr


et_evo_afis:
	#Afisam evolutia
	jmp et_afisare

et_evo_cont:
	movl $4, %eax
	movl $1, %ebx
	movl $newLine, %ecx
	movl $2, %edx
	int $0x80

	incl count
	jmp et_evolutie


et_exit:
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
