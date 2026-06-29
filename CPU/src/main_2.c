//
// Created by vm on 25.16.12.
//
#include <stdio.h>


#define OUTPUT_ADDR arr
#define hang
int arr[1000];

#define main main_2
#include "./main.c"
#undef main


int main() {
main_2();
    for (int i =0;i<55;i++) {
        printf("%x ", arr[i]);
    }
}