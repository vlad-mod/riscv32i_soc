TARGET := riscv.elf
OBJS := src/main.o startup.o
# lib/fp-mul32.o lib/fp-add32.o lib/fp-sub32.o lib/fp-precision.o

#TOOLCHAIN = /opt/riscv/bin/riscv32-unknown-elf-
TOOLCHAIN :=/home/vm/.local/xPacks/@xpack-dev-tools/riscv-none-elf-gcc/15.2.0-1.1/.content/bin/riscv-none-elf-
COMMON_FLAGS= -march=rv32i \
 				-mabi=ilp32



CC := $(TOOLCHAIN)gcc
CC_FLAGS :=  $(COMMON_FLAGS) \
 			-Werror  \
 			-march=rv32i \
 			-mabi=ilp32 \
 			-ffreestanding  \
 			-nostartfiles \
 			-nostdlib \
 			-fno-builtin \
 			-fomit-frame-pointer -fno-exceptions -fno-asynchronous-unwind-tables -fno-unwind-tables \
 			-fno-common

AS := $(TOOLCHAIN)as
AS_FLAGS :=    $(COMMON_FLAGS)

LD_FLAGS :=  -T linker.ld -Og -march=rv32i -mabi=ilp32 -nostdlib -static
LD_LIBS := -lgcc  -lm -lgcc
OC := $(TOOLCHAIN)objcopy

all: $(TARGET)
$(TARGET):	$(OBJS)
	$(CC) $(LD_FLAGS)  $^ $(LD_LIBS)  -o $@
	$(OC)  -dr -O binary $(TARGET) riscv.bin
	$(OC) -I binary -O verilog --verilog-data-width 4 ./riscv.bin ./program.hex
	cp ./program.hex ./../SOC


%.o:	%.s
	$(AS)  $(AS_FLAGS) -o $@ -c $<

%.o:	%.c
	$(CC)  $(CC_FLAGS) -o $@ -c $<

clean:
	rm -f *.o $(TARGET)
	rm -f */*.o $(TARGET)
