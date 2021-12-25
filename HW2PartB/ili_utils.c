#include <asm/desc.h>

unsigned long pow_by_two_n_times(int n)
{
    unsigned long cur=1;
    int i=1;
    for(;i<=n;i++)
    { 
        cur*=2;  
    }
    return cur;
}

void my_store_idt(struct desc_ptr *idtr) {
 asm volatile ("sidt %0" : "=m"(*idtr));

}

void my_load_idt(struct desc_ptr *idtr) {
 asm volatile("lidt %0" :: "m"(*idtr));
}

void my_set_gate_offset(gate_desc *gate, unsigned long addr) {
unsigned long high_offset=addr/pow_by_two_n_times(32);
//modulo is like bitwise and with n 1 at most right places and zeros in the rest
unsigned long middle_offset=(addr/pow_by_two_n_times(16))%(pow_by_two_n_times(16));
unsigned long low_offset=addr%pow_by_two_n_times(16);
gate->offset_low=low_offset;
gate->offset_high=high_offset;
gate->offset_middle=middle_offset;
return;
}

unsigned long my_get_gate_offset(gate_desc *gate) {
unsigned long high=gate->offset_high;
unsigned long low=gate->offset_low;
unsigned long middle=gate->offset_middle;
unsigned long address;
              // *pow is like shift left n times
address=high*pow_by_two_n_times(32)+middle*pow_by_two_n_times(16)+low;
return address;
}
