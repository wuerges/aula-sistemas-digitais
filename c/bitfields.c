#include <stdio.h>

typedef struct Ct {
  unsigned char hb1 : 4;
  unsigned char hb2 : 4;
} C;


typedef union Ut {
  C hb;
  unsigned char c;
} U;


int main() {

  U c1;

  c1.c = 0xab;

  printf("%x\n", c1.hb.hb1);
  printf("%x\n", c1.hb.hb2);

}
