.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:

    # Prologue
    li t0, 1    # min_length
    blt a2, t0, exit_75
    blt a3, t0, exit_76
    blt a4, t0, exit_76
    li t1, 0    # i = 0
    li t2, 0    # sum = 0
    mv t3, a0   # t3 = arr
    mv t4, a1   # t4 = arr
    

loop_start:
    bge  t1, a2, loop_end
    lw t5, 0(t3)        # v0[i]
    lw t6, 0(t4)        # v1[i]
    mul t0, t5, t6
    add t2, t2, t0
    addi t1, t1, 1      # i++

    slli t5, a3, 2      # t5 = stride_v0 * 4
    add t3, t3, t5      # v0 地址更新

    slli t6, a4, 2      # t6 = stride_v1 * 4
    add t4, t4, t6      # v1 地址更新

    j loop_start

loop_end:


    # Epilogue
    mv a0, t2
    
    ret
    
exit_75:
    li a0, 75
    j exit2

exit_76:
    li a0, 76
    j exit2
    

