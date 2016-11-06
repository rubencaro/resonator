defmodule Resonator.Helpers do

  @moduledoc """
    require Resonator.Helpers, as: H  # the cool way
  """
  @doc """
    Convenience to get environment bits. Avoid all that repetitive
    `Application.get_env( :myapp, :blah, :blah)` noise.

    Use it as `H.env(:anyapp, :key, default)`

    You can add the default app to your config file:

    ```
      config :resonator, app: :myapp
    ```

    Then you can use it as `H.env(:key)` instead of `H.env(:myapp, :key)`
  """
  def env(key, default \\ nil), do: env(Application.get_env(:resonator, :app, :resonator), key, default)
  def env(app, key, default), do: Application.get_env(app, key, default)

  @doc """
    Opposite of Resonator.Helpers.env.
  """
  def put_env(key, default \\ nil), do: put_env(Application.get_env(:resonator, :app, :resonator), key, default)
  def put_env(app, key, default), do: Application.put_env(app, key, default)

  @doc """
  Spit to output any passed variable, with location information.

  If `sample` option is given, it should be a float between 0.0 and 1.0.
  Output will be produced randomly with that probability.

  Given `opts` will be fed straight into `inspect`. Any option accepted by it should work.
  """
  defmacro spit(obj \\ "", opts \\ []) do
    quote do
      opts = unquote(opts)
      obj = unquote(obj)
      opts = Keyword.put(opts, :env, __ENV__)

      Resonator.Helpers.maybe_spit(obj, opts, opts[:sample])
      obj  # chainable
    end
  end

  @doc false
  def maybe_spit(obj, opts, nil), do: do_spit(obj, opts)
  def maybe_spit(obj, opts, prob) when is_float(prob) do
    if :rand.uniform <= prob, do: do_spit(obj, opts)
  end

  defp do_spit(obj, opts) do
    %{file: file, line: line} = opts[:env]
    name = Process.info(self)[:registered_name]
    chain = [:bright, :red, "\n\n#{file}:#{line}", :normal, "\n     #{inspect self}", :green," #{name}"]

    msg = inspect(obj, opts)
    chain = chain ++ [:red, "\n\n#{msg}"]

    chain |> Kernel.++(["\n\n", :reset]) |> IO.ANSI.format(true) |> IO.puts
  end

  @doc """
    Print to stdout a _TODO_ message, with location information.
  """
  defmacro todo(msg \\ "") do
    quote do
      %{file: file, line: line} = __ENV__
      [:yellow, "\nTODO: #{file}:#{line} #{unquote(msg)}\n", :reset]
      |> IO.ANSI.format(true)
      |> IO.puts
      :todo
    end
  end

  @doc """
    Apply given defaults to given Keyword. Returns merged Keyword.

    The inverse of `Keyword.merge`, best suited to apply some defaults in a
    chainable way.

    Ex:
      kw = gather_data
        |> transform_data
        |> H.defaults(k1: 1234, k2: 5768)
        |> here_i_need_defaults

    Instead of:
      kw1 = gather_data
        |> transform_data
      kw = [k1: 1234, k2: 5768]
        |> Keyword.merge(kw1)
        |> here_i_need_defaults

      iex> [a: 3] |> Resonator.Helpers.defaults(a: 4, b: 5)
      [b: 5, a: 3]
      iex> %{a: 3} |> Resonator.Helpers.defaults(%{a: 4, b: 5})
      %{a: 3, b: 5}

  """
  def defaults(args, defs) when is_map(args) and is_map(defs) do
    defs |> Map.merge(args)
  end
  def defaults(args, defs) when is_list(args) and is_list(defs) do
    defs |> Keyword.merge(args)
  end
  def defaults(args, defs, labelled: true), do: {:ok, defaults(args, defs)}


  @doc """
    Returns `{:error, reason}` if any given key is not in the given Keyword.
    Else returns given Keyword, so it can be chained using pipes.
    If `labelled: true` is given, then response is `{:ok, args}`.
  """
  def requires(args, required) when is_map(args) do
    keys = args |> Map.keys
    case requires(keys, required) do
      ^keys -> args # chainable
      x -> x
    end
  end
  def requires(args, required) when is_list(args) do
    keys = case Keyword.keyword?(args) do
        true -> args |> Keyword.keys
        false -> args
      end

    case do_requires(keys, required) do
      :ok -> args # chainable
      x -> x
    end
  end
  def requires(args, required, labelled: true) do
    case requires(args, required) do
      {:error, _} = e -> e
      x -> {:ok, x}
    end
  end

  defp do_requires(keys, [required|rest]) do
    case required in keys do
      true -> do_requires(keys, rest)
      false -> {:error, "Required argument '#{required}' was not present in #{inspect(keys)}"}
    end
  end
  defp do_requires(_, []), do: :ok

  @doc """
  Exploding version of `requires/2`
  """
  def requires!(args, required) do
    case requires(args, required) do
      {:error, reason} -> raise(ArgumentError, reason)
      x -> x
    end
  end

  @doc """
  Pipeable version of `Kernel.struct/2`
  """
  def to_struct(data, struct), do: struct(struct, data)
end
