#include <stdio.h>

int main() {
  int x = getchar();
  int y = 0;
  if (x > 10) {
    y = 1;
  } else {
    y = 2;
  }
  int z = x / y;
  return 0;
}
