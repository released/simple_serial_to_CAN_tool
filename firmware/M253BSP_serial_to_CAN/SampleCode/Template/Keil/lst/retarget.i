# 1 "../../../Library/StdDriver/src/retarget.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 391 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "../../../Library/StdDriver/src/retarget.c" 2
# 10 "../../../Library/StdDriver/src/retarget.c"
# 1 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 1 3
# 53 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
    typedef unsigned int size_t;
# 68 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
    typedef __builtin_va_list __va_list;
# 87 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
typedef struct __fpos_t_struct {
    unsigned long long int __pos;





    struct {
        unsigned int __state1, __state2;
    } __mbstate;
} fpos_t;
# 108 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
typedef struct __FILE FILE;
# 119 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
struct __FILE {
    union {
        long __FILE_alignment;



        char __FILE_size[84];

    } __FILE_opaque;
};
# 138 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern FILE __stdin, __stdout, __stderr;
extern FILE *__aeabi_stdin, *__aeabi_stdout, *__aeabi_stderr;
# 224 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern __attribute__((__nothrow__)) int remove(const char * ) __attribute__((__nonnull__(1)));







extern __attribute__((__nothrow__)) int rename(const char * , const char * ) __attribute__((__nonnull__(1,2)));
# 243 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern __attribute__((__nothrow__)) FILE *tmpfile(void);






extern __attribute__((__nothrow__)) char *tmpnam(char * );
# 265 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern __attribute__((__nothrow__)) int fclose(FILE * ) __attribute__((__nonnull__(1)));
# 275 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern __attribute__((__nothrow__)) int fflush(FILE * );
# 285 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern __attribute__((__nothrow__)) FILE *fopen(const char * __restrict ,
                           const char * __restrict ) __attribute__((__nonnull__(1,2)));
# 329 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern __attribute__((__nothrow__)) FILE *freopen(const char * __restrict ,
                    const char * __restrict ,
                    FILE * __restrict ) __attribute__((__nonnull__(2,3)));
# 342 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern __attribute__((__nothrow__)) void setbuf(FILE * __restrict ,
                    char * __restrict ) __attribute__((__nonnull__(1)));






extern __attribute__((__nothrow__)) int setvbuf(FILE * __restrict ,
                   char * __restrict ,
                   int , size_t ) __attribute__((__nonnull__(1)));
# 370 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
#pragma __printf_args
extern __attribute__((__nothrow__)) int fprintf(FILE * __restrict ,
                    const char * __restrict , ...) __attribute__((__nonnull__(1,2)));
# 393 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
#pragma __printf_args
extern __attribute__((__nothrow__)) int _fprintf(FILE * __restrict ,
                     const char * __restrict , ...) __attribute__((__nonnull__(1,2)));





#pragma __printf_args
extern __attribute__((__nothrow__)) int printf(const char * __restrict , ...) __attribute__((__nonnull__(1)));






#pragma __printf_args
extern __attribute__((__nothrow__)) int _printf(const char * __restrict , ...) __attribute__((__nonnull__(1)));





#pragma __printf_args
extern __attribute__((__nothrow__)) int sprintf(char * __restrict , const char * __restrict , ...) __attribute__((__nonnull__(1,2)));








#pragma __printf_args
extern __attribute__((__nothrow__)) int _sprintf(char * __restrict , const char * __restrict , ...) __attribute__((__nonnull__(1,2)));






#pragma __printf_args
extern __attribute__((__nothrow__)) int __ARM_snprintf(char * __restrict , size_t ,
                     const char * __restrict , ...) __attribute__((__nonnull__(3)));


#pragma __printf_args
extern __attribute__((__nothrow__)) int snprintf(char * __restrict , size_t ,
                     const char * __restrict , ...) __attribute__((__nonnull__(3)));
# 460 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
#pragma __printf_args
extern __attribute__((__nothrow__)) int _snprintf(char * __restrict , size_t ,
                      const char * __restrict , ...) __attribute__((__nonnull__(3)));





#pragma __scanf_args
extern __attribute__((__nothrow__)) int fscanf(FILE * __restrict ,
                    const char * __restrict , ...) __attribute__((__nonnull__(1,2)));
# 503 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
#pragma __scanf_args
extern __attribute__((__nothrow__)) int _fscanf(FILE * __restrict ,
                     const char * __restrict , ...) __attribute__((__nonnull__(1,2)));





#pragma __scanf_args
extern __attribute__((__nothrow__)) int scanf(const char * __restrict , ...) __attribute__((__nonnull__(1)));








#pragma __scanf_args
extern __attribute__((__nothrow__)) int _scanf(const char * __restrict , ...) __attribute__((__nonnull__(1)));





#pragma __scanf_args
extern __attribute__((__nothrow__)) int sscanf(const char * __restrict ,
                    const char * __restrict , ...) __attribute__((__nonnull__(1,2)));
# 541 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
#pragma __scanf_args
extern __attribute__((__nothrow__)) int _sscanf(const char * __restrict ,
                     const char * __restrict , ...) __attribute__((__nonnull__(1,2)));







extern __attribute__((__nothrow__)) int vfscanf(FILE * __restrict , const char * __restrict , __va_list) __attribute__((__nonnull__(1,2)));
extern __attribute__((__nothrow__)) int vscanf(const char * __restrict , __va_list) __attribute__((__nonnull__(1)));
extern __attribute__((__nothrow__)) int vsscanf(const char * __restrict , const char * __restrict , __va_list) __attribute__((__nonnull__(1,2)));

extern __attribute__((__nothrow__)) int _vfscanf(FILE * __restrict , const char * __restrict , __va_list) __attribute__((__nonnull__(1,2)));
extern __attribute__((__nothrow__)) int _vscanf(const char * __restrict , __va_list) __attribute__((__nonnull__(1)));
extern __attribute__((__nothrow__)) int _vsscanf(const char * __restrict , const char * __restrict , __va_list) __attribute__((__nonnull__(1,2)));
extern __attribute__((__nothrow__)) int __ARM_vsscanf(const char * __restrict , const char * __restrict , __va_list) __attribute__((__nonnull__(1,2)));

extern __attribute__((__nothrow__)) int vprintf(const char * __restrict , __va_list ) __attribute__((__nonnull__(1)));







extern __attribute__((__nothrow__)) int _vprintf(const char * __restrict , __va_list ) __attribute__((__nonnull__(1)));





extern __attribute__((__nothrow__)) int vfprintf(FILE * __restrict ,
                    const char * __restrict , __va_list ) __attribute__((__nonnull__(1,2)));
# 584 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern __attribute__((__nothrow__)) int vsprintf(char * __restrict ,
                     const char * __restrict , __va_list ) __attribute__((__nonnull__(1,2)));
# 594 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern __attribute__((__nothrow__)) int __ARM_vsnprintf(char * __restrict , size_t ,
                     const char * __restrict , __va_list ) __attribute__((__nonnull__(3)));

extern __attribute__((__nothrow__)) int vsnprintf(char * __restrict , size_t ,
                     const char * __restrict , __va_list ) __attribute__((__nonnull__(3)));
# 609 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern __attribute__((__nothrow__)) int _vsprintf(char * __restrict ,
                      const char * __restrict , __va_list ) __attribute__((__nonnull__(1,2)));





extern __attribute__((__nothrow__)) int _vfprintf(FILE * __restrict ,
                     const char * __restrict , __va_list ) __attribute__((__nonnull__(1,2)));





extern __attribute__((__nothrow__)) int _vsnprintf(char * __restrict , size_t ,
                      const char * __restrict , __va_list ) __attribute__((__nonnull__(3)));
# 635 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
#pragma __printf_args
extern __attribute__((__nothrow__)) int __ARM_asprintf(char ** , const char * __restrict , ...) __attribute__((__nonnull__(2)));
extern __attribute__((__nothrow__)) int __ARM_vasprintf(char ** , const char * __restrict , __va_list ) __attribute__((__nonnull__(2)));
# 649 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern __attribute__((__nothrow__)) int fgetc(FILE * ) __attribute__((__nonnull__(1)));
# 659 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern __attribute__((__nothrow__)) char *fgets(char * __restrict , int ,
                    FILE * __restrict ) __attribute__((__nonnull__(1,3)));
# 673 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern __attribute__((__nothrow__)) int fputc(int , FILE * ) __attribute__((__nonnull__(2)));
# 683 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern __attribute__((__nothrow__)) int fputs(const char * __restrict , FILE * __restrict ) __attribute__((__nonnull__(1,2)));






extern __attribute__((__nothrow__)) int getc(FILE * ) __attribute__((__nonnull__(1)));
# 704 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
    extern __attribute__((__nothrow__)) int (getchar)(void);
# 713 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern __attribute__((__nothrow__)) char *gets(char * ) __attribute__((__nonnull__(1)));
# 725 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern __attribute__((__nothrow__)) int putc(int , FILE * ) __attribute__((__nonnull__(2)));
# 737 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
    extern __attribute__((__nothrow__)) int (putchar)(int );






extern __attribute__((__nothrow__)) int puts(const char * ) __attribute__((__nonnull__(1)));







extern __attribute__((__nothrow__)) int ungetc(int , FILE * ) __attribute__((__nonnull__(2)));
# 778 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern __attribute__((__nothrow__)) size_t fread(void * __restrict ,
                    size_t , size_t , FILE * __restrict ) __attribute__((__nonnull__(1,4)));
# 794 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern __attribute__((__nothrow__)) size_t __fread_bytes_avail(void * __restrict ,
                    size_t , FILE * __restrict ) __attribute__((__nonnull__(1,3)));
# 810 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern __attribute__((__nothrow__)) size_t fwrite(const void * __restrict ,
                    size_t , size_t , FILE * __restrict ) __attribute__((__nonnull__(1,4)));
# 822 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern __attribute__((__nothrow__)) int fgetpos(FILE * __restrict , fpos_t * __restrict ) __attribute__((__nonnull__(1,2)));
# 833 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern __attribute__((__nothrow__)) int fseek(FILE * , long int , int ) __attribute__((__nonnull__(1)));
# 850 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern __attribute__((__nothrow__)) int fsetpos(FILE * __restrict , const fpos_t * __restrict ) __attribute__((__nonnull__(1,2)));
# 863 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern __attribute__((__nothrow__)) long int ftell(FILE * ) __attribute__((__nonnull__(1)));
# 877 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern __attribute__((__nothrow__)) void rewind(FILE * ) __attribute__((__nonnull__(1)));
# 886 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern __attribute__((__nothrow__)) void clearerr(FILE * ) __attribute__((__nonnull__(1)));







extern __attribute__((__nothrow__)) int feof(FILE * ) __attribute__((__nonnull__(1)));




extern __attribute__((__nothrow__)) int ferror(FILE * ) __attribute__((__nonnull__(1)));




extern __attribute__((__nothrow__)) void perror(const char * );
# 917 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdio.h" 3
extern __attribute__((__nothrow__)) int _fisatty(FILE * ) __attribute__((__nonnull__(1)));



extern __attribute__((__nothrow__)) void __use_no_semihosting_swi(void);
extern __attribute__((__nothrow__)) void __use_no_semihosting(void);
# 11 "../../../Library/StdDriver/src/retarget.c" 2
# 1 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\NuMicro.h" 1
# 13 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\NuMicro.h"
# 1 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 1
# 76 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h"
typedef enum IRQn
{

    NonMaskableInt_IRQn = -14,
    HardFault_IRQn = -13,
    SVCall_IRQn = -5,
    PendSV_IRQn = -2,
    SysTick_IRQn = -1,


    BOD_IRQn = 0,
    IRCTRIM_IRQn = 1,
    PWRWU_IRQn = 2,
    RESERVE0 = 3,
    CLKFAIL_IRQn = 4,
    RESERVE1 = 5,
    RTC_IRQn = 6,
    RESERVE2 = 7,
    WDT_IRQn = 8,
    WWDT_IRQn = 9,
    EINT0_IRQn = 10,
    EINT1_IRQn = 11,
    EINT2_IRQn = 12,
    EINT3_IRQn = 13,
    EINT4_IRQn = 14,
    EINT5_IRQn = 15,
    GPA_IRQn = 16,
    GPB_IRQn = 17,
    GPC_IRQn = 18,
    GPD_IRQn = 19,
    GPE_IRQn = 20,
    GPF_IRQn = 21,
    RESERVE3 = 22,
    SPI0_IRQn = 23,
    CANFD0_IRQ0_IRQn = 24,
    CANFD0_IRQ1_IRQn = 25,
    RESERVE5 = 26,
    RESERVE6 = 27,
    RESERVE7 = 28,
    RESERVE8 = 29,
    RESERVE9 = 30,
    RESERVE10 = 31,
    TMR0_IRQn = 32,
    TMR1_IRQn = 33,
    TMR2_IRQn = 34,
    TMR3_IRQn = 35,
    UART0_IRQn = 36,
    UART1_IRQn = 37,
    I2C0_IRQn = 38,
    I2C1_IRQn = 39,
    PDMA_IRQn = 40,
    RESERVE11 = 41,
    EADC_INT0_IRQn = 42,
    EADC_INT1_IRQn = 43,
    RESERVE12 = 44,
    BPWM0_IRQn = 45,
    EADC_INT2_IRQn = 46,
    EADC_INT3_IRQn = 47,
    UART2_IRQn = 48,
    UART3_IRQn = 49,
    USCI0_IRQn = 50,
    UART4_IRQn = 51,
    RESERVE14 = 52,
    USBD_IRQn = 53,
    RESERVE15 = 54,
    RESERVE16 = 55,
    RESERVE17 = 56,
    RESERVE18 = 57,
    RESERVE19 = 58,
    RESERVE20 = 59,
    RESERVE21 = 60,
    RESERVE22 = 61,
    RESERVE23 = 62,
    RESERVE24 = 63,
} IRQn_Type;
# 163 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wc11-extensions"
#pragma clang diagnostic ignored "-Wreserved-id-macro"
# 190 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h"
# 1 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdint.h" 1 3
# 56 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\stdint.h" 3
typedef signed char int8_t;
typedef signed short int int16_t;
typedef signed int int32_t;
typedef signed long long int int64_t;


typedef unsigned char uint8_t;
typedef unsigned short int uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long long int uint64_t;





typedef signed char int_least8_t;
typedef signed short int int_least16_t;
typedef signed int int_least32_t;
typedef signed long long int int_least64_t;


typedef unsigned char uint_least8_t;
typedef unsigned short int uint_least16_t;
typedef unsigned int uint_least32_t;
typedef unsigned long long int uint_least64_t;




typedef signed int int_fast8_t;
typedef signed int int_fast16_t;
typedef signed int int_fast32_t;
typedef signed long long int int_fast64_t;


typedef unsigned int uint_fast8_t;
typedef unsigned int uint_fast16_t;
typedef unsigned int uint_fast32_t;
typedef unsigned long long int uint_fast64_t;






typedef signed int intptr_t;
typedef unsigned int uintptr_t;



typedef signed long long intmax_t;
typedef unsigned long long uintmax_t;
# 191 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 1
# 27 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
# 63 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
# 1 "../../../Library/CMSIS/Core/Include\\cmsis_version.h" 1 3
# 27 "../../../Library/CMSIS/Core/Include\\cmsis_version.h" 3
# 64 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 2 3
# 116 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
# 1 "../../../Library/CMSIS/Core/Include\\cmsis_compiler.h" 1 3
# 32 "../../../Library/CMSIS/Core/Include\\cmsis_compiler.h" 3
# 1 "../../../Library/CMSIS/Core/Include\\cmsis_armclang.h" 1 3
# 29 "../../../Library/CMSIS/Core/Include\\cmsis_armclang.h" 3


# 1 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\arm_acle.h" 1 3
# 45 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\arm_acle.h" 3
static __inline__ void __attribute__((__always_inline__, __nodebug__)) __wfi(void) {
  __builtin_arm_wfi();
}



static __inline__ void __attribute__((__always_inline__, __nodebug__)) __wfe(void) {
  __builtin_arm_wfe();
}



static __inline__ void __attribute__((__always_inline__, __nodebug__)) __sev(void) {
  __builtin_arm_sev();
}



static __inline__ void __attribute__((__always_inline__, __nodebug__)) __sevl(void) {
  __builtin_arm_sevl();
}



static __inline__ void __attribute__((__always_inline__, __nodebug__)) __yield(void) {
  __builtin_arm_yield();
}







static __inline__ uint32_t __attribute__((__always_inline__, __nodebug__))
__swp(uint32_t __x, volatile uint32_t *__p) {
  uint32_t v;
  do
    v = __builtin_arm_ldrex(__p);
  while (__builtin_arm_strex(__x, __p));
  return v;
}
# 113 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\arm_acle.h" 3
static __inline__ void __attribute__((__always_inline__, __nodebug__)) __nop(void) {
  __builtin_arm_nop();
}





static __inline__ uint32_t __attribute__((__always_inline__, __nodebug__))
__ror(uint32_t __x, uint32_t __y) {
  __y %= 32;
  if (__y == 0)
    return __x;
  return (__x >> __y) | (__x << (32 - __y));
}

static __inline__ uint64_t __attribute__((__always_inline__, __nodebug__))
__rorll(uint64_t __x, uint32_t __y) {
  __y %= 64;
  if (__y == 0)
    return __x;
  return (__x >> __y) | (__x << (64 - __y));
}

static __inline__ unsigned long __attribute__((__always_inline__, __nodebug__))
__rorl(unsigned long __x, uint32_t __y) {

  return __ror(__x, __y);



}



static __inline__ unsigned int __attribute__((__always_inline__, __nodebug__))
__clz(uint32_t __t) {
  return __builtin_arm_clz(__t);
}

static __inline__ unsigned int __attribute__((__always_inline__, __nodebug__))
__clzl(unsigned long __t) {

  return __builtin_arm_clz(__t);



}

static __inline__ unsigned int __attribute__((__always_inline__, __nodebug__))
__clzll(uint64_t __t) {
  return __builtin_arm_clz64(__t);
}


static __inline__ unsigned int __attribute__((__always_inline__, __nodebug__))
__cls(uint32_t __t) {
  return __builtin_arm_cls(__t);
}

static __inline__ unsigned int __attribute__((__always_inline__, __nodebug__))
__clsl(unsigned long __t) {

  return __builtin_arm_cls(__t);



}

static __inline__ unsigned int __attribute__((__always_inline__, __nodebug__))
__clsll(uint64_t __t) {
  return __builtin_arm_cls64(__t);
}


