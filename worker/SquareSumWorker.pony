use "collections"
use "math"

actor SquareSumWorker
  let _env: Env
  let _k: USize
  let _offset: USize
  let _buffer: Array[U64]
  var _aggregate: U64
  var _index: USize

  new create(env: Env, k: USize, offset: USize) =>
    _env = env
    _k = k
    _offset = offset
    _buffer = Array[U64](_k)
    _aggregate = 0
    _index = 0

  be calculate(start: USize, finish: USize) =>
    var i: USize = start
    while i <= finish do
      let square = i.u64() * i.u64()
      add_square(square)
      i = i + 1
    end

  fun ref add_square(square: U64) =>
    if _buffer.size() == _k then
      try
        _aggregate = _aggregate - _buffer.shift()?
      end
    end

    _buffer.push(square)
    _aggregate = _aggregate + square

    if _buffer.size() == _k then
      if is_perfect_square(_aggregate) then
        _env.out.print((_offset + _index + 1).string())
      end
      _index = _index + 1
    end

  fun is_perfect_square(n: U64): Bool =>
    if (n == 0) or (n == 1) then
      true
    else
      let sqrt_n = n.u64().f64().sqrt()
      sqrt_n == sqrt_n.trunc()
    end
