.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Binary Matrix File Reader
#
# Loads matrix data from a binary file into dynamically allocated memory.
# Matrix dimensions are read from file header and stored at provided addresses.
#
# Binary File Format:
#   Header (8 bytes):
#     - Bytes 0-3: Number of rows (int32)
#     - Bytes 4-7: Number of columns (int32)
#   Data:
#     - Subsequent 4-byte blocks: Matrix elements
#     - Stored in row-major order: [row0|row1|row2|...]
#
# Arguments:
#   Input:
#     a0: Pointer to filename string
#     a1: Address to write row count
#     a2: Address to write column count
#
#   Output:
#     a0: Base address of loaded matrix
#
# Error Handling:
#   Program terminates with:
#   - Code 26: Dynamic memory allocation failed
#   - Code 27: File access error (open/EOF)
#   - Code 28: File closure error
#   - Code 29: Data read error
#
# Memory Note:
#   Caller is responsible for freeing returned matrix pointer
# ==============================================================================
read_matrix:
    
    # Prologue
    addi sp, sp, -40
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)

    mv s3, a1         # save and copy rows
    mv s4, a2         # save and copy cols

    li a1, 0

    jal fopen

    li t0, -1
    beq a0, t0, fopen_error   # fopen didn't work

    mv s0, a0        # file

    # read rows n columns 
    mv a0, s0
    addi a1, sp, 28  # a1 is a buffer

    li a2, 8         # look at 2 numbers

    jal fread

    li t0, 8
    bne a0, t0, fread_error

    lw t1, 28(sp)    # opening to save num rows
    lw t2, 32(sp)    # opening to save num cols

    sw t1, 0(s3)     # saves num rows
    sw t2, 0(s4)     # saves num cols
    # mul s1, t1, t2   # s1 is number of elements
    # FIXME: Replace 'mul' with your own implementation
   

    # Check if t1 == 0 or t2 == 0
    beq t1, zero, mult_zero    # If t1 == 0, result is zero
    beq t2, zero, mult_zero    # If t2 == 0, result is zero

    # Determine signs and get absolute values
    srai t5, t1, 31            # t5 = sign bit of t1 (-1 if negative, 0 if positive)
    xor t6, t1, t5             # t6 = t1 ^ t5
    sub t6, t6, t5             # t6 = t6 - t5 (absolute value of t1)

    srai a5, t2, 31            # t7 = sign bit of t2
    xor a6, t2, a5             # t8 = t2 ^ t7
    sub t6, t6, t5             # t8 = t8 - t7 (absolute value of t2)

    # Determine sign of result
    xor a7, t5, a5             # t9 = t5 ^ t7 (0 if same sign, -1 if different signs)

    # Initialize result
    li s1, 0                   # s1 = 0

mult_loop:
    beq a6, zero, mult_end     # If a6 == 0, multiplication is done
    andi a4, a6, 1            # a4 = a6 & 1 (check LSB)
    beq a4, zero, mult_skip_add
    add s1, s1, t6             # s1 += t6
mult_skip_add:
    slli t6, t6, 1              # t6 <<= 1
    srli a6, a6, 1              # a6 >>= 1
    j mult_loop
mult_end:
    # Adjust sign of result
    beqz a7, mult_done         # If a7 == 0, result is positive
    sub s1, zero, s1           # s1 = -s1
mult_done:
    j mult_finish
mult_zero:
    li s1, 0                   # s1 = 0
mult_finish:

    slli t3, s1, 2             # t3 = s1 * 4 (size in bytes)
    sw t3, 24(sp)              # size in bytes

    lw a0, 24(sp)              # a0 = size in bytes

    jal malloc

    beq a0, x0, malloc_error

    # Set up file, buffer, and bytes to read
    mv s2, a0                  # matrix 
    mv a0, s0                  
    mv a1, s2                  
    lw a2, 24(sp)              

    jal fread

    lw t3, 24(sp)
    bne a0, t3, fread_error

    mv a0, s0

    jal fclose

    li t0, -1

    beq a0, t0, fclose_error

    mv a0, s2                  

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 40

    jr ra

malloc_error:
    li a0, 26
    j error_exit

fopen_error:
    li a0, 27
    j error_exit

fread_error:
    li a0, 29
    j error_exit

fclose_error:
    li a0, 28
    j error_exit

error_exit:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 40
    j exit
