.globl read_matrix

.text
# ==============================================================================
# FUNCTION: read_matrix
# Description:
#   Reads a matrix from a binary file, allocates memory for it, and loads values.
# Arguments:
#   a0 (char*)  = filename
#   a1 (int*)   = pointer to store number of rows
#   a2 (int*)   = pointer to store number of cols
# Returns:
#   a0 (int*)   = pointer to allocated matrix
# Exceptions:
#   88 = malloc failed
#   90 = fopen failed
#   91 = fread failed
#   92 = fclose failed
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -36
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw ra, 32(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2

    # fopen: get file descriptor [t0]
    mv a1, s0
    li a2, 0
    jal fopen
    blt a0, x0, exit_90 # error
    mv s5, a0

    # read 1 dim from [t0]
    mv a1, s5
    mv a2, s1
    li a3, 4
    jal fread
    blt a0, x0, exit_91 # error

    # read 1 dim from [t0]
    mv a1, s5
    mv a2, s2
    li a3, 4
    jal fread
    blt a0, x0, exit_91 # error


    # malloc matrix
    lw t2, 0(s1)
    lw t3, 0(s2)
    mul t2, t2, t3
    slli t2, t2, 2
    mv a0, t2
    jal malloc
    beq a0, x0, exit_88 # error
    mv s3, a0

    li s6, 0
    lw t2, 0(s1)
    lw t3, 0(s2)
    mul t2, t2, t3
    slli t2, t2, 2
    mv s7, t2

loop_start:
    mv a1, s5
    mv a2, s3
    add a2, a2, s6
    mv a3, s7
    jal fread
    add s6, a0, s6
    blt s6, s7, loop_start

loop_end:

    mv a1, s5
    jal fclose
    blt a0, zero, exit_92 # error
    
    mv t0, s3

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw ra, 32(sp)
    addi sp, sp, 36

    mv a0, t0
    ret

exit_88:
    li a1, 88
    j exit2

exit_90:
    li a1, 90
    j exit2

exit_91:
    li a1, 91
    j exit2

exit_92:
    li a1, 92
    j exit2