GLOBAL  main
EXTERN  strncmp
EXTERN  malloc
EXTERN  strcpy
EXTERN  puts
EXTERN  printf
SECTION .bss
QSIZE:  equ 64
QUEUE:  resd QSIZE
SECTION .data
;;          0  1  23  4  56  7  89
P       db "A",0,"AB",0,"BC",0,"CA",0; primitives
OFFSET  dd  0,    2,     5,     8
N       equ ($-OFFSET)/4; number of primitives
LEN     dd  1,    2,     2,     2
S       db "ABACABA",0
SSIZE   equ $-S
FMT     db "Prefix length: %d",10,0
SECTION .text
%macro backup 0
        push rbx
        push rcx
        push r8
        push r9
        push r10
        push r11
        push r12
        push r13
        push r14
        push r15
%endmacro
%macro re_establish 0
        pop r15
        pop r14
        pop r13
        pop r12
        pop r11
        pop r10
        pop r9
        pop r8
        pop rcx
        pop rbx
%endmacro
;; descr: push rax to Q
push:   nop
        mov [rbp+r15*4], eax;
        inc r15;
        cmp r15, QSIZE;
        jnz .Exit;
        mov r15, 0;
.Exit   ret
;; descr: let's go popping
;; outup: rbx
;; notes: thus function conforms to main spec 0.3
pop:    nop
        mov ebx, [rbp+r14*4]; j <- Q[F]
        inc r14;
        ;; ck for overflow
        cmp r14, QSIZE;
        jnz .Exit;  Ok
        mov r14, 0; Reset
.Exit   ret
;; input: registers from main spec
;; outup: rax - 0 on match
;; descr: cks vhether P[i] matches S[j:]
ck:     nop
        backup
        lea rdi, [r13+rbx];   1st: S + j
        mov edx, [r12+rcx*4]; OFFSET[i]
        lea rsi, [r10+rdx];   2nd: P[i]
        mov edx, [r11+rcx*4]; 3rd: LEN[i]
        call strncmp wrt ..plt
        ;; end testing
        re_establish
        ret
;; main spec 0.3
;; r10 - P
;; r12 - OFFSET
;; r11 - LEN
;; r13 - S
;; rcx - P's index (i)
;; rbx - S's index (j)
;; rbp - QUEUE
;; r14 - QUEUE's front
;; r15 - QUEUE's rear
;; r8  - copy of S 
;; r9  - vanguard
main:   nop
;; [initialize]
;; Make a copy of S first, because gcc is trashing
;; the registers.
        mov rdi, SSIZE; 1st
        call malloc wrt ..plt
        mov rdi, rax;     1st
        lea rsi, [rel S]; 2nd
        call strcpy wrt ..plt
        ;; strcpy doesn't change rax, cked!
        mov r8, rax; copy to r8 
;; Set up the other stuff.
        mov r9, -1; r9 will hold the result 
        mov rdx, 0; clear
        mov rbx, 0;
        lea r10, [rel P];
        lea r12, [rel OFFSET];
        lea r11, [rel LEN];
        lea r13, [rel S];
        lea rbp, [rel QUEUE];
        mov r14, 0;
        mov r15, 0;
;; Ok, let's go 
        mov rax, 0;
        call push; start from the begining
Empty:  cmp r14, r15; L = R?
        jz Spit; positive
        call pop;
        ;; ck if visited
        mov al, '*';
        cmp al, [r8+rbx*4];
        jz Empty;
        mov rcx, 0; i <- 0
        ;; vanguard
        cmp r9, rbx; vanguard > j[boom]
        jge Loof; yep
        mov r9, rbx; update
Loof:   cmp rcx, N; i == N[boom]
        jz Mark; yep
        call ck; rax = 0 on match
        cmp rax, 0;
        jnz Inc; nop
        mov rax, rbx;
        add eax, [r11+rcx*4]; next destination
        call push; yep
Inc:    inc rcx; i++
        jmp Loof; follow me
        ;; mark j as visited
Mark:   mov al, '*';
        mov [r8+rbx], al;
        jmp Empty;
Spit:   push r9; copy
        push r8;
        mov rdi, r13; 1st
        call puts wrt ..plt
        pop rdi; 1st
        call puts wrt ..plt
        lea rdi, [rel FMT]; 1st
        pop rsi;            2nd
        mov rax, 0;     varargs
        call printf wrt ..plt
        mov rax, 0; exit code
        nop
        ret
;; log: make -f nasm.mk && ./a.out
