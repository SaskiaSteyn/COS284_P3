; ==========================
; Group member 01: Amadeus_Fidos_u22526162
; Group member 02: Saskia_Steyn_u17267162
; Group member 03: Name_Surname_student-nr
; ==========================
segment .text
        global calculateMatrixDotProduct

calculateMatrixDotProduct: ; load matrices
        push    rbp
        mov     rbp, rsp
        mov     [rbp-24], rdi ; save matrix 1
        mov     [rbp-32], rsi ; save matrix 2
        mov     dword [rbp-36], edx
        mov     dword [rbp-40], ecx
        pxor    xmm0, xmm0 ; clear xmm0
        movss   dword [rbp-4], xmm0
        mov     dword [rbp-8], 0
        jmp     check_outer_loop ; start loop

outer_loop_start:
        mov     dword [rbp-12], 0 ; col index = 0
        jmp     check_inner_loop

inner_loop_start:
        mov     eax, dword [rbp-8]
        cdqe
        lea     rdx, [rax*8] ;get offset
        mov     rax, [rbp-24]
        add     rax, rdx
        mov     rax, [rax]
        mov     edx, dword [rbp-12] ; load col index
        mov     rdx, rdx
        shl     rdx, 2
        add     rax, rdx
        movss   xmm1, dword [rax]
        mov     eax, dword [rbp-8] ; row index 
        cdqe
        lea     rdx, [rax*8]
        mov     rax, [rbp-32]
        add     rax, rdx
        mov     rax, [rax]
        mov     edx, dword [rbp-12]
        mov     rdx, rdx
        shl     rdx, 2
        add     rax, rdx
        movss   xmm0, dword [rax] ;load matrix element
        mulss   xmm0, xmm1 ; multiply
        movss   xmm1, dword [rbp-4] ;load current result
        addss   xmm0, xmm1 ; add results
        movss   dword [rbp-4], xmm0 ;store result
        add     dword [rbp-12], 1 ; inc col index

check_inner_loop:
        mov     eax, dword [rbp-12]
        cmp     eax, dword [rbp-40] ; compare index to num cols
        jl      inner_loop_start
        add     dword [rbp-8], 1 ; inc

check_outer_loop:
        mov     eax, dword [rbp-8]
        cmp     eax, dword [rbp-36]
        jl      outer_loop_start
        movss   xmm0, dword [rbp-4]
        pop     rbp ; pop matrices from stack
        ret ; exit