static __inline__ uint32_t __attribute__((__always_inline__, __nodebug__))
__rev(uint32_t __t) {
  return __builtin_bswap32(__t);
}

static __inline__ unsigned long __attribute__((__always_inline__, __nodebug__))
__revl(unsigned long __t) {

  return __builtin_bswap32(__t);



}

static __inline__ uint64_t __attribute__((__always_inline__, __nodebug__))
__revll(uint64_t __t) {
  return __builtin_bswap64(__t);
}


static __inline__ uint32_t __attribute__((__always_inline__, __nodebug__))
__rev16(uint32_t __t) {
  return __ror(__rev(__t), 16);
}

static __inline__ uint64_t __attribute__((__always_inline__, __nodebug__))
__rev16ll(uint64_t __t) {
  return (((uint64_t)__rev16(__t >> 32)) << 32) | (uint64_t)__rev16((uint32_t)__t);
}

static __inline__ unsigned long __attribute__((__always_inline__, __nodebug__))
__rev16l(unsigned long __t) {

    return __rev16(__t);



}


static __inline__ int16_t __attribute__((__always_inline__, __nodebug__))
__revsh(int16_t __t) {
  return (int16_t)__builtin_bswap16((uint16_t)__t);
}


static __inline__ uint32_t __attribute__((__always_inline__, __nodebug__))
__rbit(uint32_t __t) {
  return __builtin_arm_rbit(__t);
}

static __inline__ uint64_t __attribute__((__always_inline__, __nodebug__))
__rbitll(uint64_t __t) {

  return (((uint64_t)__builtin_arm_rbit(__t)) << 32) |
         __builtin_arm_rbit(__t >> 32);



}

static __inline__ unsigned long __attribute__((__always_inline__, __nodebug__))
__rbitl(unsigned long __t) {

  return __rbit(__t);



}
# 32 "../../../Library/CMSIS/Core/Include\\cmsis_armclang.h" 2 3
# 71 "../../../Library/CMSIS/Core/Include\\cmsis_armclang.h" 3
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpacked"
  struct __attribute__((packed, aligned(1))) T_UINT16_WRITE { uint16_t v; };
#pragma clang diagnostic pop



#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpacked"
  struct __attribute__((packed, aligned(1))) T_UINT16_READ { uint16_t v; };
#pragma clang diagnostic pop



#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpacked"
  struct __attribute__((packed, aligned(1))) T_UINT32_WRITE { uint32_t v; };
#pragma clang diagnostic pop



#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpacked"
  struct __attribute__((packed, aligned(1))) T_UINT32_READ { uint32_t v; };
#pragma clang diagnostic pop
# 282 "../../../Library/CMSIS/Core/Include\\cmsis_armclang.h" 3
__attribute__((always_inline)) static inline int32_t __SSAT(int32_t val, uint32_t sat)
{
  if ((sat >= 1U) && (sat <= 32U))
  {
    const int32_t max = (int32_t)((1U << (sat - 1U)) - 1U);
    const int32_t min = -1 - max ;
    if (val > max)
    {
      return (max);
    }
    else if (val < min)
    {
      return (min);
    }
  }
  return (val);
}
# 308 "../../../Library/CMSIS/Core/Include\\cmsis_armclang.h" 3
__attribute__((always_inline)) static inline uint32_t __USAT(int32_t val, uint32_t sat)
{
  if (sat <= 31U)
  {
    const uint32_t max = ((1U << sat) - 1U);
    if (val > (int32_t)max)
    {
      return (max);
    }
    else if (val < 0)
    {
      return (0U);
    }
  }
  return ((uint32_t)val);
}
# 470 "../../../Library/CMSIS/Core/Include\\cmsis_armclang.h" 3
__attribute__((always_inline)) static inline uint8_t __LDAB(volatile uint8_t *ptr)
{
  uint32_t result;

  __asm volatile ("ldab %0, %1" : "=r" (result) : "Q" (*ptr) : "memory" );
  return ((uint8_t)result);
}
# 485 "../../../Library/CMSIS/Core/Include\\cmsis_armclang.h" 3
__attribute__((always_inline)) static inline uint16_t __LDAH(volatile uint16_t *ptr)
{
  uint32_t result;

  __asm volatile ("ldah %0, %1" : "=r" (result) : "Q" (*ptr) : "memory" );
  return ((uint16_t)result);
}
# 500 "../../../Library/CMSIS/Core/Include\\cmsis_armclang.h" 3
__attribute__((always_inline)) static inline uint32_t __LDA(volatile uint32_t *ptr)
{
  uint32_t result;

  __asm volatile ("lda %0, %1" : "=r" (result) : "Q" (*ptr) : "memory" );
  return (result);
}
# 515 "../../../Library/CMSIS/Core/Include\\cmsis_armclang.h" 3
__attribute__((always_inline)) static inline void __STLB(uint8_t value, volatile uint8_t *ptr)
{
  __asm volatile ("stlb %1, %0" : "=Q" (*ptr) : "r" ((uint32_t)value) : "memory" );
}
# 527 "../../../Library/CMSIS/Core/Include\\cmsis_armclang.h" 3
__attribute__((always_inline)) static inline void __STLH(uint16_t value, volatile uint16_t *ptr)
{
  __asm volatile ("stlh %1, %0" : "=Q" (*ptr) : "r" ((uint32_t)value) : "memory" );
}
# 539 "../../../Library/CMSIS/Core/Include\\cmsis_armclang.h" 3
__attribute__((always_inline)) static inline void __STL(uint32_t value, volatile uint32_t *ptr)
{
  __asm volatile ("stl %1, %0" : "=Q" (*ptr) : "r" ((uint32_t)value) : "memory" );
}
# 621 "../../../Library/CMSIS/Core/Include\\cmsis_armclang.h" 3
__attribute__((always_inline)) static inline void __enable_irq(void)
{
  __asm volatile ("cpsie i" : : : "memory");
}
# 634 "../../../Library/CMSIS/Core/Include\\cmsis_armclang.h" 3
__attribute__((always_inline)) static inline void __disable_irq(void)
{
  __asm volatile ("cpsid i" : : : "memory");
}
# 670 "../../../Library/CMSIS/Core/Include\\cmsis_armclang.h" 3
__attribute__((always_inline)) static inline uint32_t __get_FPSCR(void)
{



  return (0U);

}







__attribute__((always_inline)) static inline void __set_FPSCR(uint32_t fpscr)
{



  (void)fpscr;

}
# 702 "../../../Library/CMSIS/Core/Include\\cmsis_armclang.h" 3
# 1 "../../../Library/CMSIS/Core/Include\\./m-profile/cmsis_armclang_m.h" 1 3
# 27 "../../../Library/CMSIS/Core/Include\\./m-profile/cmsis_armclang_m.h" 3
# 128 "../../../Library/CMSIS/Core/Include\\./m-profile/cmsis_armclang_m.h" 3
__attribute__((always_inline)) static inline uint32_t __get_CONTROL(void)
{
  uint32_t result;

  __asm volatile ("MRS %0, control" : "=r" (result) );
  return (result);
}
# 158 "../../../Library/CMSIS/Core/Include\\./m-profile/cmsis_armclang_m.h" 3
__attribute__((always_inline)) static inline void __set_CONTROL(uint32_t control)
{
  __asm volatile ("MSR control, %0" : : "r" (control) : "memory");
  __builtin_arm_isb(0xF);
}
# 184 "../../../Library/CMSIS/Core/Include\\./m-profile/cmsis_armclang_m.h" 3
__attribute__((always_inline)) static inline uint32_t __get_IPSR(void)
{
  uint32_t result;

  __asm volatile ("MRS %0, ipsr" : "=r" (result) );
  return (result);
}







__attribute__((always_inline)) static inline uint32_t __get_APSR(void)
{
  uint32_t result;

  __asm volatile ("MRS %0, apsr" : "=r" (result) );
  return (result);
}







__attribute__((always_inline)) static inline uint32_t __get_xPSR(void)
{
  uint32_t result;

  __asm volatile ("MRS %0, xpsr" : "=r" (result) );
  return (result);
}







__attribute__((always_inline)) static inline uint32_t __get_PSP(void)
{
  uint32_t result;

  __asm volatile ("MRS %0, psp" : "=r" (result) );
  return (result);
}
# 256 "../../../Library/CMSIS/Core/Include\\./m-profile/cmsis_armclang_m.h" 3
__attribute__((always_inline)) static inline void __set_PSP(uint32_t topOfProcStack)
{
  __asm volatile ("MSR psp, %0" : : "r" (topOfProcStack) : );
}
# 280 "../../../Library/CMSIS/Core/Include\\./m-profile/cmsis_armclang_m.h" 3
__attribute__((always_inline)) static inline uint32_t __get_MSP(void)
{
  uint32_t result;

  __asm volatile ("MRS %0, msp" : "=r" (result) );
  return (result);
}
# 310 "../../../Library/CMSIS/Core/Include\\./m-profile/cmsis_armclang_m.h" 3
__attribute__((always_inline)) static inline void __set_MSP(uint32_t topOfMainStack)
{
  __asm volatile ("MSR msp, %0" : : "r" (topOfMainStack) : );
}
# 361 "../../../Library/CMSIS/Core/Include\\./m-profile/cmsis_armclang_m.h" 3
__attribute__((always_inline)) static inline uint32_t __get_PRIMASK(void)
{
  uint32_t result;

  __asm volatile ("MRS %0, primask" : "=r" (result) );
  return (result);
}
# 391 "../../../Library/CMSIS/Core/Include\\./m-profile/cmsis_armclang_m.h" 3
__attribute__((always_inline)) static inline void __set_PRIMASK(uint32_t priMask)
{
  __asm volatile ("MSR primask, %0" : : "r" (priMask) : "memory");
}
# 543 "../../../Library/CMSIS/Core/Include\\./m-profile/cmsis_armclang_m.h" 3
__attribute__((always_inline)) static inline uint32_t __get_PSPLIM(void)
{




  return (0U);





}
# 590 "../../../Library/CMSIS/Core/Include\\./m-profile/cmsis_armclang_m.h" 3
__attribute__((always_inline)) static inline void __set_PSPLIM(uint32_t ProcStackPtrLimit)
{




  (void)ProcStackPtrLimit;



}
# 633 "../../../Library/CMSIS/Core/Include\\./m-profile/cmsis_armclang_m.h" 3
__attribute__((always_inline)) static inline uint32_t __get_MSPLIM(void)
{




  return (0U);





}
# 680 "../../../Library/CMSIS/Core/Include\\./m-profile/cmsis_armclang_m.h" 3
__attribute__((always_inline)) static inline void __set_MSPLIM(uint32_t MainStackPtrLimit)
{




  (void)MainStackPtrLimit;



}
# 703 "../../../Library/CMSIS/Core/Include\\cmsis_armclang.h" 2 3
# 33 "../../../Library/CMSIS/Core/Include\\cmsis_compiler.h" 2 3
# 117 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 2 3
# 234 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
typedef union
{
  struct
  {
    uint32_t _reserved0:28;
    uint32_t V:1;
    uint32_t C:1;
    uint32_t Z:1;
    uint32_t N:1;
  } b;
  uint32_t w;
} APSR_Type;
# 264 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
typedef union
{
  struct
  {
    uint32_t ISR:9;
    uint32_t _reserved0:23;
  } b;
  uint32_t w;
} IPSR_Type;
# 282 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
typedef union
{
  struct
  {
    uint32_t ISR:9;
    uint32_t _reserved0:15;
    uint32_t T:1;
    uint32_t _reserved1:3;
    uint32_t V:1;
    uint32_t C:1;
    uint32_t Z:1;
    uint32_t N:1;
  } b;
  uint32_t w;
} xPSR_Type;
# 321 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
typedef union
{
  struct
  {
    uint32_t nPRIV:1;
    uint32_t SPSEL:1;
    uint32_t _reserved1:30;
  } b;
  uint32_t w;
} CONTROL_Type;
# 352 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
typedef struct
{
  volatile uint32_t ISER[16U];
        uint32_t RESERVED0[16U];
  volatile uint32_t ICER[16U];
        uint32_t RESERVED1[16U];
  volatile uint32_t ISPR[16U];
        uint32_t RESERVED2[16U];
  volatile uint32_t ICPR[16U];
        uint32_t RESERVED3[16U];
  volatile uint32_t IABR[16U];
        uint32_t RESERVED4[16U];
  volatile uint32_t ITNS[16U];
        uint32_t RESERVED5[16U];
  volatile uint32_t IPR[124U];
} NVIC_Type;
# 382 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
typedef struct
{
  volatile const uint32_t CPUID;
  volatile uint32_t ICSR;

  volatile uint32_t VTOR;



  volatile uint32_t AIRCR;
  volatile uint32_t SCR;
  volatile uint32_t CCR;
        uint32_t RESERVED1;
  volatile uint32_t SHPR[2U];
  volatile uint32_t SHCSR;
} SCB_Type;
# 559 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
typedef struct
{
  volatile uint32_t CTRL;
  volatile uint32_t LOAD;
  volatile uint32_t VAL;
  volatile const uint32_t CALIB;
} SysTick_Type;
# 611 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
typedef struct
{
  volatile uint32_t CTRL;
  volatile uint32_t CYCCNT;
  volatile uint32_t CPICNT;
  volatile uint32_t EXCCNT;
  volatile uint32_t SLEEPCNT;
  volatile uint32_t LSUCNT;
  volatile uint32_t FOLDCNT;
  volatile const uint32_t PCSR;
  volatile uint32_t COMP0;
        uint32_t RESERVED1[1U];
  volatile uint32_t FUNCTION0;
        uint32_t RESERVED2[1U];
  volatile uint32_t COMP1;
        uint32_t RESERVED3[1U];
  volatile uint32_t FUNCTION1;
        uint32_t RESERVED14[992U];
  volatile const uint32_t DEVARCH;
} DWT_Type;
# 677 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
typedef struct
{
  volatile const uint32_t SSPSR;
  volatile uint32_t CSPSR;
        uint32_t RESERVED0[2U];
  volatile uint32_t ACPR;
        uint32_t RESERVED1[55U];
  volatile uint32_t SPPR;
        uint32_t RESERVED2[131U];
  volatile const uint32_t FFSR;
  volatile uint32_t FFCR;
  volatile uint32_t PSCR;
        uint32_t RESERVED3[759U];
  volatile const uint32_t TRIGGER;
  volatile const uint32_t ITFTTD0;
  volatile uint32_t ITATBCTR2;
        uint32_t RESERVED4[1U];
  volatile const uint32_t ITATBCTR0;
  volatile const uint32_t ITFTTD1;
  volatile uint32_t ITCTRL;
        uint32_t RESERVED5[39U];
  volatile uint32_t CLAIMSET;
  volatile uint32_t CLAIMCLR;
        uint32_t RESERVED7[8U];
  volatile const uint32_t DEVID;
  volatile const uint32_t DEVTYPE;
} TPIU_Type;
# 855 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
typedef struct
{
  volatile const uint32_t TYPE;
  volatile uint32_t CTRL;
  volatile uint32_t RNR;
  volatile uint32_t RBAR;
  volatile uint32_t RLAR;
        uint32_t RESERVED0[7U];
  union {
  volatile uint32_t MAIR[2];
  struct {
  volatile uint32_t MAIR0;
  volatile uint32_t MAIR1;
  };
  };
} MPU_Type;
# 1020 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
typedef struct
{
  volatile uint32_t DHCSR;
  volatile uint32_t DCRSR;
  volatile uint32_t DCRDR;
  volatile uint32_t DEMCR;
        uint32_t RESERVED0[1U];
  volatile uint32_t DAUTHCTRL;
  volatile uint32_t DSCSR;
} DCB_Type;
# 1131 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
typedef struct
{
  volatile uint32_t DLAR;
  volatile const uint32_t DLSR;
  volatile const uint32_t DAUTHSTATUS;
  volatile const uint32_t DDEVARCH;
  volatile const uint32_t DDEVTYPE;
} DIB_Type;
# 1290 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
typedef struct
{
  volatile uint32_t DHCSR;
  volatile uint32_t DCRSR;
  volatile uint32_t DCRDR;
  volatile uint32_t DEMCR;
        uint32_t RESERVED0[1U];
  volatile uint32_t DAUTHCTRL;
  volatile uint32_t DSCSR;
} CoreDebug_Type;
# 1480 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
static inline void __NVIC_EnableIRQ(IRQn_Type IRQn)
{
  if ((int32_t)(IRQn) >= 0)
  {
    __asm volatile("":::"memory");
    ((NVIC_Type *) ((0xE000E000UL) + 0x0100UL) )->ISER[(((uint32_t)IRQn) >> 5UL)] = (uint32_t)(1UL << (((uint32_t)IRQn) & 0x1FUL));
    __asm volatile("":::"memory");
  }
}
# 1499 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
static inline uint32_t __NVIC_GetEnableIRQ(IRQn_Type IRQn)
{
  if ((int32_t)(IRQn) >= 0)
  {
    return((uint32_t)(((((NVIC_Type *) ((0xE000E000UL) + 0x0100UL) )->ISER[(((uint32_t)IRQn) >> 5UL)] & (1UL << (((uint32_t)IRQn) & 0x1FUL))) != 0UL) ? 1UL : 0UL));
  }
  else
  {
    return(0U);
  }
}
# 1518 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
static inline void __NVIC_DisableIRQ(IRQn_Type IRQn)
{
  if ((int32_t)(IRQn) >= 0)
  {
    ((NVIC_Type *) ((0xE000E000UL) + 0x0100UL) )->ICER[(((uint32_t)IRQn) >> 5UL)] = (uint32_t)(1UL << (((uint32_t)IRQn) & 0x1FUL));
    __builtin_arm_dsb(0xF);
    __builtin_arm_isb(0xF);
  }
}
# 1537 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
static inline uint32_t __NVIC_GetPendingIRQ(IRQn_Type IRQn)
{
  if ((int32_t)(IRQn) >= 0)
  {
    return((uint32_t)(((((NVIC_Type *) ((0xE000E000UL) + 0x0100UL) )->ISPR[(((uint32_t)IRQn) >> 5UL)] & (1UL << (((uint32_t)IRQn) & 0x1FUL))) != 0UL) ? 1UL : 0UL));
  }
  else
  {
    return(0U);
  }
}
# 1556 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
static inline void __NVIC_SetPendingIRQ(IRQn_Type IRQn)
{
  if ((int32_t)(IRQn) >= 0)
  {
    ((NVIC_Type *) ((0xE000E000UL) + 0x0100UL) )->ISPR[(((uint32_t)IRQn) >> 5UL)] = (uint32_t)(1UL << (((uint32_t)IRQn) & 0x1FUL));
  }
}
# 1571 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
static inline void __NVIC_ClearPendingIRQ(IRQn_Type IRQn)
{
  if ((int32_t)(IRQn) >= 0)
  {
    ((NVIC_Type *) ((0xE000E000UL) + 0x0100UL) )->ICPR[(((uint32_t)IRQn) >> 5UL)] = (uint32_t)(1UL << (((uint32_t)IRQn) & 0x1FUL));
  }
}
# 1588 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
static inline uint32_t __NVIC_GetActive(IRQn_Type IRQn)
{
  if ((int32_t)(IRQn) >= 0)
  {
    return((uint32_t)(((((NVIC_Type *) ((0xE000E000UL) + 0x0100UL) )->IABR[(((uint32_t)IRQn) >> 5UL)] & (1UL << (((uint32_t)IRQn) & 0x1FUL))) != 0UL) ? 1UL : 0UL));
  }
  else
  {
    return(0U);
  }
}
# 1677 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
static inline void __NVIC_SetPriority(IRQn_Type IRQn, uint32_t priority)
{
  if ((int32_t)(IRQn) >= 0)
  {
    ((NVIC_Type *) ((0xE000E000UL) + 0x0100UL) )->IPR[( (((uint32_t)(int32_t)(IRQn)) >> 2UL) )] = ((uint32_t)(((NVIC_Type *) ((0xE000E000UL) + 0x0100UL) )->IPR[( (((uint32_t)(int32_t)(IRQn)) >> 2UL) )] & ~(0xFFUL << ( ((((uint32_t)(int32_t)(IRQn)) ) & 0x03UL) * 8UL))) |
       (((priority << (8U - 2U)) & (uint32_t)0xFFUL) << ( ((((uint32_t)(int32_t)(IRQn)) ) & 0x03UL) * 8UL)));
  }
  else
  {
    ((SCB_Type *) ((0xE000E000UL) + 0x0D00UL) )->SHPR[( (((((uint32_t)(int32_t)(IRQn)) & 0x0FUL)-8UL) >> 2UL) )] = ((uint32_t)(((SCB_Type *) ((0xE000E000UL) + 0x0D00UL) )->SHPR[( (((((uint32_t)(int32_t)(IRQn)) & 0x0FUL)-8UL) >> 2UL) )] & ~(0xFFUL << ( ((((uint32_t)(int32_t)(IRQn)) ) & 0x03UL) * 8UL))) |
       (((priority << (8U - 2U)) & (uint32_t)0xFFUL) << ( ((((uint32_t)(int32_t)(IRQn)) ) & 0x03UL) * 8UL)));
  }
}
# 1701 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
static inline uint32_t __NVIC_GetPriority(IRQn_Type IRQn)
{

  if ((int32_t)(IRQn) >= 0)
  {
    return((uint32_t)(((((NVIC_Type *) ((0xE000E000UL) + 0x0100UL) )->IPR[ ( (((uint32_t)(int32_t)(IRQn)) >> 2UL) )] >> ( ((((uint32_t)(int32_t)(IRQn)) ) & 0x03UL) * 8UL) ) & (uint32_t)0xFFUL) >> (8U - 2U)));
  }
  else
  {
    return((uint32_t)(((((SCB_Type *) ((0xE000E000UL) + 0x0D00UL) )->SHPR[( (((((uint32_t)(int32_t)(IRQn)) & 0x0FUL)-8UL) >> 2UL) )] >> ( ((((uint32_t)(int32_t)(IRQn)) ) & 0x03UL) * 8UL) ) & (uint32_t)0xFFUL) >> (8U - 2U)));
  }
}
# 1726 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
static inline uint32_t NVIC_EncodePriority (uint32_t PriorityGroup, uint32_t PreemptPriority, uint32_t SubPriority)
{
  uint32_t PriorityGroupTmp = (PriorityGroup & (uint32_t)0x07UL);
  uint32_t PreemptPriorityBits;
  uint32_t SubPriorityBits;

  PreemptPriorityBits = ((7UL - PriorityGroupTmp) > (uint32_t)(2U)) ? (uint32_t)(2U) : (uint32_t)(7UL - PriorityGroupTmp);
  SubPriorityBits = ((PriorityGroupTmp + (uint32_t)(2U)) < (uint32_t)7UL) ? (uint32_t)0UL : (uint32_t)((PriorityGroupTmp - 7UL) + (uint32_t)(2U));

  return (
           ((PreemptPriority & (uint32_t)((1UL << (PreemptPriorityBits)) - 1UL)) << SubPriorityBits) |
           ((SubPriority & (uint32_t)((1UL << (SubPriorityBits )) - 1UL)))
         );
}
# 1753 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
static inline void NVIC_DecodePriority (uint32_t Priority, uint32_t PriorityGroup, uint32_t* const pPreemptPriority, uint32_t* const pSubPriority)
{
  uint32_t PriorityGroupTmp = (PriorityGroup & (uint32_t)0x07UL);
  uint32_t PreemptPriorityBits;
  uint32_t SubPriorityBits;

  PreemptPriorityBits = ((7UL - PriorityGroupTmp) > (uint32_t)(2U)) ? (uint32_t)(2U) : (uint32_t)(7UL - PriorityGroupTmp);
  SubPriorityBits = ((PriorityGroupTmp + (uint32_t)(2U)) < (uint32_t)7UL) ? (uint32_t)0UL : (uint32_t)((PriorityGroupTmp - 7UL) + (uint32_t)(2U));

  *pPreemptPriority = (Priority >> SubPriorityBits) & (uint32_t)((1UL << (PreemptPriorityBits)) - 1UL);
  *pSubPriority = (Priority ) & (uint32_t)((1UL << (SubPriorityBits )) - 1UL);
}
# 1777 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
static inline void __NVIC_SetVector(IRQn_Type IRQn, uint32_t vector)
{

  uint32_t *vectors = (uint32_t *) ((uintptr_t) ((SCB_Type *) ((0xE000E000UL) + 0x0D00UL) )->VTOR);



  vectors[(int32_t)IRQn + 16] = vector;
  __builtin_arm_dsb(0xF);
}
# 1797 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
static inline uint32_t __NVIC_GetVector(IRQn_Type IRQn)
{

  uint32_t *vectors = (uint32_t *) ((uintptr_t) ((SCB_Type *) ((0xE000E000UL) + 0x0D00UL) )->VTOR);



  return vectors[(int32_t)IRQn + 16];
}






