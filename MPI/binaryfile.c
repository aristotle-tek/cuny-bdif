#include <stdio.h>

#define  FILE1   "binaryfile"
#define  SIZE1   800

// generate binary file with list of descending integers for sample data.

void main(int argc, char *argv[]) {
   FILE *fp;
   int  a[SIZE1];
   int  i, j;

   for (i=0;i<SIZE1;i++) {
      a[i] = SIZE1 - i;
   }

   fp = fopen(FILE1, "wb");
   fwrite(a, sizeof(int), SIZE1, fp); 
   fclose(fp);
}