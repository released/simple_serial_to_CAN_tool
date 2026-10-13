# 1 "../misc_config.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 391 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "../misc_config.c" 2

# 1 "..\\misc_config.h" 1




# 1 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 1 3
# 51 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
    typedef unsigned int size_t;






extern __attribute__((__nothrow__)) void *memcpy(void * __restrict ,
                    const void * __restrict , size_t ) __attribute__((__nonnull__(1,2)));






extern __attribute__((__nothrow__)) void *memmove(void * ,
                    const void * , size_t ) __attribute__((__nonnull__(1,2)));
# 77 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) char *strcpy(char * __restrict , const char * __restrict ) __attribute__((__nonnull__(1,2)));






extern __attribute__((__nothrow__)) char *strncpy(char * __restrict , const char * __restrict , size_t ) __attribute__((__nonnull__(1,2)));
# 93 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) char *strcat(char * __restrict , const char * __restrict ) __attribute__((__nonnull__(1,2)));






extern __attribute__((__nothrow__)) char *strncat(char * __restrict , const char * __restrict , size_t ) __attribute__((__nonnull__(1,2)));
# 117 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) int memcmp(const void * , const void * , size_t ) __attribute__((__nonnull__(1,2)));







extern __attribute__((__nothrow__)) int strcmp(const char * , const char * ) __attribute__((__nonnull__(1,2)));






extern __attribute__((__nothrow__)) int strncmp(const char * , const char * , size_t ) __attribute__((__nonnull__(1,2)));
# 141 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) int strcasecmp(const char * , const char * ) __attribute__((__nonnull__(1,2)));







extern __attribute__((__nothrow__)) int strncasecmp(const char * , const char * , size_t ) __attribute__((__nonnull__(1,2)));
# 158 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) int strcoll(const char * , const char * ) __attribute__((__nonnull__(1,2)));
# 169 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) size_t strxfrm(char * __restrict , const char * __restrict , size_t ) __attribute__((__nonnull__(2)));
# 193 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) void *memchr(const void * , int , size_t ) __attribute__((__nonnull__(1)));
# 209 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) char *strchr(const char * , int ) __attribute__((__nonnull__(1)));
# 218 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) size_t strcspn(const char * , const char * ) __attribute__((__nonnull__(1,2)));
# 232 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) char *strpbrk(const char * , const char * ) __attribute__((__nonnull__(1,2)));
# 247 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) char *strrchr(const char * , int ) __attribute__((__nonnull__(1)));
# 257 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) size_t strspn(const char * , const char * ) __attribute__((__nonnull__(1,2)));
# 270 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) char *strstr(const char * , const char * ) __attribute__((__nonnull__(1,2)));
# 280 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) char *strtok(char * __restrict , const char * __restrict ) __attribute__((__nonnull__(2)));
extern __attribute__((__nothrow__)) char *_strtok_r(char * , const char * , char ** ) __attribute__((__nonnull__(2,3)));
# 321 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) void *memset(void * , int , size_t ) __attribute__((__nonnull__(1)));





extern __attribute__((__nothrow__)) char *strerror(int );







extern __attribute__((__nothrow__)) size_t strlen(const char * ) __attribute__((__nonnull__(1)));





extern __attribute__((__nothrow__)) size_t strnlen(const char * , size_t ) __attribute__((__nonnull__(1)));







