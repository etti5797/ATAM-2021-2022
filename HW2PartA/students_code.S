.global	keyMixing, byteSubstitution, shiftRows, cipher

.section	.data
sbox:	.byte	99,124,119,123,-14,107,111,-59,48,1,103,43,-2,-41,-85,118
		.byte	-54,-126,-55,125,-6,89,71,-16,-83,-44,-94,-81,-100,-92,114,-64
		.byte	-73,-3,-109,38,54,63,-9,-52,52,-91,-27,-15,113,-40,49,21
		.byte	4,-57,35,-61,24,-106,5,-102,7,18,-128,-30,-21,39,-78,117
		.byte	9,-125,44,26,27,110,90,-96,82,59,-42,-77,41,-29,47,-124
		.byte	83,-47,0,-19,32,-4,-79,91,106,-53,-66,57,74,76,88,-49
		.byte	-48,-17,-86,-5,67,77,51,-123,69,-7,2,127,80,60,-97,-88
		.byte	81,-93,64,-113,-110,-99,56,-11,-68,-74,-38,33,16,-1,-13,-46
		.byte	-51,12,19,-20,95,-105,68,23,-60,-89,126,61,100,93,25,115
		.byte	96,-127,79,-36,34,42,-112,-120,70,-18,-72,20,-34,94,11,-37
		.byte	-32,50,58,10,73,6,36,92,-62,-45,-84,98,-111,-107,-28,121
		.byte	-25,-56,55,109,-115,-43,78,-87,108,86,-12,-22,101,122,-82,8
		.byte	-70,120,37,46,28,-90,-76,-58,-24,-35,116,31,75,-67,-117,-118
		.byte	112,62,-75,102,72,3,-10,14,97,53,87,-71,-122,-63,29,-98
		.byte	-31,-8,-104,17,105,-39,-114,-108,-101,30,-121,-23,-50,85,40,-33
		.byte	-116,-95,-119,13,-65,-26,66,104,65,-103,45,15,-80,84,-69,22

.section	.text
keyMixing:
	movq $0,%rcx
loop:
	cmpq $16,%rcx
	je end_1
	movb (%rsi,%rcx,1),%dl
	xorb %dl,(%rdi,%rcx,1)
	incq %rcx
	jmp loop
end_1:	ret


byteSubstitution:
	movq $0,%rcx
	movq $0, %rdx
loop_2:
	cmpq $16,%rcx
	je end_2
	movb (%rdi,%rcx,1),%dl
	leaq sbox(%rip), %r8
	# addq %r8, %rdx
	# movb (%rdx), %dl
	movb (%r8,%rdx,1),%dl
	movb %dl,(%rdi,%rcx,1)
	incq %rcx
	jmp loop_2
end_2:	ret


shiftRows:
	movq $0,%rcx
loop_3:
	cmpq $4,%rcx
	je end_3
	movl (%rdi,%rcx,4),%edx
	movq %rcx,%r8
	salq $3,%r8 
mini_loop:
	cmp $0,%r8
	je enter_to_memory
	rorl %edx
	decq %r8
	jmp mini_loop
enter_to_memory:
	movl %edx,(%rdi,%rcx,4)
	incq %rcx
	jmp loop_3
end_3:	ret


cipher:
	pushq %rdi
	pushq %rsi
	pushq %rdx
	pushq %rcx
	pushq %r8
	movq %rdx,%rbx #save rdx to avoid to reload after each call of function
	movq $0,%r15
main_loop:
	cmp %rbx,%r15
	je end_4
	call keyMixing
	movq $0,%r13	
loop_9:
	cmp $9,%r13
	je end_9_loop
	call byteSubstitution
	call shiftRows
	pushq %rdi
	pushq %rsi
	call mixColumns
	popq %rsi
	popq %rdi
	call keyMixing
	incq %r13
	jmp loop_9
end_9_loop:
	call byteSubstitution
	call shiftRows
	call keyMixing
	incq %r15
	addq $16,%rdi
	jmp main_loop
end_4:
	popq %r8
	popq %rcx
	popq %rdx
	popq %rsi
	popq %rdi
	ret















