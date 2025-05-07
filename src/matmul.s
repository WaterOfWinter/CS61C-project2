.globl matmul

# .import dot

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# d = matmul(m0, m1)
# Arguments:
# a0 (int*)  is the pointer to the start of m0 
# a1 (int)   is the # of rows (height) of m0
# a2 (int)   is the # of columns (width) of m0
# a3 (int*)  is the pointer to the start of m1
# a4 (int)   is the # of rows (height) of m1
# a5 (int)   is the # of columns (width) of m1
# a6 (int*)  is the pointer to the the start of d
# Returns:
# None (void), sets d = matmul(m0, m1)
# =======================================================

matmul:
    # Error checks
    li t0, 1
    blt a1, t0, exit_72  # If m0 rows < 1
    blt a2, t0, exit_72  # If m0 cols < 1
    blt a4, t0, exit_73  # If m1 rows < 1
    blt a5, t0, exit_73  # If m1 cols < 1
    bne a2, a4, exit_74  # If m0 cols != m1 rows, error

    # Prologue
    li t0, 0            # i = 0 outer loop (row index for m0)
outer_loop_start:
    bge t0, a1, outer_loop_end  # If i >= m0 rows, exit outer loop

    li t1, 0            # j = 0 inner loop (column index for m1)
inner_loop_start:
    bge t1, a5, inner_loop_end  # If j >= m1 cols, exit inner loop

    # Backup caller-saved registers
    addi sp, sp, -20
    sw ra, 16(sp)
    sw t0, 12(sp)
    sw t1, 8(sp)
    sw t2, 4(sp)
    sw t3, 0(sp)

    # Compute address of row i in m0: a0 = a0 + (i * a2 * 4)
    mv t2, a0          # base of m0
    mul t4, t0, a2     # i * a2 (number of elements in each row of m0)
    slli t4, t4, 2     # *4 (word size)
    add a0, t2, t4     # a0 = &m0[i][0] (pointer to the start of row i in m0)

    # Compute address of col j in m1: a1 = a3 + (j * 4)
    mv t3, a3          # base of m1
    slli t5, t1, 2     # j * 4 (multiply column index by size of int)
    add a1, t3, t5     # a1 = &m1[0][j] (pointer to the start of column j in m1)

    mv a2, a2          # common length (same as #cols in m0)
    li a3, 1           # stride for row of m0 (1 element per row)
    mv a4, a5          # stride for col of m1 (col-major format)

    # Call dot to compute the dot product of row i of m0 and col j of m1
    jal ra, dot        # result will be returned in a0

    # Compute address to store result in d[i][j]
    mul t6, t0, a5     # i * #cols (row index * number of columns in m1)
    add t6, t6, t1     # i * #cols + j (linear index for d[i][j])
    slli t6, t6, 2     # *4 (word size)
    add t6, a6, t6     # address of d[i][j]
    sw a0, 0(t6)       # store the result in d[i][j]

    # Restore registers
    lw t3, 0(sp)
    lw t2, 4(sp)
    lw t1, 8(sp)
    lw t0, 12(sp)
    lw ra, 16(sp)
    addi sp, sp, 20

    addi t1, t1, 1
    j inner_loop_start

inner_loop_end:
    addi t0, t0, 1
    j outer_loop_start

outer_loop_end:
    ret

# === Error exits ===
exit_72:
    li a0, 72
    j exit2

exit_73:
    li a0, 73
    j exit2

exit_74:
    li a0, 74
    j exit2
