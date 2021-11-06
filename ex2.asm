.global _start

.section .text
_start:
cmp $0,num
js Negative
Positive:
movq $destination,%rax
subq $source,%rax
cmp num,%rax
jl forward

backward:
movl num,%eax
b_loop:
movb source-1(%eax),%bl
movb %bl,destination-1(%eax)
dec %eax
jnz b_loop
jmp end


forward:
movl $0,%eax
f_loop:
movb source(%eax),%bl
movb %bl,destination(%eax)
inc %eax
cmp num,%eax
jne f_loop
jmp end



Negative:
movl num,%eax
movl %eax,destination

end: