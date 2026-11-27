ORG 0x7c00
BITS 16

_start:
  JMP SHORT start
  NOP

times 33 db 0

start:
  JMP 0:step2

step2:
  cli

  MOV ax, 0
  MOV ds, ax
  MOV es, ax
  MOV ss, ax
  MOV sp, 0x7c00

  sti
  cld

  MOV [boot_drive], dl

  MOV si, message
  CALL print

  MOV al, 1
  MOV cl, 2
  MOV bx, 0x7e00

  CALL read_sectors

  JMP stage2

; AL = amount of sectors
; CL = initial sector (1-based)
; BX = target address (ES = 0)
read_sectors:
  PUSH ax

  MOV ah, 2
  MOV ch, 0
  MOV dh, 0
  MOV dl, [boot_drive]

  INT 0x13

  POP dx      ; DL = claimed amount
  CMP al, dl  ; AL = read amount

  JNE disk_error

  RET

disk_error:
  MOV si, err_msg
  CALL print
  JMP halt

halt:
  hlt
  JMP halt

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

message: db 'Hello world', 0x0a, 0x0d, 0
err_msg: db 'error while trying to read the disk', 0
boot_drive: db 0

TIMES 510 - ($ - $$) DB 0
DW 0xAA55


; setor 2

stage2:
  MOV si, message_sector_2
  CALL print
  
  .halt:
    hlt
    JMP .halt

message_sector_2: db 'Hello world from stage 2', 0

TIMES 1024 - ($ - $$) DB 0

