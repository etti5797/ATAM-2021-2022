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
	movq $0,%rdi
	movq 72(%rsp),%r10 #get to rip-address of opcode
	movq (%r10),%r10
  	cmpb $0x0f,%r10b
	je two_byte
one_byte:
	movb %r10b,%dil
	call what_to_do
	cmpq $0,%rax
	je origin_handler	
	addq $1 ,72(%rsp)
	jmp to_do
two_byte:
	shrq $8,%r10
	movb %r10b,%dil
	call what_to_do
	cmpq $0,%rax
	je origin_handler	
	addq $2 ,72(%rsp)

to_do:	
	movq %rax,%rdi #rdi hold the return value from what_to_do
	popq %r11
	popq %r10
	popq %r9
	popq %r8
	popq %rcx
	popq %rdx
	popq %rsi
	popq %rax # rax will get rdi's value temporarily so he wont change what we have in rdi
	popq %rax 
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
