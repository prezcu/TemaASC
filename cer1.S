.data
	n: .space 4
	m: .space 4
	p: .space 4
	index: .space 4
	linie: .space 4
	coloana: .space 4
	matrix: .space 1600
	vecini: .space 1600
	formatString: .asciz "%d"
	textAfisat: .asciz "Variabila n este: %d \n"
	newLine: .asciz "\n"
	afisElem: .asciz "%d "

.text

.global main
main:
	pushl $m
	pushl $formatString
	call scanf
	add $8, %esp

	pushl $n
	pushl $formatString
	call scanf
	add $8, %esp

	pushl $p
	pushl $formatString
	call scanf
	add $8, %esp

	movl $0, index
	xor %ecx, %ecx
	lea matrix, %edi


et_citire:
	movl index, %ecx
	cmp %ecx, p
	je et_afis

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
	movl $0, %edx
	mull n
	addl coloana, %eax
	addl $1, %eax

	lea matrix, %edi
	movl $1, (%edi, %eax, 4)

	incl index
	jmp et_citire

et_afis:
	movl $1, linie
	for_linie:
	movl linie, %ecx
	cmp %ecx,m
	jg et_exit

	movl $1, coloana
		for_coloana:
		movl coloana, %ecx
		cmp %ecx, n
		jg cont

		xor %edx, %edx
		movl linie, %eax
		mull n
		addl coloana, %eax
		movl (%edi, %eax, 4), %ebx

		pushl %ebx
		pushl afisElem
		call printf
		popl %ebx
		popl %ebx

		pushl $0
		call fflush
		popl %ebx

		incl coloana
		jmp for_coloana

	cont:
	movl $4, %eax
	movl $1, %ebx
	movl $newLine, %ecx
	movl $2, %edx
	int $0x80

	incl linie
	jmp for_linie

et_exit:
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
