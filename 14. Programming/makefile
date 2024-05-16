CC=C:/MIET/6/riscv_cc/bin/riscv-none-elf
RVFLAGS=-march=rv32i_zicsr -mabi=ilp32
EXTFLAGS=-Wl,--gc-sections -nostartfiles
TFLAGS=-T linker_script.ld
VERILOG=verilog --verilog-data-width=4
OBJECTS=$(OUTPUT)/main.o $(OUTPUT)/startup.o
OUTPUT=output

TARGET=programms/main18.c

all: init disasm

init: result.elf
	$(CC)-objcopy -O $(VERILOG) -j .text $(OUTPUT)/result.elf $(OUTPUT)/init_instr.mem
	$(CC)-objcopy -O $(VERILOG) -j .data -j .bss -j .sdata $(OUTPUT)/result.elf $(OUTPUT)/init_data.mem

disasm: result.elf
	$(CC)-objdump -d $(OUTPUT)/result.elf > $(OUTPUT)/disasmed_result.S

result.elf: startup.o main.o
	$(CC)-gcc $(RVFLAGS) $(EXTFLAGS) $(TFLAGS) $(OBJECTS) -o $(OUTPUT)/result.elf

startup.o: startup.S
	$(CC)-gcc -c $(RVFLAGS) startup.S -o $(OUTPUT)/startup.o

main.o: $(TARGET)
	$(CC)-gcc -c $(RVFLAGS) $(TARGET) -o $(OUTPUT)/main.o

clean:
	del /s /q $(OUTPUT)
