.globl argmax

.text
# =================================================================
# FUNCTION: Maximum Element First Index Finder
#
# Scans an integer array to find its maximum value and returns the
# position of its first occurrence. In cases where multiple elements
# share the maximum value, returns the smallest index.
#
# Arguments:
#   a0 (int *): Pointer to the first element of the array
#   a1 (int):  Number of elements in the array
#
# Returns:
#   a0 (int):  Position of the first maximum element (0-based index)
#
# Preconditions:
#   - Array must contain at least one element
#
# Error Cases:
#   - Terminates program with exit code 36 if array length < 1
# =================================================================
argmax:
    li t6, 1
    blt a1, t6, handle_error

    lw t0, 0(a0)

    li t1, 0
    li t2, 1

    mv t5, a0        
loop_start:
    beq t2, a1, special_case
    beq t1, a1, done
    lw t3, 0(t5)     
    addi t5, t5, 4   

    
    blt t3, t0, skip_update  
    blt t0, t3, update_max  

    
    j skip_update

update_max:
    mv t0, t3        
    mv t2, t1
    

skip_update:
    
    addi t1, t1, 1   
    j loop_start     
special_case:
    mv t2, t1
done:
    
    mv a0, t2        
    jr ra            
    
    
    
handle_error:
    li a0, 36
    j exit