__attribute__((__noreturn__)) static inline void __NVIC_SystemReset(void)
{
  __builtin_arm_dsb(0xF);

  ((SCB_Type *) ((0xE000E000UL) + 0x0D00UL) )->AIRCR = ((0x5FAUL << 16U) |
                 (1UL << 2U));
  __builtin_arm_dsb(0xF);

  for(;;)
  {
    __nop();
  }
}
# 2002 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
# 1 "../../../Library/CMSIS/Core/Include\\m-profile/armv8m_mpu.h" 1 3
# 30 "../../../Library/CMSIS/Core/Include\\m-profile/armv8m_mpu.h" 3
# 182 "../../../Library/CMSIS/Core/Include\\m-profile/armv8m_mpu.h" 3
typedef struct {
  uint32_t RBAR;
  uint32_t RLAR;
} ARM_MPU_Region_t;





static inline uint32_t ARM_MPU_TYPE()
{
  return ((((MPU_Type *) ((0xE000E000UL) + 0x0D90UL) )->TYPE) >> 8);
}




static inline void ARM_MPU_Enable(uint32_t MPU_Control)
{
  __builtin_arm_dmb(0xF);
  ((MPU_Type *) ((0xE000E000UL) + 0x0D90UL) )->CTRL = MPU_Control | (1UL );



  __builtin_arm_dsb(0xF);
  __builtin_arm_isb(0xF);
}



static inline void ARM_MPU_Disable(void)
{
  __builtin_arm_dmb(0xF);



  ((MPU_Type *) ((0xE000E000UL) + 0x0D90UL) )->CTRL &= ~(1UL );
  __builtin_arm_dsb(0xF);
  __builtin_arm_isb(0xF);
}
# 257 "../../../Library/CMSIS/Core/Include\\m-profile/armv8m_mpu.h" 3
static inline void ARM_MPU_SetMemAttrEx(MPU_Type* mpu, uint8_t idx, uint8_t attr)
{
  const uint8_t reg = idx / 4U;
  const uint32_t pos = ((idx % 4U) * 8U);
  const uint32_t mask = 0xFFU << pos;

  if (reg >= (sizeof(mpu->MAIR) / sizeof(mpu->MAIR[0]))) {
    return;
  }

  mpu->MAIR[reg] = ((mpu->MAIR[reg] & ~mask) | ((attr << pos) & mask));
}





static inline void ARM_MPU_SetMemAttr(uint8_t idx, uint8_t attr)
{
  ARM_MPU_SetMemAttrEx(((MPU_Type *) ((0xE000E000UL) + 0x0D90UL) ), idx, attr);
}
# 294 "../../../Library/CMSIS/Core/Include\\m-profile/armv8m_mpu.h" 3
static inline void ARM_MPU_ClrRegionEx(MPU_Type* mpu, uint32_t rnr)
{
  mpu->RNR = rnr;
  mpu->RLAR = 0U;
}




static inline void ARM_MPU_ClrRegion(uint32_t rnr)
{
  ARM_MPU_ClrRegionEx(((MPU_Type *) ((0xE000E000UL) + 0x0D90UL) ), rnr);
}
# 324 "../../../Library/CMSIS/Core/Include\\m-profile/armv8m_mpu.h" 3
static inline void ARM_MPU_SetRegionEx(MPU_Type* mpu, uint32_t rnr, uint32_t rbar, uint32_t rlar)
{
  mpu->RNR = rnr;
  mpu->RBAR = rbar;
  mpu->RLAR = rlar;
}






static inline void ARM_MPU_SetRegion(uint32_t rnr, uint32_t rbar, uint32_t rlar)
{
  ARM_MPU_SetRegionEx(((MPU_Type *) ((0xE000E000UL) + 0x0D90UL) ), rnr, rbar, rlar);
}
# 358 "../../../Library/CMSIS/Core/Include\\m-profile/armv8m_mpu.h" 3
static inline void ARM_MPU_OrderedMemcpy(volatile uint32_t* dst, const uint32_t* __restrict src, uint32_t len)
{
  uint32_t i;
  for (i = 0U; i < len; ++i)
  {
    dst[i] = src[i];
  }
}







static inline void ARM_MPU_LoadEx(MPU_Type* mpu, uint32_t rnr, ARM_MPU_Region_t const* table, uint32_t cnt)
{
  const uint32_t rowWordSize = sizeof(ARM_MPU_Region_t)/4U;
  if (cnt == 1U) {
    mpu->RNR = rnr;
    ARM_MPU_OrderedMemcpy(&(mpu->RBAR), &(table->RBAR), rowWordSize);
  } else {
    uint32_t rnrBase = rnr & ~(1U -1U);
    uint32_t rnrOffset = rnr % 1U;

    mpu->RNR = rnrBase;
    while ((rnrOffset + cnt) > 1U) {
      uint32_t c = 1U - rnrOffset;
      ARM_MPU_OrderedMemcpy(&(mpu->RBAR)+(rnrOffset*2U), &(table->RBAR), c*rowWordSize);
      table += c;
      cnt -= c;
      rnrOffset = 0U;
      rnrBase += 1U;
      mpu->RNR = rnrBase;
    }

    ARM_MPU_OrderedMemcpy(&(mpu->RBAR)+(rnrOffset*2U), &(table->RBAR), cnt*rowWordSize);
  }
}






static inline void ARM_MPU_Load(uint32_t rnr, ARM_MPU_Region_t const* table, uint32_t cnt)
{
  ARM_MPU_LoadEx(((MPU_Type *) ((0xE000E000UL) + 0x0D90UL) ), rnr, table, cnt);
}
# 2003 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 2 3
# 2023 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
static inline uint32_t SCB_GetFPUType(void)
{
    return 0U;
}
# 2083 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
static inline void DCB_SetAuthCtrl(uint32_t value)
{
    __builtin_arm_dsb(0xF);
    __builtin_arm_isb(0xF);
    ((DCB_Type *) (0xE000EDF0UL) )->DAUTHCTRL = value;
    __builtin_arm_dsb(0xF);
    __builtin_arm_isb(0xF);
}







static inline uint32_t DCB_GetAuthCtrl(void)
{
    return (((DCB_Type *) (0xE000EDF0UL) )->DAUTHCTRL);
}
# 2150 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
static inline uint32_t DIB_GetAuthStatus(void)
{
    return (((DIB_Type *) (0xE000EFB0UL) )->DAUTHSTATUS);
}
# 2194 "../../../Library/CMSIS/Core/Include\\core_cm23.h" 3
static inline uint32_t SysTick_Config(uint32_t ticks)
{
  if ((ticks - 1UL) > (0xFFFFFFUL ))
  {
    return (1UL);
  }

  ((SysTick_Type *) ((0xE000E000UL) + 0x0010UL) )->LOAD = (uint32_t)(ticks - 1UL);
  __NVIC_SetPriority (SysTick_IRQn, (1UL << 2U) - 1UL);
  ((SysTick_Type *) ((0xE000E000UL) + 0x0010UL) )->VAL = 0UL;
  ((SysTick_Type *) ((0xE000E000UL) + 0x0010UL) )->CTRL = (1UL << 2U) |
                   (1UL << 1U) |
                   (1UL );
  return (0UL);
}
# 192 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\system_M253.h" 1
# 53 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\system_M253.h"
extern uint32_t SystemCoreClock;
extern uint32_t CyclesPerUs;
extern uint32_t PllClock;




typedef void(*VECTOR_TABLE_Type)(void);






extern void SystemInit(void);







extern void SystemCoreClockUpdate(void);







extern void UartDebugMFP(void);






extern void UartDebugCLK(void);







extern void UartDebugInit(void);
# 110 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\system_M253.h"
extern int IsDebugFifoEmpty(void);
# 193 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 205 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h"
# 1 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\bpwm_reg.h" 1
# 29 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\bpwm_reg.h"
typedef struct
{
# 47 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\bpwm_reg.h"
    volatile uint32_t RCAPDAT;
    volatile uint32_t FCAPDAT;
} BCAPDAT_T;

