.global _start

.section .text
_start:
movl $0,countBits
movq num,%rax
loop: cmp $0,%rax
je end
shrq $1,%rax
jnc continue
incl countBits
continue: jmp loop
end: 