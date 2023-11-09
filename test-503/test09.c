#include <stdio.h>

int main() {
  int in = getchar();
  unsigned int a = 10;
  unsigned int b = 2;

  if (in > 0) {
    b = in + b;
  } else if (in == 0) {
    b = 0;
  } else {
    b = in - b;
  }

  int out = a / b;
  return 0;
}
