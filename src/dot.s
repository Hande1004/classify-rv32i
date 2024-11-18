.globl dot

.text

# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
dot:
    li t0, 1
    blt a2, t0, error_terminate  
    blt a3, t0, error_terminate   
    blt a4, t0, error_terminate  

    li t0, 0            
    li t1, 0         

loop_start:
    bge t1, a2, loop_end
    # TODO: Add your own implementation
    mv a5, t1
    mv a6, a3
    li t2, 0            	 
    beqz a5, mult_done1
    beqz a6, mult_done1
mult_loop1:
    andi t3, a5, 1		 
    beq t3, zero, skip_add1
    add t2 , t2, a6 
skip_add1:    
    srli a5, a5, 1
    slli a6, a6, 1
    bnez a5, mult_loop1
mult_done1:
    slli t2, t2, 2
    add t4, a0, t2
    lw t4,0(t4)
    
    mv a5, t1
    mv a7, a4
    li t3, 0            	 
    beqz a5, mult_done2
    beqz a7, mult_done2
mult_loop2:
    andi t2, a5, 1		 
    beq t2, zero, skip_add2
    add t3 , t3, a7 
skip_add2:    
    srli a5, a5, 1
    slli a7, a7, 1
    bnez a5, mult_loop2
mult_done2:
    slli t3, t3, 2
    add t5, a1, t3
    lw t5,0(t5)
    
    li t6, 0            	 
    beqz t4, mult_done3
    beqz t5, mult_done3
mult_loop3:
    andi t2, t4, 1		 
    beq t2, zero, skip_add3
    add t6 , t6, t5 
skip_add3:    
    srli t4, t4, 1
    slli t5, t5, 1
    bnez t4, mult_loop3
mult_done3:
    add t0, t0, t6
    
    addi t1, t1, 1 
    j loop_start


loop_end:
    mv a0, t0
    jr ra

error_terminate:
    blt a2, t0, set_error_36
    li a0, 37
    j exit

set_error_36:
    li a0, 36
    j exit
