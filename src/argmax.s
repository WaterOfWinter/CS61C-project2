.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    # Prologue
    li t0, 1    # t0 = min_length
    blt a1, t0, exit_argmax
    li t1, 0    # i = 0
    mv t2, a0   # t2->a0
    lw t4, 0(t2) # t4 = arr[0]
    add t3, t4, x0  # t3 = max
    mv t5, x0    # max_id = 0
    addi t1, t1, 1  # i = 1
    addi t2, t2, 4  # arr[1]

loop_start:
    blt t1, a1, loop_continue  # i < a1
    j loop_end

loop_continue:
    lw t4, 0(t2)    # t4 = arr[i]
    bge t3, t4, max_not_update  # arr[i] < max
    add t3, t4, x0  # max = t4
    add t5, t1, x0  # max_id = i
max_not_update:
    addi t2, t2, 4  # arr[i+1]
    addi t1, t1, 1  # i++
    j loop_start

loop_end:
    

    # Epilogue
    mv a0, t5

    ret

exit_argmax:
    li a0, 77
    j exit2
