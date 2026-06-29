#include <float.h>
#include <math.h>
#include "stdint.h"

#ifndef hang
#define hang while (1) {}
#endif

#ifndef OUTPUT_ADDR
#define OUTPUT_ADDR 0x10000000
#endif

#ifndef DISPLAY_ADDR
#define DISPLAY_ADDR 0x30000000
#endif

#define SCREEN_W        478
#define SCREEN_H        274

//
int __errno = 0;
//
// /* These types are defined with explicit machine modes so
//    their bit widths are precise regardless of the target ABI. */
// typedef      int SItype   __attribute__ ((mode (SI)));   /* signed 32-bit */
// typedef unsigned int USItype __attribute__ ((mode (SI))); /* unsigned 32-bit */
//
// typedef      int DItype   __attribute__ ((mode (DI)));   /* signed 64-bit */
// typedef unsigned int UDItype __attribute__ ((mode (DI))); /* unsigned 64-bit */
//
// typedef int QItype    __attribute__ ((mode (QI)));
// typedef unsigned int UQItype __attribute__ ((mode (QI)));
//
// typedef int HItype    __attribute__ ((mode (HI)));
// typedef unsigned int UHItype __attribute__ ((mode (HI)));
//
//
//
//   /* For 32-bit “word” */
//   #define Wtype   SItype   /* signed 32-bit */
//   #define UWtype  USItype  /* unsigned 32-bit */
//   #define DWtype  DItype   /* signed 64-bit */
//   #define UDWtype UDItype  /* unsigned 64-bit */
//
//
// #if __BYTE_ORDER__ != __ORDER_LITTLE_ENDIAN__
// struct DWstruct { Wtype high, low; };
// #else
// struct DWstruct { Wtype low, high; };
// #endif
//
//
// #if __riscv_xlen == 32
// /* Our RV64 64-bit routines are equivalent to our RV32 32-bit routines.  */
// # define __multi3 __muldi3
// #endif

//
//
// /* This union lets us pack/unpack a double-word integer. */
// typedef union {
//     struct DWstruct s;  /* access by words */
//     DWtype         ll;  /* access as a single double-word integer */
// } DWunion;
//
// unsigned int __mulsi3 (unsigned int a, unsigned int b)
// {
//     unsigned int r = 0;
//
//     while (a)
//     {
//         if (a & 1)
//             r += b;
//         a >>= 1;
//         b <<= 1;
//     }
//     return r;
// }
//
// DWtype
// __multi3 (DWtype u, DWtype v)
// {
//     volatile uint32_t *out = (volatile uint32_t *) OUTPUT_ADDR;
//
//     const DWunion uu = {.ll = u};
//     const DWunion vv = {.ll = v};
//     DWunion w;
//     UWtype u_low = uu.s.low;
//     UWtype v_low = vv.s.low;
//     UWtype u_low_msb;
//     UWtype w_low = 0;
//     UWtype new_w_low;
//     UWtype w_high = 0;
//     UWtype w_high_tmp = 0;
//     UWtype w_high_tmp2x;
//     UWtype carry;
//
//     /* Calculate low half part of u and v, and get a UDWtype result just like
//        what __umulsidi3 do.  */
//     do
//     {
//         new_w_low = w_low + u_low;
//         w_high_tmp2x = w_high_tmp << 1;
//         w_high_tmp += w_high;
//         if (v_low & 1)
//         {
//             carry = new_w_low < w_low;
//             w_low = new_w_low;
//             w_high = carry + w_high_tmp;
//         }
//         u_low_msb = (u_low >> ((sizeof (UWtype) * 8) - 1));
//         v_low >>= 1;
//         u_low <<= 1;
//         w_high_tmp = u_low_msb | w_high_tmp2x;
//         *(out+0)=u_low_msb;
//         *(out+1)=u_low;
//     } while (v_low);
//
//     w.s.low = w_low;
//     w.s.high = w_high;
//
//     if (uu.s.high)
//         w.s.high = w.s.high + __mulsi3(vv.s.low, uu.s.high);
//
//     if (vv.s.high)
//         w.s.high += __mulsi3(uu.s.low, vv.s.high);
//
//     return w.ll;
// }
//
// double trunc(double x)
// {
//     if (x > 0.0)
//         return (double)(long long)x;
//     else
//         return (double)(long long)x;
// }
//
// double fmod(double x, double y) {
//     return x - trunc(x / y) * y;
// }
//


void p(int n) {
    volatile uint32_t *out = (volatile uint32_t *) OUTPUT_ADDR;

    out[1] = n;
}

static int mod_pow(int base, int exp, int mod) {
    long long result = 1;
    long long b = base % mod;

    while (exp > 0) {
        if (exp & 1)
            result = (result * b) % mod;
        b = (b * b) % mod;
        exp >>= 1;
    }
    return (int) result;
}

double term(int N, int n) {
    return pow(16.0, (double) (N - 1 - n)) *
           (4.0 / (8.0 * n + 1.0)
            - 2.0 / (8.0 * n + 4.0)
            - 1.0 / (8.0 * n + 5.0)
            - 1.0 / (8.0 * n + 6.0));
}

