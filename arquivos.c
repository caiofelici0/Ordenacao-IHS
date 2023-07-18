#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
  uint32_t n, m;
  int32_t *v;

  FILE *input;
  FILE *output;

  input = fopen(argv[1], "r");
  output = fopen(argv[2], "w");

  fscanf(input, "%u", &n);

  for (uint32_t i = 0; i < n; i++)
  {
    fscanf(input, "%u", &m);

    v = malloc(sizeof(int32_t) * m);
    for (int i = 0; i < m; i++)
    {
      fscanf(input, "%d", &v[i]);
    }

    for (uint32_t i = 0; i < m - 1; i++)
    {
      fprintf(output, "%d ", v[i]);
    }
    fprintf(output, "%d\n", v[m - 1]);

    free(v);
  }

  fclose(input);
  fclose(output);

  return 0;
}

// gcc -Wall arquivos.c -o arquivos.bin