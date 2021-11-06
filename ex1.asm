.global _start

.section .text
_start:
movq num,%rax
loop: cmp $0,%rax
je end
shrq $1,%rax
jnc continue
incl countBits
continue: jmp loop
end: 