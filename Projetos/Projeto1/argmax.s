.data
# You can change this array to test other values
array: .word 5, 9, 3, 9, 2   # return 1
array2: .word 1              # return 0

.text

main:
    la a0, array           # Load address of the array
    li a1, 5               # Number of elements in the array

    jal ra, argmax         # Call the argmax function

    # Result: the index of the largest element is now in a0

exit:
    # TODO remove first ecall
    li a7, 1
    ecall
    li a7, 10              # Exit syscall code
    ecall                  # Terminate the program


# =================================================================
# FUNCTION: Given an int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the number of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax: 
    # If the length of the array is less than 1
    bgt a1, zero, continue 
        addi a0, zero, 63
        j exit_with_error
        
    continue:
    # t0 contains the index of the largest number
    li t0, 0          # Inicializes with the index 0
    lw t2, 0(a0)      # t2 contains the largest number 
    
    li t1, 0  # t1 is the index
loop:         # for (t1=1; t1<=a1; ++t1) 
        addi t1, t1, 1
        addi a0, a0, 4          # Adress of the next word of the array
        lw t3, 0(a0)            # Current word of the array[t1]
        bge t2, t3, true        # If t2(max) < t3(array[t1])
            add t2, t3, zero    # Saves in t2 a new max value
            add t0, zero, t1    # Saves in t0 a new idex of the max value
true:   ble t1, a1, loop
    
    j loop_end
loop_end:
    add a0, t0, zero                 # Return a0(int)
    jr ra                        # Return to the caller

# Exits the program with an error 
# Arguments: 
# a0 (int) is the error code 
# You need to load a0 the error to a0 before to jump here
exit_with_error:
    li a7, 93                    # Exit system call
    ecall                        # Terminate program