typedef struct
{
# 1087 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\bpwm_reg.h"
    volatile uint32_t CTL0;
    volatile uint32_t CTL1;

    volatile const uint32_t RESERVE0[2];

    volatile uint32_t CLKSRC;
    volatile uint32_t CLKPSC;

    volatile const uint32_t RESERVE1[2];

    volatile uint32_t CNTEN;
    volatile uint32_t CNTCLR;

    volatile const uint32_t RESERVE2[2];

    volatile uint32_t PERIOD;

    volatile const uint32_t RESERVE3[7];

    volatile uint32_t CMPDAT[6];

    volatile const uint32_t RESERVE4[10];

    volatile const uint32_t CNT;

    volatile const uint32_t RESERVE5[7];

    volatile uint32_t WGCTL0;
    volatile uint32_t WGCTL1;
    volatile uint32_t MSKEN;
    volatile uint32_t MSK;

    volatile const uint32_t RESERVE6[5];

    volatile uint32_t POLCTL;
    volatile uint32_t POEN;

    volatile const uint32_t RESERVE7[1];

    volatile uint32_t INTEN;

    volatile const uint32_t RESERVE8[1];

    volatile uint32_t INTSTS;

    volatile const uint32_t RESERVE9[3];

    volatile uint32_t EADCTS0;
    volatile uint32_t EADCTS1;

    volatile const uint32_t RESERVE10[4];

    volatile uint32_t SSCTL;
    volatile uint32_t SSTRG;

    volatile const uint32_t RESERVE11[2];

    volatile uint32_t STATUS;

    volatile const uint32_t RESERVE12[55];

    volatile uint32_t CAPINEN;
    volatile uint32_t CAPCTL;
    volatile const uint32_t CAPSTS;
    BCAPDAT_T CAPDAT[6];

    volatile const uint32_t RESERVE13[5];

    volatile uint32_t CAPIEN;
    volatile uint32_t CAPIF;

    volatile const uint32_t RESERVE14[43];

    volatile const uint32_t PBUF;

    volatile const uint32_t RESERVE15[5];

    volatile const uint32_t CMPBUF[6];
} BPWM_T;
# 206 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\canfd_reg.h" 1
# 28 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\canfd_reg.h"
typedef struct
{
# 1024 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\canfd_reg.h"
    volatile const uint32_t RESERVE0[3];

    volatile uint32_t DBTP;
    volatile uint32_t TEST;
    volatile uint32_t RWD;
    volatile uint32_t CCCR;
    volatile uint32_t NBTP;
    volatile uint32_t TSCC;
    volatile uint32_t TSCV;
    volatile uint32_t TOCC;
    volatile uint32_t TOCV;

    volatile const uint32_t RESERVE1[4];

    volatile const uint32_t ECR;
    volatile const uint32_t PSR;
    volatile uint32_t TDCR;

    volatile const uint32_t RESERVE2[1];

    volatile uint32_t IR;
    volatile uint32_t IE;
    volatile uint32_t ILS;
    volatile uint32_t ILE;

    volatile const uint32_t RESERVE3[8];

    volatile uint32_t GFC;
    volatile uint32_t SIDFC;
    volatile uint32_t XIDFC;

    volatile const uint32_t RESERVE4[1];

    volatile uint32_t XIDAM;
    volatile const uint32_t HPMS;
    volatile uint32_t NDAT1;
    volatile uint32_t NDAT2;
    volatile uint32_t RXF0C;
    volatile uint32_t RXF0S;
    volatile uint32_t RXF0A;
    volatile uint32_t RXBC;
    volatile uint32_t RXF1C;
    volatile uint32_t RXF1S;
    volatile uint32_t RXF1A;
    volatile uint32_t RXESC;
    volatile uint32_t TXBC;
    volatile uint32_t TXFQS;
    volatile uint32_t TXESC;
    volatile uint32_t TXBRP;
    volatile uint32_t TXBAR;
    volatile uint32_t TXBCR;
    volatile uint32_t TXBTO;
    volatile uint32_t TXBCF;
    volatile uint32_t TXBTIE;
    volatile uint32_t TXBCIE;

    volatile const uint32_t RESERVE5[2];

    volatile uint32_t TXEFC;
    volatile uint32_t TXEFS;
    volatile uint32_t TXEFA;
} CANFD_T;
# 207 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\clk_reg.h" 1
# 28 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\clk_reg.h"
typedef struct
{
# 526 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\clk_reg.h"
    volatile uint32_t PWRCTL;
    volatile uint32_t AHBCLK;
    volatile uint32_t APBCLK0;
    volatile uint32_t APBCLK1;
    volatile uint32_t CLKSEL0;
    volatile uint32_t CLKSEL1;
    volatile uint32_t CLKSEL2;
    volatile uint32_t CLKSEL3;
    volatile uint32_t CLKDIV0;

    volatile const uint32_t RESERVE0[3];

    volatile uint32_t CLKDIV4;
    volatile uint32_t PCLKDIV;

    volatile const uint32_t RESERVE1[6];

    volatile const uint32_t STATUS;

    volatile const uint32_t RESERVE2[3];

    volatile uint32_t CLKOCTL;

    volatile const uint32_t RESERVE3[3];

    volatile uint32_t CLKDCTL;
    volatile uint32_t CLKDSTS;
    volatile uint32_t CDUPB;
    volatile uint32_t CDLOWB;

    volatile const uint32_t RESERVE4[4];

    volatile uint32_t PMUCTL;

    volatile const uint32_t RESERVE5[8];

    volatile uint32_t HXTFSEL;
} CLK_T;
# 208 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\crc_reg.h" 1
# 28 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\crc_reg.h"
typedef struct
{
# 99 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\crc_reg.h"
    volatile uint32_t CTL;
    volatile uint32_t DAT;
    volatile uint32_t SEED;
    volatile const uint32_t CHECKSUM;
} CRC_T;
# 209 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\eadc_reg.h" 1
# 28 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\eadc_reg.h"
typedef struct
{
# 482 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\eadc_reg.h"
    volatile const uint32_t DAT[19];
    volatile const uint32_t CURDAT;
    volatile uint32_t CTL;
    volatile uint32_t SWTRG;
    volatile uint32_t PENDSTS;
    volatile uint32_t OVSTS;

    volatile const uint32_t RESERVE0[8];

    volatile uint32_t SCTL[16];
    volatile uint32_t SCTL0[3];

    volatile const uint32_t RESERVE1[1];

    volatile uint32_t INTSRC[4];
    volatile uint32_t CMP[4];
    volatile const uint32_t STATUS0;
    volatile const uint32_t STATUS1;
    volatile uint32_t STATUS2;
    volatile const uint32_t STATUS3;

    volatile const uint32_t RESERVE2[4];

    volatile uint32_t PWRCTL;

    volatile const uint32_t RESERVE3[7];

    volatile uint32_t PDMACTL;

    volatile const uint32_t RESERVE4[3];

    volatile uint32_t MCTL1[16];
} EADC_T;
# 210 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\fmc_reg.h" 1
# 28 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\fmc_reg.h"
typedef struct
{
# 294 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\fmc_reg.h"
    volatile uint32_t ISPCTL;
    volatile uint32_t ISPADDR;
    volatile uint32_t ISPDAT;
    volatile uint32_t ISPCMD;
    volatile uint32_t ISPTRG;

    volatile const uint32_t RESERVE0;

    volatile uint32_t FTCTL;

    volatile const uint32_t RESERVE1[9];

    volatile uint32_t ISPSTS;

    volatile const uint32_t RESERVE2[2];

    volatile uint32_t CYCCTL;

    volatile const uint32_t RESERVE3[12];

    volatile uint32_t MPDAT0;
    volatile uint32_t MPDAT1;
    volatile uint32_t MPDAT2;
    volatile uint32_t MPDAT3;

    volatile const uint32_t RESERVE4[12];

    volatile const uint32_t MPSTS;
    volatile const uint32_t MPADDR;

    volatile const uint32_t RESERVE5[2];

    volatile const uint32_t XOMR0STS0;
    volatile const uint32_t XOMR0STS1;

    volatile const uint32_t RESERVE6[2];

    volatile const uint32_t XOMSTS;
} FMC_T;
# 211 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\gpio_reg.h" 1
# 28 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\gpio_reg.h"
typedef struct
{
# 209 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\gpio_reg.h"
    volatile uint32_t MODE;
    volatile uint32_t DINOFF;
    volatile uint32_t DOUT;
    volatile uint32_t DATMSK;
    volatile const uint32_t PIN;
    volatile uint32_t DBEN;
    volatile uint32_t INTTYPE;
    volatile uint32_t INTEN;
    volatile uint32_t INTSRC;
    volatile uint32_t SMTEN;
    volatile uint32_t SLEWCTL;

    volatile const uint32_t RESERVE0[1];

    volatile uint32_t PUSEL;
} GPIO_T;


typedef struct
{
# 261 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\gpio_reg.h"
    volatile uint32_t DBCTL;
} GPIO_DBCTL_T;
# 212 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\i2c_reg.h" 1
# 29 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\i2c_reg.h"
typedef struct
{
# 221 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\i2c_reg.h"
    volatile uint32_t CTL0;
    volatile uint32_t ADDR0;
    volatile uint32_t DAT;
    volatile const uint32_t STATUS0;
    volatile uint32_t CLKDIV;
    volatile uint32_t TOCTL;
    volatile uint32_t ADDR1;
    volatile uint32_t ADDR2;
    volatile uint32_t ADDR3;
    volatile uint32_t ADDRMSK0;
    volatile uint32_t ADDRMSK1;
    volatile uint32_t ADDRMSK2;
    volatile uint32_t ADDRMSK3;

    volatile const uint32_t RESERVE0[2];

    volatile uint32_t WKCTL;
    volatile uint32_t WKSTS;
    volatile uint32_t CTL1;
    volatile uint32_t STATUS1;
    volatile uint32_t TMCTL;
} I2C_T;
# 213 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\pdma_reg.h" 1
# 28 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\pdma_reg.h"
typedef struct
{
# 120 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\pdma_reg.h"
    volatile uint32_t CTL;
    volatile uint32_t SA;
    volatile uint32_t DA;
    volatile uint32_t NEXT;

} DSCT_T;

typedef struct
{
# 445 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\pdma_reg.h"
    DSCT_T DSCT[5];

    volatile const uint32_t RESERVE0[44];

    volatile const uint32_t CURSCAT[5];

    volatile const uint32_t RESERVE1[187];

    volatile uint32_t CHCTL;
    volatile uint32_t PAUSE;
    volatile uint32_t SWREQ;
    volatile const uint32_t TRGSTS;
    volatile uint32_t PRISET;
    volatile uint32_t PRICLR;
    volatile uint32_t INTEN;
    volatile uint32_t INTSTS;
    volatile uint32_t ABTSTS;
    volatile uint32_t TDSTS;
    volatile uint32_t ALIGN;
    volatile const uint32_t TACTSTS;
    volatile uint32_t TOUTPSC;
    volatile uint32_t TOUTEN;
    volatile uint32_t TOUTIEN;
    volatile uint32_t SCATBA;
    volatile uint32_t TOC0_1;

    volatile const uint32_t RESERVE2[7];

    volatile uint32_t CHRST;

    volatile const uint32_t RESERVE3[7];

    volatile uint32_t REQSEL0_3;
    volatile uint32_t REQSEL4_7;
} PDMA_T;
# 214 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\rtc_reg.h" 1
# 28 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\rtc_reg.h"
typedef struct
{
# 266 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\rtc_reg.h"
    volatile uint32_t INIT;

    volatile const uint32_t RESERVE0[1];

    volatile uint32_t FREQADJ;
    volatile uint32_t TIME;
    volatile uint32_t CAL;
    volatile uint32_t CLKFMT;
    volatile uint32_t WEEKDAY;
    volatile uint32_t TALM;
    volatile uint32_t CALM;
    volatile const uint32_t LEAPYEAR;
    volatile uint32_t INTEN;
    volatile uint32_t INTSTS;
    volatile uint32_t TICK;
    volatile uint32_t TAMSK;
    volatile uint32_t CAMSK;

    volatile const uint32_t RESERVE1[49];

    volatile uint32_t LXTCTL;

    volatile const uint32_t RESERVE2[3];

    volatile uint32_t DSTCTL;
} RTC_T;
# 215 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\spi_reg.h" 1
# 28 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\spi_reg.h"
typedef struct
{
# 554 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\spi_reg.h"
    volatile uint32_t CTL;
    volatile uint32_t CLKDIV;
    volatile uint32_t SSCTL;
    volatile uint32_t PDMACTL;
    volatile uint32_t FIFOCTL;
    volatile uint32_t STATUS;
    volatile uint32_t STATUS2;

    volatile const uint32_t RESERVE0;

    volatile uint32_t TX;

    volatile const uint32_t RESERVE1[3];

    volatile const uint32_t RX;

    volatile const uint32_t RESERVE2[11];

    volatile uint32_t I2SCTL;
    volatile uint32_t I2SCLK;
    volatile uint32_t I2SSTS;
} SPI_T;
# 216 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\sys_reg.h" 1
# 28 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\sys_reg.h"
typedef struct
{
# 1365 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\sys_reg.h"
    volatile const uint32_t PDID;
    volatile uint32_t RSTSTS;
    volatile uint32_t IPRST0;
    volatile uint32_t IPRST1;
    volatile uint32_t IPRST2;
    volatile uint32_t ALTCTL;
    volatile uint32_t BODCTL;
    volatile uint32_t IVSCTL;

    volatile const uint32_t RESERVE0[1];

    volatile uint32_t PORCTL0;
    volatile uint32_t VREFCTL;

    volatile const uint32_t RESERVE1[1];

    volatile uint32_t GPA_MFPL;
    volatile uint32_t GPA_MFPH;
    volatile uint32_t GPB_MFPL;
    volatile uint32_t GPB_MFPH;
    volatile uint32_t GPC_MFPL;
    volatile uint32_t GPC_MFPH;
    volatile uint32_t GPD_MFPL;
    volatile uint32_t GPD_MFPH;
    volatile uint32_t GPE_MFPL;
    volatile uint32_t GPE_MFPH;
    volatile uint32_t GPF_MFPL;
    volatile uint32_t GPF_MFPH;

    volatile const uint32_t RESERVE2[8];

    volatile uint32_t GPA_MFOS;
    volatile uint32_t GPB_MFOS;
    volatile uint32_t GPC_MFOS;
    volatile uint32_t GPD_MFOS;
    volatile uint32_t GPE_MFOS;
    volatile uint32_t GPF_MFOS;

    volatile const uint32_t RESERVE3[14];

    volatile uint32_t SRAM_BISTCTL;
    volatile const uint32_t SRAM_BISTSTS;

    volatile const uint32_t RESERVE4[6];

    volatile uint32_t HIRCTRIMCTL;
    volatile uint32_t HIRCTRIMIEN;
    volatile uint32_t HIRCTRIMSTS;

    volatile const uint32_t RESERVE5[1];

    volatile uint32_t REGLCTL;
    volatile uint32_t MIRCTRIMCTL;
    volatile uint32_t MIRCTRIMIEN;
    volatile uint32_t MIRCTRIMSTS;

    volatile const uint32_t RESERVE6[55];

    volatile uint32_t PORCTL1;

    volatile const uint32_t RESERVE7[2];

    volatile uint32_t PLCTL;
    volatile const uint32_t PLSTS;
} SYS_T;
# 217 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\timer_reg.h" 1
# 28 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\timer_reg.h"
typedef struct
{
# 448 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\timer_reg.h"
    volatile uint32_t CTL;
    volatile uint32_t CMP;
    volatile uint32_t INTSTS;
    volatile uint32_t CNT;
    volatile const uint32_t CAP;
    volatile uint32_t EXTCTL;
    volatile uint32_t EINTSTS;
    volatile uint32_t TRGCTL;

    volatile const uint32_t RESERVE0[8];

    volatile uint32_t PWMCTL;
    volatile uint32_t PWMCLKPSC;
    volatile uint32_t PWMCNTCLR;
    volatile uint32_t PWMPERIOD;
    volatile uint32_t PWMCMPDAT;
    volatile const uint32_t PWMCNT;
    volatile uint32_t PWMPOLCTL;
    volatile uint32_t PWMPOCTL;
    volatile uint32_t PWMINTEN0;
    volatile uint32_t PWMINTSTS0;
    volatile uint32_t PWMTRGCTL;
    volatile uint32_t PWMSTATUS;
    volatile const uint32_t PWMPBUF;
    volatile const uint32_t PWMCMPBUF;
} TIMER_T;
# 218 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\uart_reg.h" 1
# 28 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\uart_reg.h"
typedef struct
{
# 848 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\uart_reg.h"
    volatile uint32_t DAT;
    volatile uint32_t INTEN;
    volatile uint32_t FIFO;
    volatile uint32_t LINE;
    volatile uint32_t MODEM;
    volatile uint32_t MODEMSTS;
    volatile uint32_t FIFOSTS;
    volatile uint32_t INTSTS;
    volatile uint32_t TOUT;
    volatile uint32_t BAUD;
    volatile uint32_t IRDA;
    volatile uint32_t ALTCTL;
    volatile uint32_t FUNCSEL;
    volatile uint32_t LINCTL;
    volatile uint32_t LINSTS;
    volatile uint32_t BRCOMP;
    volatile uint32_t WKCTL;
    volatile uint32_t WKSTS;
    volatile uint32_t DWKCOMP;
} UART_T;
# 219 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\uuart_reg.h" 1
# 28 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\uuart_reg.h"
typedef struct
{
# 430 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\uuart_reg.h"
    volatile uint32_t CTL;
    volatile uint32_t INTEN;
    volatile uint32_t BRGEN;

    volatile const uint32_t RESERVE0[1];

    volatile uint32_t DATIN0;

    volatile const uint32_t RESERVE1[3];

    volatile uint32_t CTLIN0;

    volatile const uint32_t RESERVE2[1];

    volatile uint32_t CLKIN;
    volatile uint32_t LINECTL;
    volatile uint32_t TXDAT;
    volatile const uint32_t RXDAT;
    volatile uint32_t BUFCTL;
    volatile uint32_t BUFSTS;
    volatile uint32_t PDMACTL;

    volatile const uint32_t RESERVE3[4];

    volatile uint32_t WKCTL;
    volatile uint32_t WKSTS;
    volatile uint32_t PROTCTL;
    volatile uint32_t PROTIEN;
    volatile uint32_t PROTSTS;
} UUART_T;
# 220 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\ui2c_reg.h" 1
# 28 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\ui2c_reg.h"
typedef struct
{
# 376 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\ui2c_reg.h"
    volatile uint32_t CTL;

    volatile const uint32_t RESERVE0[1];

    volatile uint32_t BRGEN;

    volatile const uint32_t RESERVE1[8];

    volatile uint32_t LINECTL;
    volatile uint32_t TXDAT;
    volatile const uint32_t RXDAT;

    volatile const uint32_t RESERVE2[3];

    volatile uint32_t DEVADDR0;
    volatile uint32_t DEVADDR1;
    volatile uint32_t ADDRMSK0;
    volatile uint32_t ADDRMSK1;
    volatile uint32_t WKCTL;
    volatile uint32_t WKSTS;
    volatile uint32_t PROTCTL;
    volatile uint32_t PROTIEN;
    volatile uint32_t PROTSTS;

    volatile const uint32_t RESERVE3[8];

    volatile uint32_t ADMAT;
    volatile uint32_t TMCTL;
} UI2C_T;
# 221 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\uspi_reg.h" 1
# 28 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\uspi_reg.h"
typedef struct
{
# 435 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\uspi_reg.h"
    volatile uint32_t CTL;
    volatile uint32_t INTEN;
    volatile uint32_t BRGEN;

    volatile const uint32_t RESERVE0[1];

    volatile uint32_t DATIN0;

    volatile const uint32_t RESERVE1[3];

    volatile uint32_t CTLIN0;

    volatile const uint32_t RESERVE2[1];

    volatile uint32_t CLKIN;
    volatile uint32_t LINECTL;
    volatile uint32_t TXDAT;
    volatile const uint32_t RXDAT;
    volatile uint32_t BUFCTL;
    volatile uint32_t BUFSTS;
    volatile uint32_t PDMACTL;

    volatile const uint32_t RESERVE3[4];

    volatile uint32_t WKCTL;
    volatile uint32_t WKSTS;
    volatile uint32_t PROTCTL;
    volatile uint32_t PROTIEN;
    volatile uint32_t PROTSTS;
} USPI_T;
# 222 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\usbd_reg.h" 1
# 28 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\usbd_reg.h"
typedef struct
{
# 95 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\usbd_reg.h"
    volatile uint32_t BUFSEG;
    volatile uint32_t MXPLD;
    volatile uint32_t CFG;
    volatile uint32_t CFGP;

} USBD_EP_T;

typedef struct
{
# 473 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\usbd_reg.h"
    volatile uint32_t INTEN;
    volatile uint32_t INTSTS;
    volatile uint32_t FADDR;
    volatile const uint32_t EPSTS;
    volatile uint32_t ATTR;
    volatile const uint32_t VBUSDET;
    volatile uint32_t STBUFSEG;

    volatile const uint32_t RESERVE0[1];

    volatile const uint32_t EPSTS0;
    volatile const uint32_t EPSTS1;
    volatile const uint32_t EPSTS2;

    volatile const uint32_t RESERVE1[23];

    volatile const uint32_t LPMATTR;
    volatile const uint32_t FN;
    volatile uint32_t SE0;

    volatile const uint32_t RESERVE2[283];

    USBD_EP_T EP[17];
} USBD_T;
# 223 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\wdt_reg.h" 1
# 28 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\wdt_reg.h"
typedef struct
{
# 121 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\wdt_reg.h"
    volatile uint32_t CTL;
    volatile uint32_t ALTCTL;
    volatile uint32_t RSTCNT;
} WDT_T;
# 224 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\wwdt_reg.h" 1
# 28 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\wwdt_reg.h"
typedef struct
{
# 103 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\wwdt_reg.h"
    volatile uint32_t RLDCNT;
    volatile uint32_t CTL;
    volatile uint32_t STATUS;
    volatile const uint32_t CNT;
} WWDT_T;
# 225 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 351 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h"
#pragma clang diagnostic pop
# 377 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h"
typedef volatile uint8_t vu8;
typedef volatile uint16_t vu16;
typedef volatile uint32_t vu32;
typedef volatile uint64_t vu64;
# 578 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h"
# 1 "../../../Library/StdDriver/inc\\sys.h" 1
# 606 "../../../Library/StdDriver/inc\\sys.h"
static inline void SYS_UnlockReg(void);
static inline void SYS_LockReg(void);






