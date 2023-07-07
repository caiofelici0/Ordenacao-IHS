#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

void swap(int32_t *x, int32_t *y)
{
  int32_t k = *x;
  *x = *y;
  *y = k;
}

void ordenar(int32_t *V, uint32_t n)
{
  for (uint32_t i = 0; i < n - 1; i++)
  {
    uint32_t min = i;
    for (uint32_t j = i + 1; j < n; j++)
      if (V[j] < V[min])
        min = j;
    if (i != min)
      swap(&V[i], &V[min]);
  }
}

int main()
{
  const uint32_t n = 5;
  int32_t V[5] = {5, 4, 2, 1, 3};

  ordenar(V, n);

  for (uint32_t i = 0; i < n - 1; i++)
    printf("%u ", V[i]);
  printf("%u \n", V[n - 1]);

  return 0;
}

// gcc -Wall -g -pg teste.c -o teste.bin
// gcc -Wall -g teste.c -o teste.bin

// objdump -D -z -M intel teste.bin

// otimizacao de tempo -On:
// gcc -Wall -O0 teste.c -o teste.bin
// gcc -Wall -O1 teste.c -o teste.bin
// gcc -Wall -O2 teste.c -o teste.bin
// gcc -Wall -O3 teste.c -o teste.bin
// gcc -Wall -Ofast teste.c -o teste.bin

// otimizacao de espaco -Os:
// gcc -Wall -Os teste.c -o teste.bin

// otimizacao de depuracao -Og:
// gcc -Wall -Og teste.c -o teste.bin

// teste de tempo:
// hyperfine --warmup 3 './teste.bin'
