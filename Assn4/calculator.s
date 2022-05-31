# Filename: calculator.s
#
# Purpose: Assignment 4 Question 3
#
# Name: Johann Reyes
#
# Date: Feb 18, 2022

	.globl	isLessThan # changing name to: isLessThan
	.globl	plus
	.globl	minus
	.globl	mul

# x in edi, y in esi

isLessThan: # changing name to: isLessThan
	xorl	%eax, %eax
	cmpl	%esi, %edi
	setl	%al         # See Section 3.6.2 of our textbook for a description of the set* instructions
	ret

plus:  # performs integer addition
	xorl 	%eax, %eax		# int result
	leal	(%edi, %esi), %eax	# result = x + y
	ret				# return result

minus: # performs integer subtraction
	xorl	%eax, %eax		# int result
	negl	%esi			# y = -y
	leal	(%edi, %esi), %eax	# result = x + (-y)
	ret				# return result

# This algorithm for mul simply uses a forloop that will loop y times
# and add x into result y times. *Initialize result = 0
# Ex: x=4, y=3, forloop will run 3 times adding 4 into result three
# times which will then be returned as 4+4+4 = 4*3 = 12
mul: # performs integer multiplication - when both operands are non-negative!
	movl	$0,   %eax		# int result = 0
	movl	$0,   %r8d		# int i = 0 (loop counter)
	jmp	cond
loop:
	leal	(%eax, %edi), %eax	# result = result + x
	incl	%r8d			# i++
cond:
	cmpl	%esi, %r8d		# forloop condition: i<y
	jl	loop			# if condition still holds true, i<y: loop
	
	ret				# return result
# algorithm:
#
#
#
#n
