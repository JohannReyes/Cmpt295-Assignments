#
# Filename: matrix.s
# Purpose: Rotates a 2D matrix 90 degrees clockwise using transpose and column reverse
# Date: March 11, 2022
# Name: Johann Reyes
# Student #: 301443359
#
	.globl	copy
copy:
# A in rdi, C in rsi, N in edx
	xorl %eax, %eax			# set eax to 0
# since this function is a leaf function, no need to save caller-saved registers rcx and r8
	xorl %ecx, %ecx			# row number i is in ecx -> i = 0

# For each row
rowLoop:
	movl $0, %r8d			# column number j in r8d -> j = 0
	cmpl %edx, %ecx			# loop as long as i - N < 0
	jge doneWithRows

# For each cell of this row
colLoop:
	cmpl %edx, %r8d			# loop as long as j - N < 0
	jge doneWithCells

# Compute the address of current cell that is copied from A to C
# since this function is a leaf function, no need to save caller-saved registers r10 and r11
	movl %edx, %r10d        # r10d = N 
    imull %ecx, %r10d		# r10d = i*N
	addl %r8d, %r10d        # j + i*N
	imull $1, %r10d         # r10 = L * (j + i*N) -> L is char (1Byte)
	movq %r10, %r11			# r11 = L * (j + i*N) 
	addq %rdi, %r10			# r10 = A + L * (j + i*N)
	addq %rsi, %r11			# r11 = C + L * (j + i*N)

# Copy A[L * (j + i*N)] to C[L * (j + i*N)]
	movb (%r10), %r9b       # temp = A[L * (j + i*N)]
	movb %r9b, (%r11)       # C[L * (j + i*N)] = temp

	incl %r8d				# column number j++ (in r8d)
	jmp colLoop				# go to next cell

# Go to next row
doneWithCells:
	incl %ecx				# row number i++ (in ecx)
	jmp rowLoop				# Play it again, Sam!

doneWithRows:				# bye! bye!
	ret

#####################
	.globl	transpose
transpose:
# C in rdi, N in esi
	xorl %eax, %eax		# result = 0
	xorl %ecx, %ecx		# row forloop counter i = 0

# For each row
transposeRowLoop:
	movl %ecx, %r8d		# column forloop counter j = i
	addl $1, %r8d			# column forloop counter j = i + 1
	cmpl %esi, %ecx		# row forloop condition: i < N
	jge doneWithTransRows		# if condition is false, end and return

# For each cell of this row
transposeColLoop:
	cmpl %esi, %r8d		# column forloop condition: j < N
	jge doneWithTransCells		# if condition is false, end and go to next row

# Compute the address of current cell and cell to be switched with
	movl %esi, %r10d        	# r10d = N (first cell)
    	imull %ecx, %r10d		# r10d = i*N
	addl %r8d, %r10d        	# r10d = j + i*N
	imull $1, %r10d         	# r10 = L * (j + i*N) -> L is char (1Byte)
	addq %rdi, %r10		# r10 = C + L * (j + i*N)
	
	movl %esi, %r11d        	# r11d = N (second cell to be swtiched with)
    	imull %r8d, %r11d		# r11d = j*N
	addl %ecx, %r11d        	# r11d = i + j*N
	imull $1, %r11d         	# r11 = L * (i + j*N) -> L is char (1Byte)
	addq %rdi, %r11		# r11 = C + L * (i + j*N)

# Swtich C[L * (j + i*N)] with C[L * (i + j*N)] for transpose
	movb (%r10), %r9b       	# temp1 = C[L * (j + i*N)]
	movb (%r11), %r12b       	# temp2 = C[L * (i + j*N)]
	movb %r9b, (%r11)       	# C[L * (i + j*N)] = temp1
	movb %r12b, (%r10)		# C[L * (j + i*N)] = temp2

	incl %r8d			# increment column counter j++ 
	jmp transposeColLoop		# go to next cell on current row

# Go to next row
doneWithTransCells:
	incl %ecx			# increment row counter i++ 
	jmp transposeRowLoop		# Go down to next row

doneWithTransRows:			# return result = transpose(C)
	ret

#####################
	.globl	reverseColumns
reverseColumns:
# C in rdi, N in esi
	xorl %eax, %eax		# result = 0
	xorl %ecx, %ecx		# row forloop counter i = 0

# For each row
RevsColmRowLoop:
	movl $0, %r8d			# column forloop counter j = 0
	movl %esi, %r13d		# new colm forloop condition bound = N
	sarl $1, %r13d			# new colm forloop condition bound = N/2
	cmpl %esi, %ecx		# row forloop condition: i < N
	jge doneWithRevsRows		# if condition is false, end and return

# For each cell of this row
RevsColmColLoop:
	cmpl %r13d, %r8d		# column forloop condition: j < N/2
	jge doneWithRevsCells		# if condition is false, end and go to next row

# Compute the address of current cell and cell to be switched with
	movl %esi, %r10d        	# r10d = N (first cell)
    	imull %ecx, %r10d		# r10d = i*N
	addl %r8d, %r10d        	# r10d = j + i*N
	imull $1, %r10d         	# r10 = L * (j + i*N) -> L is char (1Byte)
	addq %rdi, %r10		# r10 = C + L * (j + i*N)
	
	movl %ecx, %r11d		# r11d = i (second cell to be swtiched with)
	addl $1, %r11d			# r11d = i + 1
    	imull %esi, %r11d		# r11d = (i+1)*N
	subl %r8d, %r11d        	# r11d = (i+1)*N - j
	subl $1, %r11d			# r11d = (i+1)*N - j - 1
	imull $1, %r11d         	# r11 = L * ((i+1)*N - j - 1) -> L is char (1Byte)
	addq %rdi, %r11		# r11 = C + L * ((i+1)*N - j - 1)

# Swtich C[L * (j + i*N)] with C[L * ((i+1)*N - j - 1)] for transpose
	movb (%r10), %r9b       	# temp1 = C[L * (j + i*N)]
	movb (%r11), %r12b       	# temp2 = C[L * ((i+1)*N - j - 1)] 
	movb %r9b, (%r11)       	# C[L * ((i+1)*N - j - 1)]  = temp1
	movb %r12b, (%r10)		# C[L * (j + i*N)] = temp2

	incl %r8d			# increment column counter j++ 
	jmp RevsColmColLoop		# go to next cell on current row

# Go to next row
doneWithRevsCells:
	incl %ecx			# increment row counter i++ 
	jmp RevsColmRowLoop		# Go down to next row

doneWithRevsRows:			# return result = reverseColumns(C)
	ret
