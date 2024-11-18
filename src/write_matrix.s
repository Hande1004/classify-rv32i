.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Write a matrix of integers to a binary file
# FILE FORMAT:
#   - The first 8 bytes store two 4-byte integers representing the number of 
#     rows and columns, respectively.
#   - Each subsequent 4-byte segment represents a matrix element, stored in 
#     row-major order.
#
# Arguments:
#   a0 (char *) - Pointer to a string representing the filename.
#   a1 (int *)  - Pointer to the matrix's starting location in memory.
#   a2 (int)    - Number of rows in the matrix.
#   a3 (int)    - Number of columns in the matrix.
#
# Returns:
#   None
#
# Exceptions:
#   - Terminates with error code 27 on `fopen` error or end-of-file (EOF).
#   - Terminates with error code 28 on `fclose` error or EOF.
#   - Terminates with error code 30 on `fwrite` error or EOF.
# ==============================================================================
write_matrix:
    # Prologue
    addi sp, sp, -44
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)

    # save arguments
    mv s1, a1        # s1 = matrix pointer
    mv s2, a2        # s2 = number of rows
    mv s3, a3        # s3 = number of columns

    li a1, 1

    jal fopen

    li t0, -1
    beq a0, t0, fopen_error   # fopen didn't work

    mv s0, a0        # file descriptor

    # Write number of rows and columns to file
    sw s2, 24(sp)    # number of rows
    sw s3, 28(sp)    # number of columns

    mv a0, s0
    addi a1, sp, 24  # buffer with rows and columns
    li a2, 2         # number of elements to write
    li a3, 4         # size of each element

    jal fwrite

    li t0, 2
    bne a0, t0, fwrite_error

    # mul s4, s2, s3   # s4 = total elements
    # FIXME: Replace 'mul' with your own implementation


    # Save signs of s2 and s3
    srai t1, s2, 31    # t1 = s2 >> 31 (sign bit of s2)
    srai t2, s3, 31    # t2 = s3 >> 31 (sign bit of s3)

    # Get absolute values of s2 and s3
    xor t3, s2, t1     # t3 = s2 ^ t1
    sub t3, t3, t1     # t3 = t3 - t1 (t3 = abs(s2))
    xor t4, s3, t2     # t4 = s3 ^ t2
    sub t4, t4, t2     # t4 = t4 - t2 (t4 = abs(s3))

    # Initialize result
    li s4, 0           # s4 = 0

mul_loop:
    beq t4, zero, adjust_sign   # If t4 == 0, exit loop
    andi t5, t4, 1              # t5 = t4 & 1
    beq t5, zero, skip_add
    add s4, s4, t3              # s4 = s4 + t3
skip_add:
    slli t3, t3, 1               # t3 = t3 << 1
    srli t4, t4, 1               # t4 = t4 >> 1
    j mul_loop

adjust_sign:
    xor t6, t1, t2              # t6 = t1 ^ t2 (if signs differ, t6 = 1)
    beqz t6, mul_done           # If t6 == 0, signs are same, result is positive
    sub s4, zero, s4            # Negate s4 to get negative result
mul_done:
    # End of multiplication

    # write matrix data to file
    mv a0, s0
    mv a1, s1        # matrix data pointer
    mv a2, s4        # number of elements to write
    li a3, 4         # size of each element

    jal fwrite

    bne a0, s4, fwrite_error

    mv a0, s0

    jal fclose

    li t0, -1
    beq a0, t0, fclose_error

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 44

    jr ra

fopen_error:
    li a0, 27
    j error_exit

fwrite_error:
    li a0, 30
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
    addi sp, sp, 44
    j exit
