.data
	n: .space 4
	m: .space 4
	p: .space 4
	k: .space 4
	aux: .space 4
	count: .long 0
	col_vecini: .space 4
	lin_vecini: .space 4
	index: .space 4
	linie: .space 4
	coloana: .space 4
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

	pushl $n
	pushl $formatString
	call scanf
	popl %ebx
	popl %ebx

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

	pushl $coloana
	pushl $formatString
	call scanf
	popl %ebx
	popl %ebx

	movl linie, %eax
	addl $1, %eax
	xor %edx, %edx
	mull n
	addl coloana, %eax
	addl $1, %eax

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
	pushl afisEvolutie
	call printf
	popl %ebx
	popl %ebx

	pushl $0
	call fflush
	popl %ebx

	movl $1, linie
	for_linie:
	movl linie, %ecx
	cmp %ecx, m
	jb et_if

	movl $1, coloana
		for_coloana:
		movl coloana, %ecx
		cmp %ecx, n
		jb et_afis_cont

		#inseram in ebx elementul de pe matrix[linie][coloana]
		xor %edx, %edx
		movl linie, %eax
		mull n
		addl coloana, %eax
		lea vecini, %edi
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
	movl count, %ecx
	cmp %ecx, k
	je et_exit

	#Construim pt fiecare elem vecinii
	et_vecini:
	movl $1, linie
	for_linie_matrix:
	movl linie, %ecx
	cmp %ecx, m
	jb et_constr_evo

		movl $1, coloana
		for_coloana_matrix:
		movl coloana, %ecx
		cmp %ecx, n
		jb et_vecini_cont

			movl linie, %ecx
			add $1, %ecx
			movl %ecx, lin_vecini
			sub $2, %ecx

			for_linie_vecini:
			cmp %ecx, lin_vecini
			jb et_afisare_vecini

				movl coloana, %ebx
				add $1, %ebx
				movl %ebx, col_vecini
				sub $2, %ebx

				for_coloana_vecini:
				cmp %ebx, col_vecini
				jb for_linie_vecini_cont

				#adunare vecini la elem
				#ecx linie vecin, ebx coloana vecin
				#linie/coloana e linia/coloana la care vrem sa calc vecinii
				
				#adunam in matrix[lin][col] toti vecinii de pe 3x3 in afara de el
				cmp %ecx, linie
				jne et_vecini_adunare
				cmp %ebx, coloana
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

				et_vecini_neadunare:

				incl %ebx
				jmp for_coloana_vecini

			for_linie_vecini_cont:
			incl %eax
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

		incl coloana
		jmp for_coloana_vecini

	et_vecini_cont:
		movl $4, %eax
		movl $1, %ebx
		movl $newLine, %ecx
		movl $2, %edx
		int $0x80
		
		incl linie
		jmp for_linie_matrix


	#Construim evolutia
	et_constr_evo:



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


et_if: #Prima afisare - matrice neschimbata; celelalte continuam evolutia
	movl count, %ecx
	cmp $0, %ecx
	jz et_evolutie
	jmp et_evo_cont


et_exit:
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
