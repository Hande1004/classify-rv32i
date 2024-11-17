.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication Implementation
#
# Performs operation: D = M0 × M1
# Where:
#   - M0 is a (rows0 × cols0) matrix
#   - M1 is a (rows1 × cols1) matrix
#   - D is a (rows0 × cols1) result matrix
#
# Arguments:
#   First Matrix (M0):
#     a0: Memory address of first element
#     a1: Row count
#     a2: Column count
#
#   Second Matrix (M1):
#     a3: Memory address of first element
#     a4: Row count
#     a5: Column count
#
#   Output Matrix (D):
#     a6: Memory address for result storage
#
# Validation (in sequence):
#   1. Validates M0: Ensures positive dimensions
#   2. Validates M1: Ensures positive dimensions
#   3. Validates multiplication compatibility: M0_cols = M1_rows
#   All failures trigger program exit with code 38
#
# Output:
#   None explicit - Result matrix D populated in-place
# =======================================================
matmul:
    # Error checks
    li t0, 1
    blt a1, t0, error
    blt a2, t0, error
    blt a4, t0, error
    blt a5, t0, error
    bne a2, a4, error

    # Prologue
    addi sp, sp, -28
    sw ra, 0(sp)
    
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    
    li s0, 0        # Outer loop counter (rows of M0)
    mv s2, a6       # Result matrix pointer
    mv s3, a0       # Pointer to current row of M0

outer_loop_start:
    blt s0, a1, inner_loop_prep
    j outer_loop_end

inner_loop_prep:
    li s1, 0        # Inner loop counter (columns of M1)
    mv s4, a3       # Pointer to first element of M1
    j inner_loop_start

inner_loop_start:
    beq s1, a5, inner_loop_end

    addi sp, sp, -24
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw a5, 20(sp)
    
    mv a0, s3       # Pointer to current row in M0
    mv a1, s4       # Pointer to current column in M1
    mv a2, a2       # Number of elements (columns of M0 or rows of M1)
    li a3, 1        # Stride for M0 (row-wise)
    mv a4, a5       # Stride for M1 (column-wise)
    
    jal dot         # Call dot product function
    
    mv t0, a0       # Store result of dot product
    
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw a5, 20(sp)
    addi sp, sp, 24
    
    sw t0, 0(s2)    # Store result in D
    addi s2, s2, 4  # Increment result matrix pointer
    
    addi s4, s4, 4  # Move to next column in M1
    addi s1, s1, 1  # Increment inner loop counter
    j inner_loop_start

inner_loop_end:
    # TODO: Add your own implementation
    addi s0, s0, 1          # Increment outer loop counter
    slli t1, a2, 2          # t1 = a2 * 4 (size of one row in bytes)
    add s3, s3, t1          # Move s3 to next row in M0
    j outer_loop_start

outer_loop_end:
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28
    jr ra

error:
    li a0, 38
    j exit