int hexdigit(int N) {
    double s = 0.0;

    for (int n = 0; n < N; n++) {
        s += 4.0 * mod_pow(16, N - n - 1, 8 * n + 1) / (8.0 * n + 1.0);
        s -= 2.0 * mod_pow(16, N - n - 1, 8 * n + 4) / (8.0 * n + 4.0);
        s -= mod_pow(16, N - n - 1, 8 * n + 5) / (8.0 * n + 5.0);
        s -= mod_pow(16, N - n - 1, 8 * n + 6) / (8.0 * n + 6.0);

        s = s - floor(s); /* s %= 1 */
    }

    int n = N + 1;
    while (1) {
        double t = term(N, n);
        s += t;
        n++;
        if (fabs(t) < DBL_EPSILON)
            break;
    }

    double frac = s - floor(s);
    return (int) floor(16.0 * frac);
}

//
int cnt = 0;
//


// volatile int mem[256 * 5];

//0-display
//1-led
//2-buttons(3)
//3-switch
//4-vram buffer select
int prevVbuf = 0;

void swapVbuf() {
    volatile uint32_t *out = (volatile uint32_t *) OUTPUT_ADDR;
    out[4] = !prevVbuf;
    prevVbuf = !prevVbuf;
}

void delay(int delay) {
    for (int i = 0; i < delay; i += 1) {
    }
}

void demoBounce(void);

void setPixel(int x, int y, int value);

int main(void) {
//    swapVbuf();
//    swapVbuf();
//    // Output buffer (adjust size as needed)
    volatile uint32_t *out = (volatile uint32_t *) OUTPUT_ADDR;
    volatile uint32_t *outDisp = (volatile uint32_t *) DISPLAY_ADDR;
//    out[0] = 0;
//    out[0] = 0xabababab;
//    // delay(1000000);
//    out[0] = 0;
//    out[0] = 0xabababab;
//
//    int o = 0;
//    int i = 0;
//
//    while (1) {
//        o = (o << 4) | (hexdigit(i) & 0xf);
//
//        out[0] = o;
//        i++;
//    }




    out[0] = 0;
    for (int i = 0; i <= ((480 * 271) / 32); i += 1) {
        outDisp[i] = 0xffffffff;
    }
    swapVbuf();
    delay(1000000);
    out[0] = 1;
    for (int i = 0; i <= ((480 * 271) / 32); i += 1) {
        outDisp[i] = 0;
    }
    swapVbuf();
    delay(1000000);
    out[0] = 2;
    for (int i = 0; i <= ((480 * 271) / 32); i += 1) {
        outDisp[i] = 0;
    }
    for (int i = 0; i <= 20; i += 1) {
        setPixel(20, i + 20, 1);
        setPixel(i + 20, 20, 1);
    }
    swapVbuf();
    delay(1000000);

    out[0] = 3;
    for (int i = 0; i <= ((480 * 271) / 32); i += 1) {
        outDisp[i] = 0xffffffff;
    }
    swapVbuf();
    delay(1000000);
    out[0] = 4;


    demoBounce();


    //*/
    /*

    int i = 0;
    while (true) {
        out[0] = i;
        out[1] = i / 100;
        i++;
    }
*/
    // */
    hang;
}


static void clearVBuf() {
    volatile uint32_t *outDisp = (volatile uint32_t *) DISPLAY_ADDR;
    outDisp[0] = 0;
    for (int i = 0; i < (SCREEN_W * SCREEN_H) / 32; i++)
        outDisp[i] = 0;
}


void setPixel(int x, int y, int value) {
    volatile uint32_t *outDisp = (volatile uint32_t *) DISPLAY_ADDR;
    int bit_index = y * SCREEN_W + x;
    int word_index = bit_index / 32;
    int bit_pos = bit_index % 32;

    if (value) {
        outDisp[word_index] |= (1UL << bit_pos);
    } else {
        outDisp[word_index] &= ~(1UL << bit_pos);
    }
}


static void drawSquare(int x, int y, int size) {
    for (int j = 0; j < size; j++)
        for (int i = 0; i < size; i++)
            setPixel(x + i, y + j, 1);
}

void demoBounce(void) {
    volatile uint32_t *out = (volatile uint32_t *) OUTPUT_ADDR;

    int sqSize = 32;
    int x = 50, y = 50;
    int dx = 2, dy = 2;
    int cnt = 0;


    while (1) {
        out[1] = out[3];
        clearVBuf();
        drawSquare(x, y, sqSize);

        if (dx < 0) {
            dx = -(out[3] & 0xf);
        } else {
            dx = out[3] & 0xf;
        }
        if (dy < 0) {
            dy = -((out[3] & 0xf0) >> 4);
        } else {
            dy = (out[3] & 0xf0) >> 4;
        }


        // Move square
        x += dx;
        y += dy;
        // Bounce on edges
        if (x <= 0 || x + sqSize >= SCREEN_W) {
            dx = -dx;
            cnt++;
            if (x < 0) {
                x = 0;
            }
            if (x + sqSize >= SCREEN_W) {
                x = SCREEN_W - sqSize;
            }
        }


        if (y <= 0 || y + sqSize >= SCREEN_H) {
            dy = -dy;
            cnt++;
            if (y < 0) {
                y = 0;
            }
            if (y + sqSize >= SCREEN_H) {
                y = SCREEN_H - sqSize;
            }
        }
        volatile uint32_t *out = (volatile uint32_t *) OUTPUT_ADDR;
        out[0] = cnt;

        swapVbuf();
        delay(100000);
    }
}
