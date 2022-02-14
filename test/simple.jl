
using PyStyleButUnidirGenerators

##.
@generator function g(n::Int)
  m = n * 3
  @yield m
  m += 7
  @yield m
  m -= 9
  @yield m
end

##.
for i in g(5)
  println(i)
end

##.
collect(g(5))
