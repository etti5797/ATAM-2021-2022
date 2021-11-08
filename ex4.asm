.global _start

.section .text
_start:
movq root,%rax
cmp $0,%rax
je empty_tree

search:
movq %rax,%rcx    
movq (%rax),%rax    
cmpq %rax,new_node
je end
jg right

left:
movq 8(%rcx),%rax  
cmpq $0,%rax
jne search
movq $new_node,8(%rcx)
jmp end

right:
movq 16(%rcx),%rax 
cmpq $0,%rax
jne search
movq $new_node,16(%rcx)
jmp end



empty_tree:
movq $new_node,%rax
movq %rax,root

end: