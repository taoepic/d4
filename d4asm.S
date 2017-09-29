.section .data
norm_mtx4:
	.float 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1
norm_mtx3:
	.float 1, 0, 0, 0, 1, 0, 0, 0, 1

.section .bss
	.align 16
	.comm _vec4_i1, 4*4
	.comm _mat4_i1, 16*4

.macro swap_idx idx0, idx1
	movl \idx0*4(%r9), %eax
	movl \idx1*4(%r9), %ecx
	movl %ecx, \idx0*4(%r9)
	movl %eax, \idx1*4(%r9)
.endm

.macro copy_idx idx0, idx1
	movl \idx0*4(%rdi), %eax
	movl %eax, \idx1*4(%rsi)
.endm

.section .text
	.global mat4_normal
mat4_normal:
	movq $norm_mtx4, %rax
	ret

	.global mat3_normal
mat3_normal:
	movq $norm_mtx3, %rax
	ret

	.global has_avx
has_avx:
	push %rbp
	push %rcx
	movq %rsp, %rbp
	movl $1, %eax
	cpuid
	testl $0x10000000, %ecx
	jz _no_avx
	movq $1, %rax
	jmp _leave_has_avx
_no_avx:
	xorq %rax, %rax
_leave_has_avx:
	pop %rcx
	pop %rbp
	ret

	.global vec4_dot_vec4
vec4_dot_vec4:
	movaps (%rdi), %xmm0
	mulps (%rsi), %xmm0
	movaps %xmm0, (%rdx)
	ret

	.global vec4_plus_vec4
vec4_plus_vec4:
	movaps (%rdi), %xmm0
	addps (%rsi), %xmm0
	movaps %xmm0, (%rdx)
	ret
	
	.global vec3_dot_vec3
vec3_dot_vec3:
	push %rcx
	movaps (%rdi), %xmm0
	movaps (%rsi), %xmm1
	mulps %xmm1, %xmm0
	movq $_vec4_i1, %rsi
	movaps %xmm0, (%rsi)
	movq %rdx, %rdi
	cld
	movl $3, %ecx
	rep movsd
	pop %rcx
	ret

	.global vec3_plus_vec3
vec3_plus_vec3:
	push %rcx
	movaps (%rdi), %xmm0
	movaps (%rsi), %xmm1
	addps %xmm1, %xmm0
	movq $_vec4_i1, %rsi
	movaps %xmm0, (%rsi)
	movq %rdx, %rdi
	cld
	movl $3, %ecx
	rep movsd
	pop %rcx
	ret

	.global mat4_transverse
mat4_transverse:
	copy_idx 0, 0
	copy_idx 1, 4
	copy_idx 2, 8
	copy_idx 3, 12
	copy_idx 4, 1
	copy_idx 5, 5
	copy_idx 6, 9
	copy_idx 7, 13
	copy_idx 8, 2
	copy_idx 9, 6
	copy_idx 10, 10
	copy_idx 11, 14
	copy_idx 12, 3
	copy_idx 13, 7
	copy_idx 14, 11
	copy_idx 15, 15
	ret

	.global mat4_transverse_inplace
mat4_transverse_inplace:
	movq %rdi, %r9
	swap_idx 1, 4
	swap_idx 2, 8
	swap_idx 3, 12
	swap_idx 6, 9 
	swap_idx 7, 13
	swap_idx 11, 14
	ret

	.global vec4_multiply_mat4
vec4_multiply_mat4:
	movss (%rdi), %xmm0
	shufps $0, %xmm0, %xmm0			# m0, m0, m0, m0
	movaps (%rsi), %xmm4			# n0, n1, n2, n3
	movss 4(%rdi), %xmm1
	shufps $0, %xmm1, %xmm1			# m1, m1, m1, m1
	movaps 16(%rsi), %xmm5			# n4, n5, n6, n7
	movss 8(%rdi), %xmm2
	shufps $0, %xmm2, %xmm2			# m2, m2, m2, m2
	movaps 32(%rsi), %xmm6 			# n8, n9, n10, n11
	movss 12(%rdi), %xmm3
	shufps $0, %xmm3, %xmm3			# m3, m3, m3, m3
	movaps 48(%rsi), %xmm7			# n12, n13, n14, n15	
	mulps %xmm4, %xmm0
	mulps %xmm5, %xmm1
	mulps %xmm6, %xmm2
	mulps %xmm7, %xmm3
	addps %xmm0, %xmm1
	addps %xmm1, %xmm2
	addps %xmm2, %xmm3
	movaps %xmm3, (%rdx)
	ret

	.global mat4_multiply_mat4
