.global _start

.section .text
_start:
movq a,%rax
movq b,%rbx
gcd:
movq %rbx, %rcx
xor %rdx,%rdx
divq %rbx
movq %rcx,%rax
movq %rdx,%rbx
cmp $0,%rbx
jne gcd
movq %rax, %rsi 
lcm:
movq a,%rax
movq b,%rbx
cwd
mul %rbx
divq %rsi
movq %rax,c
end:



