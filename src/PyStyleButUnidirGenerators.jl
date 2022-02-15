module PyStyleButUnidirGenerators

export @generator, @yield


##.
struct GenTask
  iterater::Task
  iteratee::Task
end

struct StopIteration end

##.
Base.IteratorSize(::Type{GenTask}) = Base.SizeUnknown()
Base.IteratorEltype(::Type{GenTask}) = Base.EltypeUnknown()
##.
Base.iterate(
  gt::GenTask, ::Nothing = nothing
)::Union{Nothing,Tuple{Any,Nothing}} = begin
  @assert current_task() === gt.iterater
  if istaskdone(gt.iteratee)
    return nothing
  end
  try
    item = yieldto(gt.iteratee, nothing)
    if item === StopIteration || item isa StopIteration
      return nothing
    end
    return item, nothing
  catch e
    if e === StopIteration || !isa(e, StopIteration)
      rethrow()
    end
  end
  return nothing
end


##.
const gt!var = Symbol("#!generator'task")

##.
macro generator(fd)
  @assert fd.head === :function
  sig, body = fd.args
  @assert sig.head === :call # todo: support return type anno?
  # probably no, its return value has no way to be used as AFAIK
  fn, args... = sig.args

  return esc(quote
    function $fn($(args...))
      $gt!var = $GenTask(current_task(), Task(() -> begin
        try
          @assert current_task() === $gt!var.iteratee
          try
            $body
          finally
            yieldto($gt!var.iterater, $StopIteration())
          end
        catch e
          if !istaskdone($gt!var.iterater)
            Base.throwto($gt!var.iterater, e)
          end
        end
      end))
      return $gt!var
    end
  end)
end

##.
macro yield(v)
  return esc(quote
    yieldto($gt!var.iterater, $v)
  end)
end


end # module
