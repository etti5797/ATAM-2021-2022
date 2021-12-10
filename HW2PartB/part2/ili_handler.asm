.globl my_ili_handler

.text
.align 4, 0x90
my_ili_handler:
	pushq %rax
	pushq %rdi
	pushq %rsi
	pushq %rdx
	pushq %rcx
	pushq %r8
	pushq %r9
	pushq %r10
	pushq %r11

	#rip hold the opcode
	movq $0,%rbx
	movq 72(%rsp),%r13 #get to rip-address of opcode
	movq (%r13),%r13
  	cmpb $0x0f,%r13b
	je two_byte
one_byte:
	movq $1,%rbx
	movb %r13b,%dil
	jmp to_do
two_byte:
	movq $2,%rbx
	shrq $8,%r13
	movb %r13b,%dil
to_do:	
	call what_to_do
	cmpq $0,%rax
	movq %rax,%rdi #rdi hold the return value from what_to_do
	je origin_handler
	popq %r11
	popq %r10
	popq %r9
	popq %r8
	popq %rcx
	popq %rdx
	popq %rsi
	popq %rax # rax will get rdi's value temporarily so he wont change what we have in rdi
	popq %rax
	addq %rbx,(%rsp) #for the next command 
	jmp end
origin_handler:
	popq %r11
	popq %r10
	popq %r9
	popq %r8
	popq %rcx
	popq %rdx
	popq %rsi
	popq %rdi
	popq %rax
	jmp *old_ili_handler
 end:
	iretq