extern __attribute__((__nothrow__)) size_t strlcpy(char * , const char * , size_t ) __attribute__((__nonnull__(1,2)));
# 369 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) size_t strlcat(char * , const char * , size_t ) __attribute__((__nonnull__(1,2)));
# 395 "C:\\Keil_v5\\ARM\\ARMCLANG\\bin\\..\\include\\string.h" 3
extern __attribute__((__nothrow__)) void _membitcpybl(void * , const void * , int , int , size_t ) __attribute__((__nonnull__(1,2)));
extern __attribute__((__nothrow__)) void _membitcpybb(void * , const void * , int , int , size_t ) __attribute__((__nonnull__(1,2)));
extern __attribute__((__nothrow__)) void _membitcpyhl(void * , const void * , int , int , size_t ) __attribute__((__nonnull__(1,2)));
extern __attribute__((__nothrow__)) void _membitcpyhb(void * , const void * , int , int , size_t ) __attribute__((__nonnull__(1,2)));
extern __attribute__((__nothrow__)) void _membitcpywl(void * , const void * , int , int , size_t ) __attribute__((__nonnull__(1,2)));
extern __attribute__((__nothrow__)) void _membitcpywb(void * , const void * , int , int , size_t ) __attribute__((__nonnull__(1,2)));
extern __attribute__((__nothrow__)) void _membitmovebl(void * , const void * , int , int , size_t ) __attribute__((__nonnull__(1,2)));
extern __attribute__((__nothrow__)) void _membitmovebb(void * , const void * , int , int , size_t ) __attribute__((__nonnull__(1,2)));
extern __attribute__((__nothrow__)) void _membitmovehl(void * , const void * , int , int , size_t ) __attribute__((__nonnull__(1,2)));
extern __attribute__((__nothrow__)) void _membitmovehb(void * , const void * , int , int , size_t ) __attribute__((__nonnull__(1,2)));
extern __attribute__((__nothrow__)) void _membitmovewl(void * , const void * , int , int , size_t ) __attribute__((__nonnull__(1,2)));
extern __attribute__((__nothrow__)) void _membitmovewb(void * , const void * , int , int , size_t ) __attribute__((__nonnull__(1,2)));
# 6 "..\\misc_config.h" 2



struct flag_8bit
{
 unsigned char bit0:1 ;
 unsigned char bit1:1 ;
 unsigned char bit2:1 ;
 unsigned char bit3:1 ;
 unsigned char bit4:1 ;
 unsigned char bit5:1 ;
 unsigned char bit6:1 ;
 unsigned char bit7:1 ;
};

struct flag_16bit
{
 unsigned char bit0:1 ;
 unsigned char bit1:1 ;
 unsigned char bit2:1 ;
 unsigned char bit3:1 ;
 unsigned char bit4:1 ;
 unsigned char bit5:1 ;
 unsigned char bit6:1 ;
 unsigned char bit7:1 ;

 unsigned char bit8:1 ;
 unsigned char bit9:1 ;
 unsigned char bit10:1 ;
 unsigned char bit11:1 ;
 unsigned char bit12:1 ;
 unsigned char bit13:1 ;
 unsigned char bit14:1 ;
 unsigned char bit15:1 ;
};

struct flag_32bit
{
 unsigned char bit0:1 ;
 unsigned char bit1:1 ;
 unsigned char bit2:1 ;
 unsigned char bit3:1 ;
 unsigned char bit4:1 ;
 unsigned char bit5:1 ;
 unsigned char bit6:1 ;
 unsigned char bit7:1 ;

 unsigned char bit8:1 ;
 unsigned char bit9:1 ;
 unsigned char bit10:1 ;
 unsigned char bit11:1 ;
 unsigned char bit12:1 ;
 unsigned char bit13:1 ;
 unsigned char bit14:1 ;
 unsigned char bit15:1 ;

 unsigned char bit16:1 ;
 unsigned char bit17:1 ;
 unsigned char bit18:1 ;
 unsigned char bit19:1 ;
 unsigned char bit20:1 ;
 unsigned char bit21:1 ;
 unsigned char bit22:1 ;
 unsigned char bit23:1 ;

 unsigned char bit24:1 ;
 unsigned char bit25:1 ;
 unsigned char bit26:1 ;
 unsigned char bit27:1 ;
 unsigned char bit28:1 ;
 unsigned char bit29:1 ;
 unsigned char bit30:1 ;
 unsigned char bit31:1 ;
};
# 173 "..\\misc_config.h"
void read_64_words(unsigned long start_addr , unsigned long* buffer);
unsigned long _read_memory_u32 (const unsigned long addr_u32);
unsigned short _read_memory_u16 (const unsigned long addr_u32);
unsigned char _read_memory_u08 (const unsigned long addr_u32);
int compare_buffer(const void *src, const void *dest, size_t nBytes);
void reset_buffer(void *dest, unsigned long val, unsigned long size);
void copy_buffer(void *dest, void *src, unsigned long size);
void dump_buffer32(unsigned long *pucBuff, int nBytes);
void dump_buffer32_hex(unsigned long *pucBuff, int nBytes);
void dump_buffer16(unsigned short *pucBuff, int nBytes);
void dump_buffer16_hex(unsigned short *pucBuff, int nBytes);
void dump_buffer8(unsigned char *pucBuff, int nBytes);
void dump_buffer8_hex(unsigned char *pucBuff, int nBytes);
# 3 "../misc_config.c" 2