static inline void SYS_UnlockReg(void)
{
    do
    {
        ((SYS_T *) (((uint32_t)0x40000000UL) + 0x00000UL))->REGLCTL = 0x59UL;
        ((SYS_T *) (((uint32_t)0x40000000UL) + 0x00000UL))->REGLCTL = 0x16UL;
        ((SYS_T *) (((uint32_t)0x40000000UL) + 0x00000UL))->REGLCTL = 0x88UL;
    } while (((SYS_T *) (((uint32_t)0x40000000UL) + 0x00000UL))->REGLCTL == 0UL);
}






static inline void SYS_LockReg(void)
{
    ((SYS_T *) (((uint32_t)0x40000000UL) + 0x00000UL))->REGLCTL = 0x0UL;
}
# 641 "../../../Library/StdDriver/inc\\sys.h"
static inline uint32_t SYS_IsRegLocked(void)
{
    return ((SYS_T *) (((uint32_t)0x40000000UL) + 0x00000UL))->REGLCTL & 1UL ? 0UL : 1UL;
}

void SYS_ClearResetSrc(uint32_t u32Src);
uint32_t SYS_GetBODStatus(void);
uint32_t SYS_GetResetSrc(void);
uint32_t SYS_ReadPDID(void);
void SYS_ResetChip(void);
void SYS_ResetCPU(void);
void SYS_ResetModule(uint32_t u32ModuleIndex);
void SYS_EnableBOD(int32_t i32Mode, uint32_t u32BODLevel);
void SYS_DisableBOD(void);
void SYS_SetPowerLevel(uint32_t u32PowerLevel);
# 579 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "../../../Library/StdDriver/inc\\clk.h" 1
# 348 "../../../Library/StdDriver/inc\\clk.h"
extern int32_t g_CLK_i32ErrCode;


void CLK_DisableCKO(void);
void CLK_EnableCKO(uint32_t u32ClkSrc, uint32_t u32ClkDiv, uint32_t u32ClkDivBy1En);
void CLK_PowerDown(void);
void CLK_Idle(void);
uint32_t CLK_GetHXTFreq(void);
uint32_t CLK_GetLXTFreq(void);
uint32_t CLK_GetPCLK0Freq(void);
uint32_t CLK_GetPCLK1Freq(void);
uint32_t CLK_GetHCLKFreq(void);
uint32_t CLK_GetCPUFreq(void);
void CLK_SetHCLK(uint32_t u32ClkSrc, uint32_t u32ClkDiv);
void CLK_SetModuleClock(uint32_t u32ModuleIdx, uint32_t u32ClkSrc, uint32_t u32ClkDiv);
void CLK_SetSysTickClockSrc(uint32_t u32ClkSrc);
void CLK_EnableXtalRC(uint32_t u32ClkMask);
void CLK_DisableXtalRC(uint32_t u32ClkMask);
void CLK_EnableModuleClock(uint32_t u32ModuleIdx);
void CLK_DisableModuleClock(uint32_t u32ModuleIdx);
uint32_t CLK_WaitClockReady(uint32_t u32ClkMask);
void CLK_EnableSysTick(uint32_t u32ClkSrc, uint32_t u32Count);
void CLK_DisableSysTick(void);
void CLK_SetPowerDownMode(uint32_t u32PDMode);
uint32_t CLK_GetModuleClockSource(uint32_t u32ModuleIdx);
uint32_t CLK_GetModuleClockDivider(uint32_t u32ModuleIdx);
void CLK_SysTickDelay(uint32_t u32USec);
void CLK_SysTickLongDelay(uint32_t u32USec);
# 580 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "../../../Library/StdDriver/inc\\uart.h" 1
# 468 "../../../Library/StdDriver/inc\\uart.h"
static inline void UART_CLEAR_RTS(UART_T *uart);
static inline void UART_SET_RTS(UART_T *uart);
static inline void UART_RESET_RXFIFO(UART_T *uart);
static inline void UART_RESET_TXFIFO(UART_T *uart);
# 481 "../../../Library/StdDriver/inc\\uart.h"
static inline void UART_CLEAR_RTS(UART_T *uart)
{
    uart->MODEM |= (0x1ul << (9));
    uart->MODEM &= ~(0x1ul << (1));
}
# 496 "../../../Library/StdDriver/inc\\uart.h"
static inline void UART_SET_RTS(UART_T *uart)
{
    uart->MODEM |= (0x1ul << (9)) | (0x1ul << (1));
}
# 510 "../../../Library/StdDriver/inc\\uart.h"
static inline void UART_RESET_RXFIFO(UART_T *uart)
{
    volatile int32_t i32Timeout = SystemCoreClock;

    while (!(((uart)->FIFOSTS & (0x1ul << (29)) )>> (29)))
    {
        if (--i32Timeout <= 0)
        {
            break;
        }
    }

    (uart)->FIFO |= (0x1ul << (1));

    i32Timeout = SystemCoreClock;

    while (((uart)->FIFO & (0x1ul << (1))) == (0x1ul << (1)))
    {
        if (--i32Timeout <= 0)
        {
            break;
        }
    }
}
# 544 "../../../Library/StdDriver/inc\\uart.h"
static inline void UART_RESET_TXFIFO(UART_T *uart)
{
    volatile int32_t i32Timeout = SystemCoreClock;

    while (!(((uart)->FIFOSTS & (0x1ul << (28))) >> (28)))
    {
        if (--i32Timeout <= 0)
        {
            break;
        }
    }

    (uart)->FIFO |= (0x1ul << (2));

    i32Timeout = SystemCoreClock;

    while (((uart)->FIFO & (0x1ul << (2))) == (0x1ul << (2)))
    {
        if (--i32Timeout <= 0)
        {
            break;
        }
    }
}

