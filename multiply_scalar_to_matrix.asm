; ==========================
; Group member 01: Amadeus_Fidos_u22526162
; Group member 02: Saskia_Steyn_u17267162
; Group member 03: Name_Surname_student-nr
; ==========================

; zero check edge case ignored
segment .text
        global multiplyScalarToMatrix

multiplyScalarToMatrix:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32            ; Allocate space on the stack
        mov     [rbp-24], rdi      ; Save the matrix pointer to the stack
        ;movss   xmm0, xmm1  ; Load the scalar into xmm0
        mov     dword [rbp-36], edx; Save the number of rows to the stack
        mov     dword [rbp-40], ecx; Save the number of columns to the stack
        mov     dword [rbp-8], 0   ; Initialize the row index to 0

        jmp     check_rows_loop   ; Jump to the outer loop condition check

loop_matrix_rows:
        mov     dword [rbp-12], 0  ; Initialize the column index to 0
        jmp     check_cols_loop   ; Jump to the inner loop condition check

loop_matrix_cols:
        mov     eax, dword [rbp-8] ; Load the row index
        cdqe                       ; Convert eax to rax
        lea     rdx, [rax*8]       ; Calculate the offset for the row
        mov     rax, [rbp-24]      ; Load the base address of the first matrix
        add     rax, rdx           ; Add the row offset
        mov     rax, [rax]         ; Load the address of the row
        mov     edx, dword [rbp-12]; Load the column index
        shl     rdx, 2             ; Multiply the column index by 4 (size of a float)
        add     rax, rdx           ; Add the column offset
        movss   xmm1, dword [rax]  ; Load the matrix element into xmm1 - segmentation fault

        MULSS   xmm0, xmm1         ; Multiply the elements in xmm0 and xmm1
        movss   dword [rbp-4], xmm0; Store the updated result

        add     dword [rbp-12], 1  ; Increment the column index

check_cols_loop:
        mov     eax, dword [rbp-12]; Load the column index
        cmp     eax, dword [rbp-40]; Compare the column index with the number of columns
        jl      loop_matrix_cols  ; Jump to inner_loop_start if the column index is less than the number of columns
        add     dword [rbp-8], 1   ; Increment the row index

check_rows_loop:
        mov     eax, dword [rbp-8] ; Load the row index
        cmp     eax, dword [rbp-36]; Compare the row index with the number of rows
        jl      loop_matrix_rows   ; Jump to outer_loop_start if the row index is less than the number of rows
        leave
        ret                        ; Return from the function