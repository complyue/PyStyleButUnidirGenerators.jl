
using PyStyleButUnidirGenerators

##.
@generator function organpipe(n::Integer)
  i = 0
  while i != n
    i += 1
    @yield i
  end
  while true
    i -= 1
    i == 0 && return
    @yield i
  end
end

##.
collect(organpipe(2))