void UART_ClearIntFlag(UART_T *uart, uint32_t u32InterruptFlag);
void UART_Close(UART_T *uart);
void UART_DisableFlowCtrl(UART_T *uart);
void UART_DisableInt(UART_T *uart, uint32_t u32InterruptFlag);
void UART_EnableFlowCtrl(UART_T *uart);
void UART_EnableInt(UART_T *uart, uint32_t u32InterruptFlag);
void UART_Open(UART_T *uart, uint32_t u32BaudRate);
uint32_t UART_Read(UART_T *uart, uint8_t pu8RxBuf[], uint32_t u32ReadBytes);
void UART_SetLine_Config(UART_T *uart, uint32_t u32BaudRate, uint32_t u32DataWidth, uint32_t u32Parity, uint32_t u32StopBits);
void UART_SetTimeoutCnt(UART_T *uart, uint32_t u32TOC);
void UART_SelectIrDAMode(UART_T *uart, uint32_t u32BuadRate, uint32_t u32Direction);
void UART_SelectRS485Mode(UART_T *uart, uint32_t u32Mode, uint32_t u32Addr);
uint32_t UART_Write(UART_T *uart, uint8_t pu8TxBuf[], uint32_t u32WriteBytes);
void UART_SelectSingleWireMode(UART_T *uart);
# 581 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "../../../Library/StdDriver/inc\\fmc.h" 1
# 34 "../../../Library/StdDriver/inc\\fmc.h"
typedef enum
{
    eFMC_ERRCODE_SUCCESS = 0,
    eFMC_ERRCODE_CMD_TIMEOUT = -1,
    eFMC_ERRCODE_INVALID_PARAM = -2,
    eFMC_ERRCODE_CMD_FAIL = -3,
} E_FMC_ERRCODE;
extern int32_t g_FMC_i32ErrCode;
# 303 "../../../Library/StdDriver/inc\\fmc.h"
static inline uint32_t FMC_ReadUID(uint8_t u8Index);
static inline uint32_t FMC_ReadCID(void);
static inline uint32_t FMC_ReadPID(void);
static inline uint32_t FMC_ReadUCID(uint32_t u32Index);
static inline uint32_t FMC_ReadVBGCode(void);
static inline uint32_t FMC_ReadVTEMPCode(void);
static inline uint32_t FMC_ReadADCOffset(void);
static inline void FMC_SetVectorPageAddr(uint32_t u32PageAddr);
static inline uint32_t FMC_GetVECMAP(void);
static inline uint32_t FMC_GetCheckSum(uint32_t u32Addr, int32_t i32Size);
# 329 "../../../Library/StdDriver/inc\\fmc.h"
static inline uint32_t FMC_ReadUID(uint8_t u8Index)
{
    int32_t tout = ((SystemCoreClock/10)*2);

    g_FMC_i32ErrCode = eFMC_ERRCODE_SUCCESS;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPCMD = 0x04UL;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPADDR = ((uint32_t)u8Index << 2u);
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPDAT = 0u;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPTRG = (0x1ul << (0));




    while ((tout-- > 0) && (((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPTRG & (0x1ul << (0)))) {}

    if (tout <= 0)
    {
        g_FMC_i32ErrCode = eFMC_ERRCODE_CMD_TIMEOUT;
        return 0xFFFFFFFF;
    }

    return ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPDAT;
}
# 366 "../../../Library/StdDriver/inc\\fmc.h"
static inline uint32_t FMC_ReadCID(void)
{
    int32_t tout = ((SystemCoreClock/10)*2);

    g_FMC_i32ErrCode = eFMC_ERRCODE_SUCCESS;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPCMD = 0x0BUL;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPADDR = 0x0u;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPTRG = (0x1ul << (0));





    while ((tout-- > 0) && (((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPTRG & (0x1ul << (0)))) {}

    if (tout <= 0)
    {
        g_FMC_i32ErrCode = eFMC_ERRCODE_CMD_TIMEOUT;
        return 0xFFFFFFFF;
    }

    return ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPDAT;
}
# 403 "../../../Library/StdDriver/inc\\fmc.h"
static inline uint32_t FMC_ReadPID(void)
{
    int32_t tout = ((SystemCoreClock/10)*2);

    g_FMC_i32ErrCode = eFMC_ERRCODE_SUCCESS;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPCMD = 0x0CUL;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPADDR = 0x04u;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPTRG = (0x1ul << (0));





    while ((tout-- > 0) && (((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPTRG & (0x1ul << (0)))) {}

    if (tout <= 0)
    {
        g_FMC_i32ErrCode = eFMC_ERRCODE_CMD_TIMEOUT;
        return 0xFFFFFFFF;
    }

    return ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPDAT;
}
# 441 "../../../Library/StdDriver/inc\\fmc.h"
static inline uint32_t FMC_ReadUCID(uint32_t u32Index)
{
    int32_t tout = ((SystemCoreClock/10)*2);

    g_FMC_i32ErrCode = eFMC_ERRCODE_SUCCESS;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPCMD = 0x04UL;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPADDR = (0x04u * u32Index) + 0x10u;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPTRG = (0x1ul << (0));





    while ((tout-- > 0) && (((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPTRG & (0x1ul << (0)))) {}

    if (tout <= 0)
    {
        g_FMC_i32ErrCode = eFMC_ERRCODE_CMD_TIMEOUT;
        return 0xFFFFFFFF;
    }

    return ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPDAT;
}
# 477 "../../../Library/StdDriver/inc\\fmc.h"
static inline uint32_t FMC_ReadVBGCode(void)
{
    int32_t tout = ((SystemCoreClock/10)*2);

    g_FMC_i32ErrCode = eFMC_ERRCODE_SUCCESS;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPCMD = 0x04UL;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPADDR = 0x70;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPTRG = (0x1ul << (0));





    while ((tout-- > 0) && (((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPTRG & (0x1ul << (0)))) {}

    if (tout <= 0)
    {
        g_FMC_i32ErrCode = eFMC_ERRCODE_CMD_TIMEOUT;
        return 0xFFFFFFFF;
    }

    return ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPDAT;
}
# 513 "../../../Library/StdDriver/inc\\fmc.h"
static inline uint32_t FMC_ReadVTEMPCode(void)
{
    int32_t tout = ((SystemCoreClock/10)*2);

    g_FMC_i32ErrCode = eFMC_ERRCODE_SUCCESS;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPCMD = 0x04UL;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPADDR = 0x74;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPTRG = (0x1ul << (0));





    while ((tout-- > 0) && (((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPTRG & (0x1ul << (0)))) {}

    if (tout <= 0)
    {
        g_FMC_i32ErrCode = eFMC_ERRCODE_CMD_TIMEOUT;
        return 0xFFFFFFFF;
    }

    return ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPDAT;
}
# 549 "../../../Library/StdDriver/inc\\fmc.h"
static inline uint32_t FMC_ReadADCOffset(void)
{
    int32_t tout = ((SystemCoreClock/10)*2);

    g_FMC_i32ErrCode = eFMC_ERRCODE_SUCCESS;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPCMD = 0x04UL;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPADDR = 0x78;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPTRG = (0x1ul << (0));





    while ((tout-- > 0) && (((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPTRG & (0x1ul << (0)))) {}

    if (tout <= 0)
    {
        g_FMC_i32ErrCode = eFMC_ERRCODE_CMD_TIMEOUT;
        return 0xFFFFFFFF;
    }

    return ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPDAT;
}
# 585 "../../../Library/StdDriver/inc\\fmc.h"
static inline void FMC_SetVectorPageAddr(uint32_t u32PageAddr)
{
    int32_t tout = ((SystemCoreClock/10)*2);

    g_FMC_i32ErrCode = eFMC_ERRCODE_SUCCESS;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPCMD = 0x2EUL;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPADDR = u32PageAddr;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPTRG = (0x1ul << (0));





    while ((tout-- > 0) && (((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPTRG & (0x1ul << (0)))) {}

    if (tout <= 0)
    {
        g_FMC_i32ErrCode = eFMC_ERRCODE_CMD_TIMEOUT;
    }
}
# 618 "../../../Library/StdDriver/inc\\fmc.h"
static inline uint32_t FMC_GetVECMAP(void)
{
    return (((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPSTS & (0x1ffffful << (9)));
}
# 640 "../../../Library/StdDriver/inc\\fmc.h"
static inline uint32_t FMC_GetCheckSum(uint32_t u32Addr, int32_t i32Size)
{
    int32_t tout;

    g_FMC_i32ErrCode = eFMC_ERRCODE_SUCCESS;

    if ((u32Addr % 512UL) || (i32Size % 512UL))
    {
        g_FMC_i32ErrCode = eFMC_ERRCODE_INVALID_PARAM;
        return 0xFFFFFFFF;
    }

    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPCMD = 0x2DUL;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPADDR = u32Addr;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPDAT = (uint32_t)i32Size;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPTRG = (0x1ul << (0));




    tout = (SystemCoreClock*2);

    while ((tout-- > 0) && (((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPTRG & (0x1ul << (0)))) {}

    if (tout <= 0)
    {
        g_FMC_i32ErrCode = eFMC_ERRCODE_CMD_TIMEOUT;
        return 0xFFFFFFFF;
    }

    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPCMD = 0x0DUL;
    ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPTRG = (0x1ul << (0));

    tout = (SystemCoreClock*2);

    while ((tout-- > 0) && (((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPTRG & (0x1ul << (0)))) {}

    if (tout <= 0)
    {
        g_FMC_i32ErrCode = eFMC_ERRCODE_CMD_TIMEOUT;
        return 0xFFFFFFFF;
    }

    return ((FMC_T *) (((uint32_t)0x40000000UL) + 0x0C000UL))->ISPDAT;
}

void FMC_Open(void);
void FMC_Close(void);
int32_t FMC_ReadConfig(uint32_t u32Config[], uint32_t u32Count);
int32_t FMC_WriteConfig(uint32_t u32Config[], uint32_t u32Count);
void FMC_SetBootSource(int32_t i32BootSrc);
int32_t FMC_GetBootSource(void);
uint32_t FMC_CheckAllOne(uint32_t u32addr, uint32_t u32count);
uint32_t FMC_GetChkSum(uint32_t u32addr, uint32_t u32count);
int32_t FMC_Is_XOM_Actived(uint32_t xom_num);
int32_t FMC_Erase_XOM(uint32_t xom_num);
int32_t FMC_Erase(uint32_t u32Addr);
int32_t FMC_Config_XOM(uint32_t xom_num, uint32_t xom_base, uint8_t xom_page);
uint32_t FMC_Read(uint32_t u32Addr);
void FMC_Write(uint32_t u32Addr, uint32_t u32Data);
uint32_t FMC_Write128(uint32_t u32Addr, uint32_t pu32Buf[]);
# 582 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "../../../Library/StdDriver/inc\\bpwm.h" 1
# 317 "../../../Library/StdDriver/inc\\bpwm.h"
uint32_t BPWM_ConfigCaptureChannel(BPWM_T *bpwm, uint32_t u32ChannelNum, uint32_t u32UnitTimeNsec, uint32_t u32CaptureEdge);
uint32_t BPWM_ConfigOutputChannel(BPWM_T *bpwm, uint32_t u32ChannelNum, uint32_t u32Frequency, uint32_t u32DutyCycle);
void BPWM_Start(BPWM_T *bpwm, uint32_t u32ChannelMask);
void BPWM_Stop(BPWM_T *bpwm, uint32_t u32ChannelMask);
void BPWM_ForceStop(BPWM_T *bpwm, uint32_t u32ChannelMask);
void BPWM_EnableADCTrigger(BPWM_T *bpwm, uint32_t u32ChannelNum, uint32_t u32Condition);
void BPWM_DisableADCTrigger(BPWM_T *bpwm, uint32_t u32ChannelNum);
void BPWM_ClearADCTriggerFlag(BPWM_T *bpwm, uint32_t u32ChannelNum, uint32_t u32Condition);
uint32_t BPWM_GetADCTriggerFlag(BPWM_T *bpwm, uint32_t u32ChannelNum);
void BPWM_EnableCapture(BPWM_T *bpwm, uint32_t u32ChannelMask);
void BPWM_DisableCapture(BPWM_T *bpwm, uint32_t u32ChannelMask);
void BPWM_EnableOutput(BPWM_T *bpwm, uint32_t u32ChannelMask);
void BPWM_DisableOutput(BPWM_T *bpwm, uint32_t u32ChannelMask);
void BPWM_EnableCaptureInt(BPWM_T *bpwm, uint32_t u32ChannelNum, uint32_t u32Edge);
void BPWM_DisableCaptureInt(BPWM_T *bpwm, uint32_t u32ChannelNum, uint32_t u32Edge);
void BPWM_ClearCaptureIntFlag(BPWM_T *bpwm, uint32_t u32ChannelNum, uint32_t u32Edge);
uint32_t BPWM_GetCaptureIntFlag(BPWM_T *bpwm, uint32_t u32ChannelNum);
void BPWM_EnableDutyInt(BPWM_T *bpwm, uint32_t u32ChannelNum, uint32_t u32IntDutyType);
void BPWM_DisableDutyInt(BPWM_T *bpwm, uint32_t u32ChannelNum);
void BPWM_ClearDutyIntFlag(BPWM_T *bpwm, uint32_t u32ChannelNum);
uint32_t BPWM_GetDutyIntFlag(BPWM_T *bpwm, uint32_t u32ChannelNum);
void BPWM_EnablePeriodInt(BPWM_T *bpwm, uint32_t u32ChannelNum, uint32_t u32IntPeriodType);
void BPWM_DisablePeriodInt(BPWM_T *bpwm, uint32_t u32ChannelNum);
void BPWM_ClearPeriodIntFlag(BPWM_T *bpwm, uint32_t u32ChannelNum);
uint32_t BPWM_GetPeriodIntFlag(BPWM_T *bpwm, uint32_t u32ChannelNum);
void BPWM_EnableZeroInt(BPWM_T *bpwm, uint32_t u32ChannelNum);
void BPWM_DisableZeroInt(BPWM_T *bpwm, uint32_t u32ChannelNum);
void BPWM_ClearZeroIntFlag(BPWM_T *bpwm, uint32_t u32ChannelNum);
uint32_t BPWM_GetZeroIntFlag(BPWM_T *bpwm, uint32_t u32ChannelNum);
void BPWM_EnableLoadMode(BPWM_T *bpwm, uint32_t u32ChannelNum, uint32_t u32LoadMode);
void BPWM_DisableLoadMode(BPWM_T *bpwm, uint32_t u32ChannelNum, uint32_t u32LoadMode);
void BPWM_SetClockSource(BPWM_T *bpwm, uint32_t u32ChannelNum, uint32_t u32ClkSrcSel);
uint32_t BPWM_GetWrapAroundFlag(BPWM_T *bpwm, uint32_t u32ChannelNum);
void BPWM_ClearWrapAroundFlag(BPWM_T *bpwm, uint32_t u32ChannelNum);
# 583 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "../../../Library/StdDriver/inc\\canfd.h" 1
# 101 "../../../Library/StdDriver/inc\\canfd.h"
typedef enum
{
    eCANFD_BYTE8 = 0,
    eCANFD_BYTE12 = 1,
    eCANFD_BYTE16 = 2,
    eCANFD_BYTE20 = 3,
    eCANFD_BYTE24 = 4,
    eCANFD_BYTE32 = 5,
    eCANFD_BYTE48 = 6,
    eCANFD_BYTE64 = 7
} E_CANFD_DATA_FIELD_SIZE;


typedef enum
{
    eCANFD_QUEUE_MODE = 0,
    eCANFD_FIFO_MODE = 1
} E_CANFD_MODE;


typedef struct
{
    E_CANFD_DATA_FIELD_SIZE eDataFieldSize;
    E_CANFD_MODE eModeSel;
    uint32_t u32ElemCnt;
    uint32_t u32DBufNumber;
} CANFD_TX_BUF_CONFIG_T;



typedef struct
{
    uint32_t u32BitRate;
    uint16_t u16TDCOffset;
    uint16_t u16TDCFltrWin;
    uint8_t u8TDC;
} CANFD_NBT_CONFIG_T;



typedef struct
{
    uint32_t u32BitRate;
    uint16_t u16TDCOffset;
    uint16_t u16TDCFltrWin;
    uint8_t u8TDC;
} CANFD_DBT_CONFIG_T;


typedef struct
{
    uint8_t u8PreDivider;
    uint16_t u16NominalPrescaler;
    uint8_t u8NominalRJumpwidth;
    uint8_t u8NominalPhaseSeg1;
    uint8_t u8NominalPhaseSeg2;
    uint8_t u8NominalPropSeg;
    uint8_t u8DataPrescaler;
    uint8_t u8DataRJumpwidth;
    uint8_t u8DataPhaseSeg1;
    uint8_t u8DataPhaseSeg2;
    uint8_t u8DataPropSeg;

} CANFD_TIMEING_CONFIG_T;


typedef struct
{
    CANFD_NBT_CONFIG_T sNormBitRate;
    CANFD_DBT_CONFIG_T sDataBitRate;
    CANFD_TIMEING_CONFIG_T sConfigBitTing;
    uint8_t bFDEn;
    uint8_t bBitRateSwitch;
    uint8_t bEnableLoopBack;
} CANFD_FD_BT_CONFIG_T;


typedef struct
{
    uint32_t u32SIDFC_FLSSA;
    uint32_t u32XIDFC_FLESA;
    uint32_t u32RXF0C_F0SA;
    uint32_t u32RXF1C_F1SA;
    uint32_t u32RXBC_RBSA;
    uint32_t u32TXEFC_EFSA;
    uint32_t u32TXBC_TBSA;
} CANFD_RAM_PART_T;


typedef struct
{
    uint32_t u32SIDFC;
    uint32_t u32XIDFC;
    uint32_t u32RxFifo0;
    uint32_t u32RxFifo1;
    uint32_t u32RxBuf;
    uint32_t u32TxBuf;
    uint32_t u32TxEventFifo;
} CANFD_ELEM_SIZE_T;


typedef struct
{
    CANFD_FD_BT_CONFIG_T sBtConfig;
    CANFD_RAM_PART_T sMRamStartAddr;
    CANFD_ELEM_SIZE_T sElemSize;
    CANFD_TX_BUF_CONFIG_T sTxConfig;
    uint32_t u32MRamSize;
} CANFD_FD_T;


typedef enum
{
    eCANFD_SID = 0,
    eCANFD_XID = 1
} E_CANFD_ID_TYPE;


typedef enum
{
    eCANFD_RX_FIFO_0 = 0,
    eCANFD_RX_FIFO_1 = 1,
    eCANFD_RX_DBUF = 2
} E_CANFD_RX_BUF_TYPE;


typedef enum
{
    eCANFD_SYNC = 0,
    eCANFD_IDLE = 1,
    eCANFD_RECEIVER = 2,
    eCANFD_TRANSMITTER = 3
} E_CANFD_COMMUNICATION_STATE;



typedef enum
{
    eCANFD_TRANSMIT_FAIL = 0,
    eCANFD_TRANSMIT_SUCCESS = 1,
    eCANFD_TRANSMIT_TIMEOUT = 2
} E_CANFD_TRANSMIT_STATE;


typedef enum
{
    eCANFD_RECEIVE_EMPTY = 0,
    eCANFD_RECEIVE_SUCCESS = 1,
    eCANFD_RECEIVE_SUCCESS_AND_BUFFER_FULL = 2

} E_CANFD_RECEIVE_STATE;



typedef struct
{
    E_CANFD_RX_BUF_TYPE eRxBuf;
    uint32_t u32BufIdx;
} CANFD_RX_INFO_T;


typedef enum
{
    eCANFD_DATA_FRM = 0,
    eCANFD_REMOTE_FRM = 1
} E_CANFD_FRM_TYPE;


typedef struct
{
    E_CANFD_ID_TYPE eIdType;
    CANFD_RX_INFO_T sRxInfo;
    E_CANFD_FRM_TYPE eFrmType;
    uint32_t u32Id;
    uint32_t u32DLC;
    union
    {
        uint32_t au32Data[(64 / 4)];
        uint8_t au8Data[64];
    };

    uint8_t u8MsgMarker;
    uint8_t bFDFormat;
    uint8_t bBitRateSwitch;
    uint8_t bErrStaInd;
    uint8_t bEvntFifoCon;
} CANFD_FD_MSG_T;



typedef struct
{
    uint32_t u32Id;
    uint32_t u32Config;
    union
    {
        uint32_t au32Data[(64 / 4)];
        uint8_t au8Data[64];
    };
} CANFD_BUF_T;


typedef struct
{
    union
    {
        struct
        {
            uint32_t SFID2 : 11;
            uint32_t reserved1 : 5;
            uint32_t SFID1 : 11;
            uint32_t SFEC : 3;
            uint32_t SFT : 2;
        };

        struct
        {
            uint32_t VALUE;
        };
    };
} CANFD_STD_FILTER_T;


typedef struct
{
    union
    {
        struct
        {
            uint32_t EFID1 : 29;
            uint32_t EFEC : 3;
            uint32_t EFID2 : 29;
            uint32_t reserved1 : 1;
            uint32_t EFT : 2;
        };

        struct
        {
            uint32_t LOWVALUE;
            uint32_t HIGHVALUE;
        };
    };
} CANFD_EXT_FILTER_T;


typedef enum
{
    eCANFD_ACC_NON_MATCH_FRM_RX_FIFO0 = 0x0,
    eCANFD_ACC_NON_MATCH_FRM_RX_FIFO1 = 0x1,
    eCANFD_REJ_NON_MATCH_FRM = 0x3
} E_CANFD_ACC_NON_MATCH_FRM;



typedef enum
{
    eCANFD_SID_FLTR_TYPE_RANGE = 0x0,
    eCANFD_SID_FLTR_TYPE_DUAL = 0x1,
    eCANFD_SID_FLTR_TYPE_CLASSIC = 0x2,
    eCANFD_SID_FLTR_TYPE_DIS = 0x3
} E_CANFD_SID_FLTR_ELEM_TYPE;


typedef enum
{
    eCANFD_XID_FLTR_TYPE_RANGE = 0x0,
    eCANFD_XID_FLTR_TYPE_DUAL = 0x1,
    eCANFD_XID_FLTR_TYPE_CLASSIC = 0x2,
    eCANFD_XID_FLTR_TYPE_RANGE_XIDAM_NOT_APP = 0x3
} E_CANFD_XID_FLTR_ELEM_TYPE;


typedef enum
{
    eCANFD_FLTR_ELEM_DIS = 0x0,
    eCANFD_FLTR_ELEM_STO_FIFO0 = 0x1,
    eCANFD_FLTR_ELEM_STO_FIFO1 = 0x2,
    eCANFD_FLTR_ELEM_REJ_ID = 0x3,
    eCANFD_FLTR_ELEM_SET_PRI = 0x4,
    eCANFD_FLTR_ELEM_SET_PRI_STO_FIFO0 = 0x5,
    eCANFD_FLTR_ELEM_SET_PRI_STO_FIFO1 = 0x6,
    eCANFD_FLTR_ELEM_STO_RX_BUF_OR_DBG_MSG = 0x7
} E_CANFD_FLTR_CONFIG;


typedef struct
{
    E_CANFD_ID_TYPE eIdType;
    uint32_t u32Id;
    uint32_t u32DLC;
    uint32_t u32TxTs;
    uint32_t u32MsgMarker;
    uint8_t bErrStaInd;
    uint8_t bRemote;
    uint8_t bFDFormat;
    uint8_t bBitRateSwitch;
} CANFD_TX_EVNT_ELEM_T;


void CANFD_Open(CANFD_T *canfd, CANFD_FD_T *psCanfdStr);
void CANFD_Close(CANFD_T *canfd);
void CANFD_EnableInt(CANFD_T *canfd, uint32_t u32IntLine0, uint32_t u32IntLine1, uint32_t u32TXBTIE, uint32_t u32TXBCIE);
void CANFD_DisableInt(CANFD_T *canfd, uint32_t u32IntLine0, uint32_t u32IntLine1, uint32_t u32TXBTIE, uint32_t u32TXBCIE);
uint32_t CANFD_TransmitTxMsg(CANFD_T *canfd, uint32_t u32TxBufIdx, CANFD_FD_MSG_T *psTxMsg);
uint32_t CANFD_TransmitDMsg(CANFD_T *canfd, uint32_t u32TxBufIdx, CANFD_FD_MSG_T *psTxMsg);
void CANFD_SetGFC(CANFD_T *canfd, E_CANFD_ACC_NON_MATCH_FRM eNMStdFrm, E_CANFD_ACC_NON_MATCH_FRM eEMExtFrm, uint32_t u32RejRmtStdFrm, uint32_t u32RejRmtExtFrm);
void CANFD_SetSIDFltr(CANFD_T *canfd, uint32_t u32FltrIdx, uint32_t u32Filter);
void CANFD_SetXIDFltr(CANFD_T *canfd, uint32_t u32FltrIdx, uint32_t u32FilterLow, uint32_t u32FilterHigh);
uint32_t CANFD_ReadRxBufMsg(CANFD_T *canfd, uint8_t u8MbIdx, CANFD_FD_MSG_T *psMsgBuf);
uint32_t CANFD_ReadRxFifoMsg(CANFD_T *canfd, uint8_t u8FifoIdx, CANFD_FD_MSG_T *psMsgBuf);
void CANFD_CopyDBufToMsgBuf(CANFD_BUF_T *psRxBuffer, CANFD_FD_MSG_T *psMsgBuf);
void CANFD_CopyRxFifoToMsgBuf(CANFD_BUF_T *psRxBuf, CANFD_FD_MSG_T *psMsgBuf);
uint32_t CANFD_GetRxFifoWaterLvl(CANFD_T *canfd, uint32_t u32RxFifoNum);
void CANFD_TxBufCancelReq(CANFD_T *canfd, uint32_t u32TxBufIdx);
uint32_t CANFD_IsTxBufCancelFin(CANFD_T *canfd, uint32_t u32TxBufIdx);
uint32_t CANFD_IsTxBufTransmitOccur(CANFD_T *canfd, uint32_t u32TxBufIdx);
uint32_t CANFD_GetTxEvntFifoWaterLvl(CANFD_T *canfd);
void CANFD_CopyTxEvntFifoToUsrBuf(CANFD_T *canfd, uint32_t u32TxEvntNum, CANFD_TX_EVNT_ELEM_T *psTxEvntElem);
void CANFD_GetBusErrCount(CANFD_T *canfd, uint8_t *pu8TxErrBuf, uint8_t *pu8RxErrBuf);
void CANFD_RunToNormal(CANFD_T *canfd, uint8_t u8Enable);
void CANFD_GetDefaultConfig(CANFD_FD_T *psConfig, uint8_t u8OpMode);
void CANFD_ClearStatusFlag(CANFD_T *canfd, uint32_t u32InterruptFlag);
uint32_t CANFD_GetStatusFlag(CANFD_T *canfd, uint32_t u32IntTypeFlag);
uint32_t CANFD_ReadReg(volatile const uint32_t *pu32RegAddr);
# 584 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "../../../Library/StdDriver/inc\\crc.h" 1
# 106 "../../../Library/StdDriver/inc\\crc.h"
void CRC_Open(uint32_t u32Mode, uint32_t u32Attribute, uint32_t u32Seed, uint32_t u32DataLen);
uint32_t CRC_GetChecksum(void);
# 585 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "../../../Library/StdDriver/inc\\eadc.h" 1
# 101 "../../../Library/StdDriver/inc\\eadc.h"
extern int32_t g_EADC_i32ErrCode;
# 649 "../../../Library/StdDriver/inc\\eadc.h"
void EADC_Open(EADC_T *eadc, uint32_t u32InputMode);
void EADC_Close(EADC_T *eadc);
void EADC_ConfigSampleModule(EADC_T *eadc, uint32_t u32ModuleNum, uint32_t u32TriggerSource, uint32_t u32Channel);
void EADC_SetTriggerDelayTime(EADC_T *eadc, uint32_t u32ModuleNum, uint32_t u32TriggerDelayTime, uint32_t u32DelayClockDivider);
void EADC_SetExtendSampleTime(EADC_T *eadc, uint32_t u32ModuleNum, uint32_t u32ExtendSampleTime);
# 586 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "../../../Library/StdDriver/inc\\gpio.h" 1
# 445 "../../../Library/StdDriver/inc\\gpio.h"
void GPIO_SetMode(GPIO_T *port, uint32_t u32PinMask, uint32_t u32Mode);
void GPIO_EnableInt(GPIO_T *port, uint32_t u32Pin, uint32_t u32IntAttribs);
void GPIO_DisableInt(GPIO_T *port, uint32_t u32Pin);
void GPIO_SetSlewCtl(GPIO_T *port, uint32_t u32PinMask, uint32_t u32Mode);
void GPIO_SetPullCtl(GPIO_T *port, uint32_t u32PinMask, uint32_t u32Mode);
# 587 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "../../../Library/StdDriver/inc\\i2c.h" 1
# 61 "../../../Library/StdDriver/inc\\i2c.h"
extern int32_t g_I2C_i32ErrCode;
# 241 "../../../Library/StdDriver/inc\\i2c.h"
static inline void I2C_STOP(I2C_T *i2c);
# 251 "../../../Library/StdDriver/inc\\i2c.h"
static inline void I2C_STOP(I2C_T *i2c)
{
    uint32_t u32TimeOutCount = SystemCoreClock;

    (i2c)->CTL0 |= ((0x1ul << (3)) | (0x1ul << (4)));

    while (i2c->CTL0 & (0x1ul << (4)))
    {
        if (--u32TimeOutCount == 0) break;
    }
}

void I2C_ClearTimeoutFlag(I2C_T *i2c);
void I2C_Close(I2C_T *i2c);
void I2C_Trigger(I2C_T *i2c, uint8_t u8Start, uint8_t u8Stop, uint8_t u8Si, uint8_t u8Ack);
void I2C_DisableInt(I2C_T *i2c);
void I2C_EnableInt(I2C_T *i2c);
uint32_t I2C_GetBusClockFreq(I2C_T *i2c);
uint32_t I2C_SetBusClockFreq(I2C_T *i2c, uint32_t u32BusClock);
uint32_t I2C_GetIntFlag(I2C_T *i2c);
uint32_t I2C_GetStatus(I2C_T *i2c);
uint32_t I2C_Open(I2C_T *i2c, uint32_t u32BusClock);
uint8_t I2C_GetData(I2C_T *i2c);
void I2C_SetSlaveAddr(I2C_T *i2c, uint8_t u8SlaveNo, uint16_t u16SlaveAddr, uint8_t u8GCMode);
void I2C_SetSlaveAddrMask(I2C_T *i2c, uint8_t u8SlaveNo, uint16_t u16SlaveAddrMask);
void I2C_EnableTimeout(I2C_T *i2c, uint8_t u8LongTimeout);
void I2C_DisableTimeout(I2C_T *i2c);
void I2C_EnableWakeup(I2C_T *i2c);
void I2C_DisableWakeup(I2C_T *i2c);
void I2C_SetData(I2C_T *i2c, uint8_t u8Data);
uint8_t I2C_WriteByte(I2C_T *i2c, uint8_t u8SlaveAddr, const uint8_t u8Data);
uint32_t I2C_WriteMultiBytes(I2C_T *i2c, uint8_t u8SlaveAddr, const uint8_t *pu8Data, uint32_t u32wLen);
uint8_t I2C_WriteByteOneReg(I2C_T *i2c, uint8_t u8SlaveAddr, uint8_t u8DataAddr, const uint8_t u8Data);
uint32_t I2C_WriteMultiBytesOneReg(I2C_T *i2c, uint8_t u8SlaveAddr, uint8_t u8DataAddr, const uint8_t *pu8Data, uint32_t u32wLen);
uint8_t I2C_WriteByteTwoRegs(I2C_T *i2c, uint8_t u8SlaveAddr, uint16_t u16DataAddr, const uint8_t u8Data);
uint32_t I2C_WriteMultiBytesTwoRegs(I2C_T *i2c, uint8_t u8SlaveAddr, uint16_t u16DataAddr, const uint8_t *pu8Data, uint32_t u32wLen);
uint8_t I2C_ReadByte(I2C_T *i2c, uint8_t u8SlaveAddr);
uint32_t I2C_ReadMultiBytes(I2C_T *i2c, uint8_t u8SlaveAddr, uint8_t *pu8rData, uint32_t u32rLen);
uint8_t I2C_ReadByteOneReg(I2C_T *i2c, uint8_t u8SlaveAddr, uint8_t u8DataAddr);
uint32_t I2C_ReadMultiBytesOneReg(I2C_T *i2c, uint8_t u8SlaveAddr, uint8_t u8DataAddr, uint8_t *pu8rData, uint32_t u32rLen);
uint8_t I2C_ReadByteTwoRegs(I2C_T *i2c, uint8_t u8SlaveAddr, uint16_t u16DataAddr);
uint32_t I2C_ReadMultiBytesTwoRegs(I2C_T *i2c, uint8_t u8SlaveAddr, uint16_t u16DataAddr, uint8_t *pu8rData, uint32_t u32rLen);
# 588 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "../../../Library/StdDriver/inc\\pdma.h" 1
# 303 "../../../Library/StdDriver/inc\\pdma.h"
void PDMA_Open(PDMA_T *pdma, uint32_t u32Mask);
void PDMA_Close(PDMA_T *pdma);
void PDMA_SetTransferCnt(PDMA_T *pdma, uint32_t u32Ch, uint32_t u32Width, uint32_t u32TransCount);
void PDMA_SetTransferAddr(PDMA_T *pdma, uint32_t u32Ch, uint32_t u32SrcAddr, uint32_t u32SrcCtrl, uint32_t u32DstAddr, uint32_t u32DstCtrl);
void PDMA_SetTransferMode(PDMA_T *pdma, uint32_t u32Ch, uint32_t u32Peripheral, uint32_t u32ScatterEn, uint32_t u32DescAddr);
void PDMA_SetBurstType(PDMA_T *pdma, uint32_t u32Ch, uint32_t u32BurstType, uint32_t u32BurstSize);
void PDMA_EnableTimeout(PDMA_T *pdma, uint32_t u32Mask);
void PDMA_DisableTimeout(PDMA_T *pdma, uint32_t u32Mask);
void PDMA_SetTimeOut(PDMA_T *pdma, uint32_t u32Ch, uint32_t u32OnOff, uint32_t u32TimeOutCnt);
void PDMA_Trigger(PDMA_T *pdma, uint32_t u32Ch);
void PDMA_EnableInt(PDMA_T *pdma, uint32_t u32Ch, uint32_t u32Mask);
void PDMA_DisableInt(PDMA_T *pdma, uint32_t u32Ch, uint32_t u32Mask);
# 589 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "../../../Library/StdDriver/inc\\rtc.h" 1
# 119 "../../../Library/StdDriver/inc\\rtc.h"
typedef struct
{
    uint32_t u32Year;
    uint32_t u32Month;
    uint32_t u32Day;
    uint32_t u32DayOfWeek;
    uint32_t u32Hour;
    uint32_t u32Minute;
    uint32_t u32Second;
    uint32_t u32TimeScale;
    uint32_t u32AmPm;
} S_RTC_TIME_DATA_T;
# 235 "../../../Library/StdDriver/inc\\rtc.h"
int32_t RTC_Open(S_RTC_TIME_DATA_T *psPt);
void RTC_Close(void);
void RTC_32KCalibration(int32_t i32FrequencyX10000);
void RTC_GetDateAndTime(S_RTC_TIME_DATA_T *psPt);
void RTC_GetAlarmDateAndTime(S_RTC_TIME_DATA_T *psPt);
void RTC_SetDateAndTime(S_RTC_TIME_DATA_T *psPt);
void RTC_SetAlarmDateAndTime(S_RTC_TIME_DATA_T *psPt);
void RTC_SetDate(uint32_t u32Year, uint32_t u32Month, uint32_t u32Day, uint32_t u32DayOfWeek);
void RTC_SetTime(uint32_t u32Hour, uint32_t u32Minute, uint32_t u32Second, uint32_t u32TimeMode, uint32_t u32AmPm);
void RTC_SetAlarmDate(uint32_t u32Year, uint32_t u32Month, uint32_t u32Day);
void RTC_SetAlarmTime(uint32_t u32Hour, uint32_t u32Minute, uint32_t u32Second, uint32_t u32TimeMode, uint32_t u32AmPm);
void RTC_SetAlarmDateMask(uint8_t u8IsTenYMsk, uint8_t u8IsYMsk, uint8_t u8IsTenMMsk, uint8_t u8IsMMsk, uint8_t u8IsTenDMsk, uint8_t u8IsDMsk);
void RTC_SetAlarmTimeMask(uint8_t u8IsTenHMsk, uint8_t u8IsHMsk, uint8_t u8IsTenMMsk, uint8_t u8IsMMsk, uint8_t u8IsTenSMsk, uint8_t u8IsSMsk);
uint32_t RTC_GetDayOfWeek(void);
void RTC_SetTickPeriod(uint32_t u32TickSelection);
void RTC_EnableInt(uint32_t u32IntFlagMask);
void RTC_DisableInt(uint32_t u32IntFlagMask);
# 590 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "../../../Library/StdDriver/inc\\spi.h" 1
# 367 "../../../Library/StdDriver/inc\\spi.h"
static inline void SPII2S_ENABLE_TX_ZCD(SPI_T *i2s, uint32_t u32ChMask);
static inline void SPII2S_DISABLE_TX_ZCD(SPI_T *i2s, uint32_t u32ChMask);
static inline void SPII2S_SET_MONO_RX_CHANNEL(SPI_T *i2s, uint32_t u32Ch);
# 379 "../../../Library/StdDriver/inc\\spi.h"
static inline void SPII2S_ENABLE_TX_ZCD(SPI_T *i2s, uint32_t u32ChMask)
{
    if (u32ChMask == (0UL))
    {
        i2s->I2SCTL |= (0x1ul << (16));
    }
    else
    {
        i2s->I2SCTL |= (0x1ul << (17));
    }
}
# 399 "../../../Library/StdDriver/inc\\spi.h"
static inline void SPII2S_DISABLE_TX_ZCD(SPI_T *i2s, uint32_t u32ChMask)
{
    if (u32ChMask == (0UL))
    {
        i2s->I2SCTL &= ~(0x1ul << (16));
    }
    else
    {
        i2s->I2SCTL &= ~(0x1ul << (17));
    }
}
# 516 "../../../Library/StdDriver/inc\\spi.h"
static inline void SPII2S_SET_MONO_RX_CHANNEL(SPI_T *i2s, uint32_t u32Ch)
{
    u32Ch == (0x1ul << (23)) ?
    (i2s->I2SCTL |= (0x1ul << (23))) :
    (i2s->I2SCTL &= ~(0x1ul << (23)));
}
# 582 "../../../Library/StdDriver/inc\\spi.h"
uint32_t SPI_Open(SPI_T *spi, uint32_t u32MasterSlave, uint32_t u32SPIMode, uint32_t u32DataWidth, uint32_t u32BusClock);
void SPI_Close(SPI_T *spi);
void SPI_ClearRxFIFO(SPI_T *spi);
void SPI_ClearTxFIFO(SPI_T *spi);
void SPI_DisableAutoSS(SPI_T *spi);
void SPI_EnableAutoSS(SPI_T *spi, uint32_t u32SSPinMask, uint32_t u32ActiveLevel);
uint32_t SPI_SetBusClock(SPI_T *spi, uint32_t u32BusClock);
void SPI_SetFIFO(SPI_T *spi, uint32_t u32TxThreshold, uint32_t u32RxThreshold);
uint32_t SPI_GetBusClock(SPI_T *spi);
void SPI_EnableInt(SPI_T *spi, uint32_t u32Mask);
void SPI_DisableInt(SPI_T *spi, uint32_t u32Mask);
uint32_t SPI_GetIntFlag(SPI_T *spi, uint32_t u32Mask);
void SPI_ClearIntFlag(SPI_T *spi, uint32_t u32Mask);
uint32_t SPI_GetStatus(SPI_T *spi, uint32_t u32Mask);
uint32_t SPI_GetStatus2(SPI_T *spi, uint32_t u32Mask);

uint32_t SPII2S_Open(SPI_T *i2s, uint32_t u32MasterSlave, uint32_t u32SampleRate, uint32_t u32WordWidth, uint32_t u32Channels, uint32_t u32DataFormat);
void SPII2S_Close(SPI_T *i2s);
void SPII2S_EnableInt(SPI_T *i2s, uint32_t u32Mask);
void SPII2S_DisableInt(SPI_T *i2s, uint32_t u32Mask);
uint32_t SPII2S_EnableMCLK(SPI_T *i2s, uint32_t u32BusClock);
void SPII2S_DisableMCLK(SPI_T *i2s);
void SPII2S_SetFIFO(SPI_T *i2s, uint32_t u32TxThreshold, uint32_t u32RxThreshold);
# 591 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "../../../Library/StdDriver/inc\\timer.h" 1
# 173 "../../../Library/StdDriver/inc\\timer.h"
static inline void TIMER_Start(TIMER_T *timer);
static inline void TIMER_Stop(TIMER_T *timer);
static inline void TIMER_EnableWakeup(TIMER_T *timer);
static inline void TIMER_DisableWakeup(TIMER_T *timer);
static inline void TIMER_StartCapture(TIMER_T *timer);
static inline void TIMER_StopCapture(TIMER_T *timer);
static inline void TIMER_EnableCaptureDebounce(TIMER_T *timer);
static inline void TIMER_DisableCaptureDebounce(TIMER_T *timer);
static inline void TIMER_EnableEventCounterDebounce(TIMER_T *timer);
static inline void TIMER_DisableEventCounterDebounce(TIMER_T *timer);
static inline void TIMER_EnableInt(TIMER_T *timer);
static inline void TIMER_DisableInt(TIMER_T *timer);
static inline void TIMER_EnableCaptureInt(TIMER_T *timer);
static inline void TIMER_DisableCaptureInt(TIMER_T *timer);
static inline uint32_t TIMER_GetIntFlag(TIMER_T *timer);
static inline void TIMER_ClearIntFlag(TIMER_T *timer);
static inline uint32_t TIMER_GetCaptureIntFlag(TIMER_T *timer);
static inline void TIMER_ClearCaptureIntFlag(TIMER_T *timer);
static inline uint32_t TIMER_GetWakeupFlag(TIMER_T *timer);
static inline void TIMER_ClearWakeupFlag(TIMER_T *timer);
static inline uint32_t TIMER_GetCaptureData(TIMER_T *timer);
static inline uint32_t TIMER_GetCounter(TIMER_T *timer);
# 204 "../../../Library/StdDriver/inc\\timer.h"
static inline void TIMER_Start(TIMER_T *timer)
{
    timer->CTL |= (0x1ul << (30));
}
# 217 "../../../Library/StdDriver/inc\\timer.h"
static inline void TIMER_Stop(TIMER_T *timer)
{
    timer->CTL &= ~(0x1ul << (30));
}
# 231 "../../../Library/StdDriver/inc\\timer.h"
static inline void TIMER_EnableWakeup(TIMER_T *timer)
{
    timer->CTL |= (0x1ul << (23));
}
# 244 "../../../Library/StdDriver/inc\\timer.h"
static inline void TIMER_DisableWakeup(TIMER_T *timer)
{
    timer->CTL &= ~(0x1ul << (23));
}
# 257 "../../../Library/StdDriver/inc\\timer.h"
static inline void TIMER_StartCapture(TIMER_T *timer)
{
    timer->EXTCTL |= (0x1ul << (3));
}
# 270 "../../../Library/StdDriver/inc\\timer.h"
static inline void TIMER_StopCapture(TIMER_T *timer)
{
    timer->EXTCTL &= ~(0x1ul << (3));
}
# 283 "../../../Library/StdDriver/inc\\timer.h"
static inline void TIMER_EnableCaptureDebounce(TIMER_T *timer)
{
    timer->EXTCTL |= (0x1ul << (6));
}
# 296 "../../../Library/StdDriver/inc\\timer.h"
static inline void TIMER_DisableCaptureDebounce(TIMER_T *timer)
{
    timer->EXTCTL &= ~(0x1ul << (6));
}
# 309 "../../../Library/StdDriver/inc\\timer.h"
static inline void TIMER_EnableEventCounterDebounce(TIMER_T *timer)
{
    timer->EXTCTL |= (0x1ul << (7));
}
# 322 "../../../Library/StdDriver/inc\\timer.h"
static inline void TIMER_DisableEventCounterDebounce(TIMER_T *timer)
{
    timer->EXTCTL &= ~(0x1ul << (7));
}
# 335 "../../../Library/StdDriver/inc\\timer.h"
static inline void TIMER_EnableInt(TIMER_T *timer)
{
    timer->CTL |= (0x1ul << (29));
}
# 348 "../../../Library/StdDriver/inc\\timer.h"
static inline void TIMER_DisableInt(TIMER_T *timer)
{
    timer->CTL &= ~(0x1ul << (29));
}
# 361 "../../../Library/StdDriver/inc\\timer.h"
static inline void TIMER_EnableCaptureInt(TIMER_T *timer)
{
    timer->EXTCTL |= (0x1ul << (5));
}
# 374 "../../../Library/StdDriver/inc\\timer.h"
static inline void TIMER_DisableCaptureInt(TIMER_T *timer)
{
    timer->EXTCTL &= ~(0x1ul << (5));
}
# 389 "../../../Library/StdDriver/inc\\timer.h"
static inline uint32_t TIMER_GetIntFlag(TIMER_T *timer)
{
    return ((timer->INTSTS & (0x1ul << (0))) ? 1 : 0);
}
# 402 "../../../Library/StdDriver/inc\\timer.h"
static inline void TIMER_ClearIntFlag(TIMER_T *timer)
{
    timer->INTSTS = (0x1ul << (0));
}
# 417 "../../../Library/StdDriver/inc\\timer.h"
static inline uint32_t TIMER_GetCaptureIntFlag(TIMER_T *timer)
{
    return timer->EINTSTS;
}
# 430 "../../../Library/StdDriver/inc\\timer.h"
static inline void TIMER_ClearCaptureIntFlag(TIMER_T *timer)
{
    timer->EINTSTS = (0x1ul << (0));
}
# 445 "../../../Library/StdDriver/inc\\timer.h"
static inline uint32_t TIMER_GetWakeupFlag(TIMER_T *timer)
{
    return (timer->INTSTS & (0x1ul << (1)) ? 1 : 0);
}
# 458 "../../../Library/StdDriver/inc\\timer.h"
static inline void TIMER_ClearWakeupFlag(TIMER_T *timer)
{
    timer->INTSTS = (0x1ul << (1));
}
# 472 "../../../Library/StdDriver/inc\\timer.h"
static inline uint32_t TIMER_GetCaptureData(TIMER_T *timer)
{
    return timer->CAP;
}
# 486 "../../../Library/StdDriver/inc\\timer.h"
static inline uint32_t TIMER_GetCounter(TIMER_T *timer)
{
    return timer->CNT;
}

uint32_t TIMER_Open(TIMER_T *timer, uint32_t u32Mode, uint32_t u32Freq);
void TIMER_Close(TIMER_T *timer);
int32_t TIMER_Delay(TIMER_T *timer, uint32_t u32Usec);
void TIMER_EnableCapture(TIMER_T *timer, uint32_t u32CapMode, uint32_t u32Edge);
void TIMER_CaptureSelect(TIMER_T *timer, uint32_t u32Src);
void TIMER_DisableCapture(TIMER_T *timer);
void TIMER_SetTriggerSource(TIMER_T *timer, uint32_t u32Src);
void TIMER_SetTriggerTarget(TIMER_T *timer, uint32_t u32Mask);
void TIMER_EnableEventCounter(TIMER_T *timer, uint32_t u32Edge);
void TIMER_DisableEventCounter(TIMER_T *timer);
uint32_t TIMER_GetModuleClock(TIMER_T *timer);
void TIMER_EnableFreqCounter(TIMER_T *timer, uint32_t u32DropCount, uint32_t u32Timeout, uint32_t u32EnableInt);
void TIMER_DisableFreqCounter(TIMER_T *timer);
int32_t TIMER_ResetCounter(TIMER_T *timer);
# 592 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "../../../Library/StdDriver/inc\\usci_i2c.h" 1
# 34 "../../../Library/StdDriver/inc\\usci_i2c.h"
enum UI2C_MASTER_EVENT
{
    MASTER_SEND_ADDRESS = 10,
    MASTER_SEND_H_WR_ADDRESS,
    MASTER_SEND_H_RD_ADDRESS,
    MASTER_SEND_L_ADDRESS,
    MASTER_SEND_DATA,
    MASTER_SEND_REPEAT_START,
    MASTER_READ_DATA,
    MASTER_STOP,
    MASTER_SEND_START
};




enum UI2C_SLAVE_EVENT
{
    SLAVE_ADDRESS_ACK = 100,
    SLAVE_H_WR_ADDRESS_ACK,
    SLAVE_L_WR_ADDRESS_ACK,
    SLAVE_GET_DATA,
    SLAVE_SEND_DATA,
    SLAVE_H_RD_ADDRESS_ACK,
    SLAVE_L_RD_ADDRESS_ACK
};
# 280 "../../../Library/StdDriver/inc\\usci_i2c.h"
uint32_t UI2C_Open(UI2C_T *psUI2C, uint32_t u32BusClock);
void UI2C_Close(UI2C_T *psUI2C);
void UI2C_ClearTimeoutFlag(UI2C_T *psUI2C);
void UI2C_Trigger(UI2C_T *psUI2C, uint8_t u8Start, uint8_t u8Stop, uint8_t u8Ptrg, uint8_t u8Ack);
void UI2C_DisableInt(UI2C_T *psUI2C, uint32_t u32Mask);
void UI2C_EnableInt(UI2C_T *psUI2C, uint32_t u32Mask);
uint32_t UI2C_GetBusClockFreq(UI2C_T *psUI2C);
uint32_t UI2C_SetBusClockFreq(UI2C_T *psUI2C, uint32_t u32BusClock);
uint32_t UI2C_GetIntFlag(UI2C_T *psUI2C, uint32_t u32Mask);
void UI2C_ClearIntFlag(UI2C_T *psUI2C, uint32_t u32Mask);
uint32_t UI2C_GetData(UI2C_T *psUI2C);
void UI2C_SetData(UI2C_T *psUI2C, uint8_t u8Data);
void UI2C_SetSlaveAddr(UI2C_T *psUI2C, uint8_t u8SlaveNo, uint16_t u16SlaveAddr, uint8_t u8GCMode);
void UI2C_SetSlaveAddrMask(UI2C_T *psUI2C, uint8_t u8SlaveNo, uint16_t u16SlaveAddrMask);
void UI2C_EnableTimeout(UI2C_T *psUI2C, uint32_t u32TimeoutCnt);
void UI2C_DisableTimeout(UI2C_T *psUI2C);
void UI2C_EnableWakeup(UI2C_T *psUI2C, uint8_t u8WakeupMode);
void UI2C_DisableWakeup(UI2C_T *psUI2C);
uint8_t UI2C_WriteByte(UI2C_T *psUI2C, uint8_t u8SlaveAddr, const uint8_t u8Data);
uint32_t UI2C_WriteMultiBytes(UI2C_T *psUI2C, uint8_t u8SlaveAddr, const uint8_t *pu8Data, uint32_t u32WLen);
uint8_t UI2C_WriteByteOneReg(UI2C_T *psUI2C, uint8_t u8SlaveAddr, uint8_t u8DataAddr, const uint8_t u8Data);
uint32_t UI2C_WriteMultiBytesOneReg(UI2C_T *psUI2C, uint8_t u8SlaveAddr, uint8_t u8DataAddr, const uint8_t *pu8Data, uint32_t u32WLen);
uint8_t UI2C_WriteByteTwoRegs(UI2C_T *psUI2C, uint8_t u8SlaveAddr, uint16_t u16DataAddr, const uint8_t u8Data);
uint32_t UI2C_WriteMultiBytesTwoRegs(UI2C_T *psUI2C, uint8_t u8SlaveAddr, uint16_t u16DataAddr, const uint8_t *pu8Data, uint32_t u32WLen);
uint8_t UI2C_ReadByte(UI2C_T *psUI2C, uint8_t u8SlaveAddr);
uint32_t UI2C_ReadMultiBytes(UI2C_T *psUI2C, uint8_t u8SlaveAddr, uint8_t *pu8RData, uint32_t u32RLen);
uint8_t UI2C_ReadByteOneReg(UI2C_T *psUI2C, uint8_t u8SlaveAddr, uint8_t u8DataAddr);
uint32_t UI2C_ReadMultiBytesOneReg(UI2C_T *psUI2C, uint8_t u8SlaveAddr, uint8_t u8DataAddr, uint8_t *pu8RData, uint32_t u32RLen);
uint8_t UI2C_ReadByteTwoRegs(UI2C_T *psUI2C, uint8_t u8SlaveAddr, uint16_t u16DataAddr);
uint32_t UI2C_ReadMultiBytesTwoRegs(UI2C_T *psUI2C, uint8_t u8SlaveAddr, uint16_t u16DataAddr, uint8_t *pu8RData, uint32_t u32RLen);
# 593 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "../../../Library/StdDriver/inc\\usci_spi.h" 1
# 385 "../../../Library/StdDriver/inc\\usci_spi.h"
uint32_t USPI_Open(USPI_T *psUSPI, uint32_t u32MasterSlave, uint32_t u32SPIMode, uint32_t u32DataWidth, uint32_t u32BusClock);
void USPI_Close(USPI_T *psUSPI);
void USPI_ClearRxBuf(USPI_T *psUSPI);
void USPI_ClearTxBuf(USPI_T *psUSPI);
void USPI_DisableAutoSS(USPI_T *psUSPI);
void USPI_EnableAutoSS(USPI_T *psUSPI, uint32_t u32SSPinMask, uint32_t u32ActiveLevel);
uint32_t USPI_SetBusClock(USPI_T *psUSPI, uint32_t u32BusClock);
uint32_t USPI_GetBusClock(USPI_T *psUSPI);
void USPI_EnableInt(USPI_T *psUSPI, uint32_t u32Mask);
void USPI_DisableInt(USPI_T *psUSPI, uint32_t u32Mask);
uint32_t USPI_GetIntFlag(USPI_T *psUSPI, uint32_t u32Mask);
void USPI_ClearIntFlag(USPI_T *psUSPI, uint32_t u32Mask);
uint32_t USPI_GetStatus(USPI_T *psUSPI, uint32_t u32Mask);
void USPI_EnableWakeup(USPI_T *psUSPI);
void USPI_DisableWakeup(USPI_T *psUSPI);
# 594 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "../../../Library/StdDriver/inc\\usci_uart.h" 1
# 505 "../../../Library/StdDriver/inc\\usci_uart.h"
void UUART_ClearIntFlag(UUART_T *psUUART, uint32_t u32Mask);
uint32_t UUART_GetIntFlag(UUART_T *psUUART, uint32_t u32Mask);
void UUART_Close(UUART_T *psUUART);
void UUART_DisableInt(UUART_T *psUUART, uint32_t u32Mask);
void UUART_EnableInt(UUART_T *psUUART, uint32_t u32Mask);
uint32_t UUART_Open(UUART_T *psUUART, uint32_t u32Baudrate);
uint32_t UUART_Read(UUART_T *psUUART, uint8_t pu8RxBuf[], uint32_t u32ReadBytes);
uint32_t UUART_SetLine_Config(UUART_T *psUUART, uint32_t u32Baudrate, uint32_t u32DataWidth, uint32_t u32Parity, uint32_t u32StopBits);
uint32_t UUART_Write(UUART_T *psUUART, uint8_t pu8TxBuf[], uint32_t u32WriteBytes);
void UUART_EnableWakeup(UUART_T *psUUART, uint32_t u32WakeupMode);
void UUART_DisableWakeup(UUART_T *psUUART);
void UUART_EnableFlowCtrl(UUART_T *psUUART);
void UUART_DisableFlowCtrl(UUART_T *psUUART);
# 595 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "../../../Library/StdDriver/inc\\usbd.h" 1
# 29 "../../../Library/StdDriver/inc\\usbd.h"
typedef struct USBD_CMD_STRUCT
{
    uint8_t bmRequestType;
    uint8_t bRequest;
    uint16_t wValue;
    uint16_t wIndex;
    uint16_t wLength;

} S_USBD_CMD_T;

typedef union
{
    S_USBD_CMD_T setup;
    uint8_t au8setup[sizeof(S_USBD_CMD_T)];
} S_USBD_REQ_T;


typedef struct s_usbd_info
{
    uint8_t *gu8DevDesc;
    uint8_t *gu8ConfigDesc;
    uint8_t **gu8StringDesc;
    uint8_t **gu8HidReportDesc;
    uint8_t *gu8BosDesc;
    uint32_t *gu32HidReportSize;
    uint32_t *gu32ConfigHidDescIdx;
} S_USBD_INFO_T;

extern const S_USBD_INFO_T gsInfo;
# 553 "../../../Library/StdDriver/inc\\usbd.h"
static inline void USBD_MemCopy(uint8_t *dest, uint8_t *src, uint32_t size)
{
    while (size--) *dest++ = *src++;
}
# 568 "../../../Library/StdDriver/inc\\usbd.h"
static inline void USBD_SetStall(uint8_t epnum)
{
    uint32_t i;

    for (i = 0ul; i < 17ul; i++)
    {
        uint32_t u32CfgAddr;
        uint32_t u32Cfg;
        u32CfgAddr = (uint32_t)(i << 4) + (uint32_t)&((USBD_T *) ((((uint32_t)0x40000000UL) + 0x00040000UL) + 0x80000UL))->EP[0].CFG;
        u32Cfg = *((volatile uint32_t *)(u32CfgAddr));

        if ((u32Cfg & 0xful) == epnum)
        {
            u32CfgAddr = (uint32_t)(i << 4) + (uint32_t)&((USBD_T *) ((((uint32_t)0x40000000UL) + 0x00040000UL) + 0x80000UL))->EP[0].CFGP;
            u32Cfg = *((volatile uint32_t *)(u32CfgAddr));

            *((volatile uint32_t *)(u32CfgAddr)) = (u32Cfg | (0x1ul << (1)));
            break;
        }
    }
}
# 598 "../../../Library/StdDriver/inc\\usbd.h"
static inline void USBD_ClearStall(uint8_t epnum)
{
    uint32_t i;

    for (i = 0ul; i < 17ul; i++)
    {
        uint32_t u32CfgAddr;
        uint32_t u32Cfg;
        u32CfgAddr = (uint32_t)(i << 4) + (uint32_t)&((USBD_T *) ((((uint32_t)0x40000000UL) + 0x00040000UL) + 0x80000UL))->EP[0].CFG;
        u32Cfg = *((volatile uint32_t *)(u32CfgAddr));

        if ((u32Cfg & 0xful) == epnum)
        {
            u32CfgAddr = (uint32_t)(i << 4) + (uint32_t)&((USBD_T *) ((((uint32_t)0x40000000UL) + 0x00040000UL) + 0x80000UL))->EP[0].CFGP;
            u32Cfg = *((volatile uint32_t *)(u32CfgAddr));

            *((volatile uint32_t *)(u32CfgAddr)) = (u32Cfg & ~(0x1ul << (1)));
            break;
        }
    }
}
# 631 "../../../Library/StdDriver/inc\\usbd.h"
static inline uint32_t USBD_GetStall(uint8_t epnum)
{
    uint32_t u32CfgAddr;
    uint32_t u32Cfg;
    uint32_t i;

    for (i = 0ul; i < 17ul; i++)
    {
        u32CfgAddr = (uint32_t)(i << 4ul) + (uint32_t)&((USBD_T *) ((((uint32_t)0x40000000UL) + 0x00040000UL) + 0x80000UL))->EP[0].CFG;
        u32Cfg = *((volatile uint32_t *)(u32CfgAddr));

        if ((u32Cfg & 0xful) == epnum)
        {
            u32CfgAddr = (uint32_t)(i << 4ul) + (uint32_t)&((USBD_T *) ((((uint32_t)0x40000000UL) + 0x00040000UL) + 0x80000UL))->EP[0].CFGP;
            break;
        }
    }

    return ((*((volatile uint32_t *)(u32CfgAddr))) & (0x1ul << (1)));
}


extern volatile uint8_t g_USBD_u8RemoteWakeupEn;


typedef void (*VENDOR_REQ)(void);
typedef void (*CLASS_REQ)(void);
typedef void (*SET_INTERFACE_REQ)(uint32_t u32AltInterface);
typedef void (*SET_CONFIG_CB)(void);



void USBD_Open(const S_USBD_INFO_T *param, CLASS_REQ pfnClassReq, SET_INTERFACE_REQ pfnSetInterface);
void USBD_Start(void);
void USBD_GetSetupPacket(uint8_t *buf);
void USBD_ProcessSetupPacket(void);
void USBD_StandardRequest(void);
void USBD_PrepareCtrlIn(uint8_t pu8Buf[], uint32_t u32Size);
void USBD_CtrlIn(void);
void USBD_PrepareCtrlOut(uint8_t *pu8Buf, uint32_t u32Size);
void USBD_CtrlOut(void);
void USBD_SwReset(void);
void USBD_SetVendorRequest(VENDOR_REQ pfnVendorReq);
void USBD_SetConfigCallback(SET_CONFIG_CB pfnSetConfigCallback);
void USBD_LockEpStall(uint32_t u32EpBitmap);
# 596 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "../../../Library/StdDriver/inc\\wdt.h" 1
# 149 "../../../Library/StdDriver/inc\\wdt.h"
static inline void WDT_Close(void);
static inline void WDT_EnableInt(void);
static inline void WDT_DisableInt(void);
# 160 "../../../Library/StdDriver/inc\\wdt.h"
static inline void WDT_Close(void)
{
    ((WDT_T *) ((((uint32_t)0x40000000UL) + 0x00040000UL) + 0x00000UL))->CTL = 0UL;
    return;
}
# 173 "../../../Library/StdDriver/inc\\wdt.h"
static inline void WDT_EnableInt(void)
{
    ((WDT_T *) ((((uint32_t)0x40000000UL) + 0x00040000UL) + 0x00000UL))->CTL |= (0x1ul << (6));
    return;
}
# 186 "../../../Library/StdDriver/inc\\wdt.h"
static inline void WDT_DisableInt(void)
{

    ((WDT_T *) ((((uint32_t)0x40000000UL) + 0x00040000UL) + 0x00000UL))->CTL &= ~((0x1ul << (6)) | (0x1ul << (2)) | (0x1ul << (3)) | (0x1ul << (5)));
    return;
}

void WDT_Open(uint32_t u32TimeoutInterval, uint32_t u32ResetDelay, uint32_t u32EnableReset, uint32_t u32EnableWakeup);
# 597 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 1 "../../../Library/StdDriver/inc\\wwdt.h" 1
# 136 "../../../Library/StdDriver/inc\\wwdt.h"
void WWDT_Open(uint32_t u32PreScale, uint32_t u32CmpValue, uint32_t u32EnableInt);
# 598 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\M253.h" 2
# 14 "C:/Users/averyc/AppData/Local/Arm/Packs/Nuvoton/NuMicroM23_DFP/1.0.6/Device/M253/Include\\NuMicro.h" 2
# 12 "../../../Library/StdDriver/src/retarget.c" 2
# 61 "../../../Library/StdDriver/src/retarget.c"
FILE __stdout;
FILE __stdin;


    extern int32_t SH_DoCommand(int32_t n32In_R0, int32_t n32In_R1, int32_t *pn32Out_R0);




        __attribute__((weak))


    uint32_t ProcessHardFault(uint32_t lr, uint32_t msp, uint32_t psp);


int kbhit(void);
int IsDebugFifoEmpty(void);
void _ttywrch(int ch);
int fputc(int ch, FILE *stream);
# 89 "../../../Library/StdDriver/src/retarget.c"
    int fgetc(FILE *stream);
    int ferror(FILE *stream);


char GetChar(void);
void SendChar_ToUART(int ch);
void SendChar(int ch);
static volatile int32_t g_ICE_Connected = 1;
enum { r0, r1, r2, r3, r12, lr, pc, psr};







static void DumpStack(uint32_t stack[])
{
    (void)stack;
# 118 "../../../Library/StdDriver/src/retarget.c"
}
# 175 "../../../Library/StdDriver/src/retarget.c"
int32_t SH_Return(int32_t n32In_R0, int32_t n32In_R1, int32_t *pn32Out_R0);
int32_t SH_Return(int32_t n32In_R0, int32_t n32In_R1, int32_t *pn32Out_R0)
{
    (void)n32In_R0;
    (void)n32In_R1;
    (void)pn32Out_R0;
    return 0;
}
# 192 "../../../Library/StdDriver/src/retarget.c"
    __attribute__((weak))

uint32_t ProcessHardFault(uint32_t lr, uint32_t msp, uint32_t psp)
{
    uint32_t *sp;
    uint32_t inst;
# 210 "../../../Library/StdDriver/src/retarget.c"
        if (lr & 4UL)
        {
            sp = (uint32_t *)psp;
        }
        else
        {
            sp = (uint32_t *)msp;
        }
# 233 "../../../Library/StdDriver/src/retarget.c"
    inst = (*((vu16 *) (sp[6])));

    if (inst == 0xBEAB)
    {




        g_ICE_Connected = 0;
        sp[6] += 2;
        return lr;
    }

    printf("  HardFault!\n\n");
    DumpStack(sp);


    while (1) {};
}
# 262 "../../../Library/StdDriver/src/retarget.c"
void SendChar_ToUART(int ch)
{
    while (((UART_T *) ((((uint32_t)0x40000000UL) + 0x00040000UL) + 0x34000UL))->FIFOSTS & (0x1ul << (23))) {}

    if ((char)ch == '\n')
    {
        ((UART_T *) ((((uint32_t)0x40000000UL) + 0x00040000UL) + 0x34000UL))->DAT = '\r';

        while (((UART_T *) ((((uint32_t)0x40000000UL) + 0x00040000UL) + 0x34000UL))->FIFOSTS & (0x1ul << (23))) {}
    }

    ((UART_T *) ((((uint32_t)0x40000000UL) + 0x00040000UL) + 0x34000UL))->DAT = (uint32_t)ch;
}
# 353 "../../../Library/StdDriver/src/retarget.c"
__attribute__((weak)) void SendChar(int ch)
{
# 386 "../../../Library/StdDriver/src/retarget.c"
    SendChar_ToUART(ch);

}
# 399 "../../../Library/StdDriver/src/retarget.c"
char GetChar(void)
{
# 450 "../../../Library/StdDriver/src/retarget.c"
    while (1)
    {
        if ((((UART_T *) ((((uint32_t)0x40000000UL) + 0x00040000UL) + 0x34000UL))->FIFOSTS & (0x1ul << (14))) == 0U)
        {
            return ((char)((UART_T *) ((((uint32_t)0x40000000UL) + 0x00040000UL) + 0x34000UL))->DAT);
        }
    }


}
# 471 "../../../Library/StdDriver/src/retarget.c"
int kbhit(void)
{
    return !((((UART_T *) ((((uint32_t)0x40000000UL) + 0x00040000UL) + 0x34000UL))->FIFOSTS & (0x1ul << (14))) == 0U);
}
# 485 "../../../Library/StdDriver/src/retarget.c"
int IsDebugFifoEmpty(void)
{
    return ((((UART_T *) ((((uint32_t)0x40000000UL) + 0x00040000UL) + 0x34000UL))->FIFOSTS & (0x1ul << (28))) != 0U);
}
# 498 "../../../Library/StdDriver/src/retarget.c"
void _ttywrch(int ch)
{
    SendChar(ch);
    return;
}
# 554 "../../../Library/StdDriver/src/retarget.c"
int fputc(int ch, FILE *stream)
{
    (void)stream;
    SendChar(ch);
    return ch;
}
# 650 "../../../Library/StdDriver/src/retarget.c"
int fgetc(FILE *stream)
{
    (void)stream;
    return ((int)GetChar());
}
# 672 "../../../Library/StdDriver/src/retarget.c"
int ferror(FILE *stream)
{
    (void)stream;
    return (-1);
}
