# 
#Filename: calculator.s
# Purpose: Assignment 6 Question 1
# Name: Johann Reyes
# Student #: 301443359
#
# Date: March 11, 2022

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

# This algorithm for mul uses recursion to add x onto itself
# y times. The base case for the recursion checks if y is
# equal to 1. Once it does, it will recurse back and add x
# at each recursive call y times.
mul: # performs integer multiplication - when both operands are non-negative!
	movl 	%edi, %eax		# int result = x
	cmpl	$1, %esi		# if(y <= 1) base case
	jle	done			# base case is true, return result
	pushq	%rbx			# pushing %rbx into stack
	movl	%esi, %ebx		# saving y before changing for next call
	subl	$1, %esi		# y = y - 1, changing y for next call
	call 	mul			# recursive call mul(x, y-1)
	addq	%rdi, %rax		# return x + mul(x, y-1)
	popq	%rbx			# popping %rbx from stack
done:
	ret				# return result 
# algorithm:
# x in edi, y in esi
#
#
#n