mat4_multiply_mat4:
# d0, d1, d2, d3
	movss (%rdi), %xmm0
	shufps $0, %xmm0, %xmm0			# m0, m0, m0, m0
	movaps (%rsi), %xmm4			# n0, n1, n2, n3
	movss 4(%rdi), %xmm1
	shufps $0, %xmm1, %xmm1			# m1, m1, m1, m1
	movaps 16(%rsi), %xmm5			# n4, n5, n6, n7
	movss 8(%rdi), %xmm2
	shufps $0, %xmm2, %xmm2			# m2, m2, m2, m2
	movaps 32(%rsi), %xmm6 			# n8, n9, n10, n11
	movss 12(%rdi), %xmm3
	shufps $0, %xmm3, %xmm3			# m3, m3, m3, m3
	movaps 48(%rsi), %xmm7			# n12, n13, n14, n15	
	mulps %xmm4, %xmm0
	mulps %xmm5, %xmm1
	mulps %xmm6, %xmm2
	mulps %xmm7, %xmm3
	addps %xmm0, %xmm1
	addps %xmm1, %xmm2
	addps %xmm2, %xmm3
	movaps %xmm3, (%rdx)

# d4, d5, d6, d7
	movss 16(%rdi), %xmm0
	shufps $0, %xmm0, %xmm0			# m4, m4, m4, m4
	movss 20(%rdi), %xmm1
	shufps $0, %xmm1, %xmm1			# m5, m5, m5, m5
	movss 24(%rdi), %xmm2
	shufps $0, %xmm2, %xmm2			# m6, m6, m6, m6
	movss 28(%rdi), %xmm3
	shufps $0, %xmm3, %xmm3			# m7, m7, m7, m7
	mulps %xmm4, %xmm0
	mulps %xmm5, %xmm1
	mulps %xmm6, %xmm2
	mulps %xmm7, %xmm3
	addps %xmm0, %xmm1
	addps %xmm1, %xmm2
	addps %xmm2, %xmm3
	movaps %xmm3, 16(%rdx)

# d8, d9, d10, d11
	movss 32(%rdi), %xmm0
	shufps $0, %xmm0, %xmm0			# m8, m8, m8, m8
	movss 36(%rdi), %xmm1
	shufps $0, %xmm1, %xmm1			# m9, m9, m9, m9
	movss 40(%rdi), %xmm2
	shufps $0, %xmm2, %xmm2			# m10, m10, m10, m10
	movss 44(%rdi), %xmm3
	shufps $0, %xmm3, %xmm3			# m11, m11, m11, m11
	mulps %xmm4, %xmm0
	mulps %xmm5, %xmm1
	mulps %xmm6, %xmm2
	mulps %xmm7, %xmm3
	addps %xmm0, %xmm1
	addps %xmm1, %xmm2
	addps %xmm2, %xmm3
	movaps %xmm3, 32(%rdx)

# d12, d13, d14, d15
	movss 48(%rdi), %xmm0
	shufps $0, %xmm0, %xmm0			# m12, m12, m12, m12
	movss 52(%rdi), %xmm1
	shufps $0, %xmm1, %xmm1			# m13, m13, m13, m13
	movss 56(%rdi), %xmm2
	shufps $0, %xmm2, %xmm2			# m14, m14, m14, m14
	movss 60(%rdi), %xmm3
	shufps $0, %xmm3, %xmm3			# m15, m15, m15, m15
	mulps %xmm4, %xmm0
	mulps %xmm5, %xmm1
	mulps %xmm6, %xmm2
	mulps %xmm7, %xmm3
	addps %xmm0, %xmm1
	addps %xmm1, %xmm2
	addps %xmm2, %xmm3
	movaps %xmm3, 48(%rdx)

	ret

