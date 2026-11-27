ORG 0
BITS 16

start:
  cli

  MOV ax, 0x7c0
  MOV ds, ax
  MOV es, ax

  MOV ax, 0

  MOV ss, ax
  MOV sp, 0x7c00

  sti

  MOV si, message
  CALL print

  JMP $

print:
  MOV bx, 0

  .loop:
    LODSB

    CMP al, 0
    JE .done
    CALL print_char
    JMP .loop

  .done:
    RET

print_char:
  MOV ah, 0Eh
  INT 0x10

  RET

message: db 'Hello world', 0

TIMES 510 - ($ - $$) DB 0
DW 0xAA55

