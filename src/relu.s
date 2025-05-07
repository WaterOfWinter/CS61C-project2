.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    li t1 1   # int min_length = 1
    blt a1, t1, exit_relu   # a1 < 1
    li t2, 0        # int i = 0; i < a1; i++ 
    li t3, 4        # sizeof(int)
    mv t6, a0            # t6 = array pointer (current)
    
loop_start:
    blt t2, a1, loop_continue  # i < a1
    j loop_end 

loop_continue:
    lw t4, 0(t6)               # t4 = arr[i]
    bgt t4, x0, positive_port  # arr[i] > 0, jump
    sw x0, 0(t6)               # arr[i] = 0
     
positive_port:
    addi t6, t6, 4             # temp = arr[i]
    addi t2, t2, 1
    j loop_start
    
exit_relu:
    li a0, 78
    j exit2

loop_end:

    # Epilogue

    
	ret
