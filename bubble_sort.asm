# Tipper Truong
# CS 147 Homework 6
# Bubble Sort Algorithm
# Expected Output --> SwapCount = 6
# Sorted Array Output --> 1, 2, 3, 4, 5, 6, 8, 9

.data
	a: .word 9, 8, 6, 5, 1, 2, 3, 4 # int[] a = {9, 8, 6, 5, 1, 2, 3, 4}
	space: .asciiz " "
	newLine: .asciiz "\n"
	n: .word 8 # size of int[] a
	unsortedArrayText: .asciiz "Unsorted Array: "
	sortedArrayText: .asciiz "Sorted Array: "
	swapCountText: .asciiz "SwapCount: "
.text

main:
		# prints Unsorted Array: 
		li $v0, 4
		la $a0, unsortedArrayText
		syscall
		jal printArray # printArray() --> print unsorted array
		
		la $a0, a # args0 --> address of int a[]
		lw $a1, n # args1 --> n = 8
		jal sort # sort(int[] a, int n)
		
		# print SwapCount: 
		li $v0, 4
		la $a0, swapCountText
		syscall
		
		# print computed swapCount value from sort function
		li $v0, 1
		addi $a0, $s0, 0
		syscall
		
		# print new line
		li $v0, 4
		la $a0, newLine
		syscall
		
		# prints Sorted Array: 
		li $v0, 4
		la $a0, sortedArrayText
		syscall
		jal printArray # print sorted array
		
		# End Program
		li $v0, 10
		syscall

 printArray: # prints the unsorted and sorted array
	la $t1, a # address of int a[]
	lw $t3, n # n 
	addi $t0, $zero, 0 # i = 0
	
	while: 
		bge $t0, $t3, exit # 
		sll $t2, $t0, 2 # i * 2^2
		addu $t2, $t2, $t1 # address of a[i]
		
		#prints current number in int[] a
		li $v0, 1
		lw $a0, 0($t2)
		syscall
		
		# prints " "
		li $v0, 4
		la $a0, space
		syscall
		
		addi $t0, $t0, 1 # i++
		j while 
	exit: 
		# prints new line
		li $v0, 4
		la $a0, newLine
		syscall
		
		jr $ra # return address

swap: # swap(a, j, iMin) code citation: http://www-inst.eecs.berkeley.edu/~cs61c/sp13/disc/04/Disc4Soln.pdf
	sll $a1, $a1, 2
     	sll $a2, $a2, 2
     	addu $a1, $a0, $a1
     	addu $a2, $a0, $a2
     	lw $t8, 0($a1)
     	lw $t9, 0($a2) 	
     	sw $t8, 0($a2)
     	sw $t9, 0($a1)
     	jr $ra
     	
		
sort: # follows Bubble Sort Algorithm

	# $t0 = j 
	# $t1 = i 
	# $t2 = n-1
	# $t3 = address of int[] a 
	# $t4 = iMin
	# $t5 = n
	# $s0 = swapCount 
	
	addi $t4, $zero, 0 # iMin = 0
	addi $t5, $a1, 0 # $ t5 = n
	addi $s0, $zero, 0 # swapCount = 0;
	
	add $t0, $zero, 0 # $t0 --> j = 0
	subi $t2, $a1, 1 # $t2 --> (n - 1)
	addi $t3, $a0, 0 # $ t3 --> address of int[] a
	
	for_loop_1:
		bge $t0, $t2, return_swap_count # j >= (n-1) FAIL --> exit outer for loop, return swapCount
		addi $t4, $t0, 0 # iMin = j
		addi $t1, $t0, 1 # $t1 --> i = j + 1
		
		for_loop_2:
			bge $t1, $t5, exit_for_loop_2 # i >= n --> FAIL exit inner for loop
			
			sll $t6, $t1, 2 # i * 2^2
			addu $t6, $t6, $t3 # address of a[i]
			lw $s1, 0($t6) # $s1 --> a[i]
			
			sll $t7, $t4, 2 # iMin * 2^2
			addu $t7, $t7, $t3 # a[iMin]
			lw $s2, 0($t7) # s2 --> a[iMin]
			
			bge $s1, $s2, increment_for_loop_2 # a[i] >= a[iMin] --> FAIL exit inner for loop
			
			addi $t4, $t1, 0 # iMin = i
			
			addi $t1, $t1, 1 # i++
			j for_loop_2
		
		increment_for_loop_2:
			addi $t1, $t1, 1
			j for_loop_2
			
		exit_for_loop_2:
			beq $t4, $t0, exit_if_cond # iMin == j --> FAIL, exit if condition
			
			addi $sp, $sp, -4 # Allocate stack
			sw $ra, 0($sp) # store return address
			
			addi $a0, $t3, 0 # args0 --> int[]a address
			addi $a1, $t0, 0 # args1 --> j
			add $a2, $t4, 0 # args2 --> iMin
			jal swap # swap(a, j, iMin)
			
			lw $ra, 0($sp) # pop return address
			addi $sp, $sp, 4 # De-allocate stack
			
			addi $s0, $s0, 1 # swapCount++
			addi $t0, $t0, 1 # j++ 
			j for_loop_1
			
		exit_if_cond:
			addi $t0, $t0, 1 # j++
			j for_loop_1
		
	return_swap_count:
		jr $ra # return address
