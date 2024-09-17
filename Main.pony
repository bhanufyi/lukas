use "./finder"

actor Main
  new create(env: Env) =>
    try
      let n = env.args(1)?.usize()?
      let k = env.args(2)?.usize()?

      // Check if a chunk_size argument was provided, if not, default to 512
      let chunk_size: USize = 
        if env.args.size() > 3 then
          env.args(3)?.usize()?
        else
          512
        end

      // Call SquareSumFinder with the determined chunk size
      SquareSumFinder(env, n + k, k, chunk_size)
    else
      env.out.print("Please provide valid numbers N, K, and optional chunk size as arguments.")
    end
