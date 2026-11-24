// Feature: range-based for over arrays (by value, by reference, auto, class
// pointers), enum class with scoped enumerators (also as case labels).
#include <cstdio>
enum class Dir { North, East = 5, South, };
struct P { int x; double w; };
class Shape { public: virtual double area() { return 0; } };
class Sq : public Shape { double s; public: Sq(double v) : s(v) {} double area() { return s * s; } };
int main() {
  int a[5] = {3, 1, 4, 1, 5}; int sum = 0;
  for (int v : a) sum += v;
  for (int &v : a) v *= 2;
  for (auto v : a) { if (v == 2) continue; if (v > 9) break; printf("%d ", v); }
  printf("sum=%d\n", sum);
  P ps[2] = {{1, 0.5}, {2, 1.5}}; double tw = 0;
  for (const auto &p : ps) tw += p.w * p.x;
  Sq s1(2), s2(3); Shape *shapes[2] = {&s1, &s2};
  for (Shape *sh : shapes) printf("%.1f ", sh->area());
  Dir d = Dir::South;
  printf("%.2f %d %d\n", tw, (int)d, d == Dir::South);
  switch (d) { case Dir::North: printf("N\n"); break; case Dir::South: printf("S\n"); break; default: break; }
  return 0; }
