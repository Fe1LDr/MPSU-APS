#include "platform.h"

#define SCREEN_WIDTH  80
#define SCREEN_HEIGHT 30

#define FRONT_COLOR 15
#define BACK_COLOR 0

#define MAX_WAIT_CYCLES 10000

uint32_t get_scan_code();
uint32_t get_number(uint32_t *row, uint32_t *col);
uint32_t ascii_code(uint32_t scan_code);
uint32_t count_ocur(uint32_t sw_i, uint32_t number);
void draw_hello(uint32_t *row, uint32_t *col);
void draw_swi(uint32_t *row, uint32_t *col);
void draw_a(uint32_t *row, uint32_t *col);
void draw_result(uint32_t *row, uint32_t *col);
void draw(uint32_t *row, uint32_t *col, char c);
void clear();
void int_handler();

int main(int argc, char** argv)
{
    uint32_t row = 0;
    uint32_t col = 0;
    uint32_t sw_i = 0;
    uint32_t a = 0;
    uint32_t answer = 0;
    clear();
    draw_hello(&row, &col); row++; col = 0;
    while (1) {
        draw_swi(&row, &col);
        sw_i = get_number(&row, &col); row++; col = 0;
        draw_a(&row, &col);
        a = get_number(&row, &col); row++; col = 0;
        draw_result(&row, &col);
        answer = count_ocur(sw_i, a);
        draw(&row, &col, '0' + answer);
    }
}

uint32_t get_scan_code() {
    uint32_t wait_cycles = 0;
    while (!ps2_ptr->unread_data && wait_cycles < MAX_WAIT_CYCLES) {
        wait_cycles++;
    }
    if (ps2_ptr->unread_data) {
        return ps2_ptr->scan_code;
    } else {
        return 0;
    }
}

#if 0
uint32_t get_number(uint32_t *row, uint32_t *col) {
    uint32_t number = 0;
    uint32_t temp = 0;
    uint32_t scan_code = get_scan_code();
    while (scan_code != 0x5A) {
        draw(row, col, temp);
        number = number * 10 + temp;
        scan_code = get_scan_code();
    }
    return number;
}
#endif

#if 1
uint32_t get_number(uint32_t *row, uint32_t *col) {
    uint32_t number = 0;
    uint32_t temp = 0;
    uint32_t scan_code = get_scan_code();
    while (scan_code != 0x5A) {
        temp = ascii_code(scan_code);
        if (temp != 10) {
            draw(row, col, '0' + temp);
            number = number * 10 + temp;
        }
        scan_code = get_scan_code();
        scan_code = get_scan_code();
        scan_code = get_scan_code();
    }
    return number;
}
#endif

uint32_t ascii_code(uint32_t scan_code) {
    if (scan_code == 0x15) return 0; // 0x45 Q
    if (scan_code == 0x1D) return 1; // 0x16 W
    if (scan_code == 0x24) return 2; // 0x1E E
    if (scan_code == 0x2D) return 3; // 0x26 R
    if (scan_code == 0x2C) return 4; // 0x25 T
    if (scan_code == 0x35) return 5; // 0x2E Y
    if (scan_code == 0x3C) return 6; // 0x36 U
    if (scan_code == 0x43) return 7; // 0x3D I
    if (scan_code == 0x44) return 8; // 0x3E O
    if (scan_code == 0x4D) return 9; // 0x46 P
    return 10;
}

uint32_t count_ocur(uint32_t sw_i, uint32_t number) {
    uint32_t a = number % 8;
    uint32_t count = 0;

    uint32_t i = 0;
    uint32_t end = 29;
    while (i < end) {
        if (((sw_i << (end - i)) >> end) == a) {
            count += 1;
            i += 2;
        }
        i += 1;
    }
    return count;
}

void draw_hello(uint32_t *row, uint32_t *col) {
    draw(row, col, 72);
    draw(row, col, 101);
    draw(row, col, 108);
    draw(row, col, 108);
    draw(row, col, 111);
}

void draw_swi(uint32_t *row, uint32_t *col) {
    draw(row, col, 83);
    draw(row, col, 119);
    draw(row, col, 95);
    draw(row, col, 105);
    draw(row, col, 58);
    draw(row, col, 32);
}

void draw_a(uint32_t *row, uint32_t *col) {
    draw(row, col, 65);
    draw(row, col, 58);
    draw(row, col, 32);
}

void draw_result(uint32_t *row, uint32_t *col) {
    draw(row, col, 82);
    draw(row, col, 101);
    draw(row, col, 115);
    draw(row, col, 117);
    draw(row, col, 108);
    draw(row, col, 116);
    draw(row, col, 58);
    draw(row, col, 32);
}

void draw(uint32_t *row, uint32_t *col, char c) {
    uint32_t addr = ((*row * SCREEN_WIDTH) + *col) * sizeof(char);
    *(char_map + addr) = c;
    uint32_t color = (FRONT_COLOR << 4) | BACK_COLOR;
    *(color_map + addr) = color;
    if (*col + 1 == SCREEN_WIDTH) {
        *col = 0;
        *row += 1;
    }
    else *col += 1;
    if (*row + 1 == SCREEN_HEIGHT) {
        *row = 0;
        *col = 0;
    }
}

void clear() {
    for (uint32_t i = 0; i < SCREEN_WIDTH * SCREEN_HEIGHT; i++) {
        *(char_map + i) = 0;
        *(color_map + i) = 0;
    }
}

void int_handler()
{

}