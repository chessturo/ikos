int main() {
  int x = 0;
  int y = 1;
  if (x != 0) {
    int z = y / x; // unreachable
  }
  return 0;
}