struct flag_8bit flag_MISC_CTL;
# 37 "../misc_config.c"
void read_64_words(unsigned long start_addr , unsigned long* buffer)
{
    unsigned long i = 0;
    for (i = 0; i < 64; i++)
    {
        buffer[i] = (*((volatile unsigned long *)(start_addr + i * 4U)));
    }
}

unsigned long _read_memory_u32 (const unsigned long addr_u32)
{
    return ( *( (volatile unsigned long *)(addr_u32) ) );
}
unsigned short _read_memory_u16 (const unsigned long addr_u32)
{
    return ( *( (volatile unsigned short *)(addr_u32) ) );
}
unsigned char _read_memory_u08 (const unsigned long addr_u32)
{
    return ( *( (volatile unsigned char *)(addr_u32) ) );
}

int compare_buffer(const void *src, const void *dest, size_t nBytes)
{
    if (memcmp(src, dest, nBytes) == 0) {
                                                 ;
        return 0;
    }

                                                    ;
    return 1;
}

void reset_buffer(void *dest, unsigned long val, unsigned long size)
{
    unsigned char *pu8Dest;


    pu8Dest = (unsigned char *)dest;


 while (size-- > 0)
  *pu8Dest++ = val;




}

void copy_buffer(void *dest, void *src, unsigned long size)
{
    unsigned char *pu8Src, *pu8Dest;
    unsigned long i;

    pu8Dest = (unsigned char *)dest;
    pu8Src = (unsigned char *)src;






    for (i = 0; i < size; i++)
        pu8Dest[i] = pu8Src[i];

}


void dump_buffer32(unsigned long *pucBuff, int nBytes)
{
    unsigned short i = 0;

                                                ;
    for (i = 0 ; i < nBytes ; i++)
    {
                                           ;
        if ((i+1)%4 ==0)
        {
                              ;
        }
    }
                      ;
}

void dump_buffer32_hex(unsigned long *p, int nWords)
{
 unsigned char ch = 0;
 int b = 0;
 unsigned long w = 0;
 int i=0;
    int idx = 0;
    while (nWords > 0) {
                                     ;
        for (i=0;i<4;i++) ;
                        ;
        for (i=0;i<4;i++) {
            w = p[idx+i];
            for (b=0;b<4;b++) {
                ch = (w >> (8*(3-b))) & 0xFF;
                                                                  ;
            }
        }
                        ;
        idx += 4; nWords -= 4;
    }
}

void dump_buffer16(unsigned short *pucBuff, int nBytes)
{
    unsigned short i = 0;

                                                ;
    for (i = 0 ; i < nBytes ; i++)
    {
                                          ;
        if ((i+1)%8 ==0)
        {
                              ;
        }
    }
                          ;
}

void dump_buffer16_hex(unsigned short *pucBuff, int nBytes)
{
    int nIdx, i;

    nIdx = 0;
    while (nBytes > 0)
    {
                                    ;
        for (i = 0; i < 16; i++)
                                                  ;
                        ;
        for (i = 0; i < 16; i++)
        {
            if ((pucBuff[nIdx + i] >= 0x20) && (pucBuff[nIdx + i] < 127))
                                                   ;
            else
                               ;
            nBytes--;
        }
        nIdx += 16;
                        ;
    }
                    ;
}

void dump_buffer8(unsigned char *pucBuff, int nBytes)
{
    unsigned short i = 0;

                                                ;
    for (i = 0 ; i < nBytes ; i++)
    {
                                          ;
        if ((i+1)%8 ==0)
        {
                              ;
        }
    }
                          ;
}

void dump_buffer8_hex(unsigned char *pucBuff, int nBytes)
{
    int nIdx, i;

    nIdx = 0;
    while (nBytes > 0)
    {
                                    ;
        for (i = 0; i < 16; i++)
                                                  ;
                        ;
        for (i = 0; i < 16; i++)
        {
            if ((pucBuff[nIdx + i] >= 0x20) && (pucBuff[nIdx + i] < 127))
                                                   ;
            else
                               ;
            nBytes--;
        }
        nIdx += 16;
                        ;
    }
                    ;
}
