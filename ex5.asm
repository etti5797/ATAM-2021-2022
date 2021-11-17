.global _start


.section .text
_start:                           
movq src,%rax             #may chaange to move
movq dst,%rbx
leaq head,%r8
movq 0(%r8),%rcx               #address ANODE RCX

movb $0,%dl   #bool src_found 
movb $0,%dh  #bool dst_found

movq %rcx,%r10 #temp
movq %rcx,%r9 #previous

cmpq $0,%rcx  # *head is null
je end

loop:
cmpq $0,%r10  #while temp!=null
je end_loop
cmpq %rax,(%r10)  #is temp = src ? 
jne is_dest
incb %dl
movq %r9,%r15    #r15=previous_src
movq %r10,%r11 #r11=src node
jmp update 

is_dest:
cmpq %rbx,(%r10)
jne update
cmpb $0,%dl
je end
incb %dh
movq %r9,%r14  #r14 is dst_prev
movq %r10,%r12 #r12- dst node

update:
cmpq %r10,%r9
je skip
movq 8(%r9),%r9
movq 8(%r10),%r10 
jmp loop
skip:
movq 8(%r10),%r10 
jmp loop


end_loop:
cmpb $0,%dl
je end
cmpb $0,%dh
je end



cmpq (%r14),%rax   #src and dst one after another        
je type_two_update  
type_one_update:  #not close
leaq 8(%r11),%rsi  #src->next
leaq 8(%r12),%rdx #d->n
movq (%rdx),%r9
movq (%rsi),%r10 
movq %r10,(%rdx) 
movq %r9,(%rsi)
movq %r11,8(%r14)
cmpq (%rcx),%rax  #src first?
je special_case
movq %r12,8(%r15)
jmp end
special_case:  #src is the first
movq %r12,head
jmp end


type_two_update :  #close
leaq 8(%r12),%rdx
movq (%rdx),%r9
movq %r11,(%rdx)
movq %r9,8(%r11)
cmpq (%rcx),%rax  #src first?
je special_case_again
movq %r12,8(%r15)
jmp end
special_case_again:
movq %r12,head

end:



