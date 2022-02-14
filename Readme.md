# Python Style (but Unidirectional) Generators for Julia

```log
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.7.2 (2022-02-06)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia> using PyStyleButUnidirGenerators

julia> @generator function g(n::Int)
         m = n * 3
         @yield m
         m += 7
         @yield m
         m -= 9
         @yield m
       end
g (generic function with 1 method)

julia> for i in g(5)
         println(i)
       end
15
22
13

julia> collect(g(5))
3-element Vector{Int64}:
 15
 22
 13

julia>
```

## Communicate Back from Iterater to Iteratee?

The `yield xxx` expression in Python can have things from outside back into the generator function, but Julia's `Iteration` interface seems doesn't facilate communication in this direction. Or else?
