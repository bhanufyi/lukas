use "collections"
use "math"
use "../worker"

actor SquareSumFinder
  let _env: Env
  let _chunk_size: USize

  new create(env: Env, n: USize, k: USize, chunk_size: USize = 512) =>
    _env = env
    if chunk_size > 0 then
      _chunk_size = chunk_size
    else
      _chunk_size = n.u64().f64().sqrt().ceil().usize()
    end

    let num_workers = ((n - 1) / _chunk_size) + 1
    for i in Range(0, num_workers) do
      let start = (i * _chunk_size) + 1
      let finish = if ((i + 1) * _chunk_size) > n then n else (i + 1) * _chunk_size end
      let offset = i * _chunk_size
      let worker = SquareSumWorker(_env, k, offset)
      worker.calculate(start, finish)
    end