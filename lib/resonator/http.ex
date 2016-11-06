require Logger, as: L
alias Keyword, as: K

defmodule Resonator.Http do
  @moduledoc """
  """

  @type response :: {:ok, integer(), binary(), integer()} | {:error, any()}

  def get(url, opts \\ []), do: request(:get, url, "", opts)

  def post(url, body, opts \\ []), do: request(:post, url, body, opts)

  @spec request(atom(), binary(), binary(), keyword()) :: response
  def request(method, url, body, opts) do
    opts = [timeout: 10_000,
            recv_timeout: 10_000,
            retries: 3,
            httpoison: []] |> K.merge(opts)
    K.put opts, :httpoison, K.merge([follow_redirects: true,
                                     max_redirect: 5,
                                     timeout: 8_000,
                                     recv_timeout: 5_000], opts[:httpoison])
    heads = [{"Content-type", "application/json"}, {"Accept", "application/json"}]

    # Time difference.
    ts_ini = System.system_time(:milliseconds)
    ret = do_request(method, url, body, heads, opts)
    ts_end = System.system_time(:milliseconds)
    millis = ts_end - ts_ini

    case ret do
      {:ok, status, body} ->
        L.info("Resonator.Http.get|#{status}|#{ts_end - ts_ini} milliseconds|#{url}")
        {:ok, status, body, millis}
      {:error, reason} ->
        L.error("Resonator.Http.get|error|#{inspect reason}|#{millis} milliseconds|#{url}")
        {:error, reason}
    end
  end

  defp do_request(method, url, body, heads, opts) do
    res = HTTPoison.request(method, url, body, heads, opts[:httpoison])

    case res do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, 200, body}
      {:ok, %HTTPoison.Response{status_code: status_code}} -> {:error, status_code}
      {:error, %HTTPoison.Error{reason: reason}} ->
        r = opts[:retries]
        if r > 0 do
          :timer.sleep(r * 1000)
          do_request(method, url, body, heads, K.put(opts, :retries, r - 1))
        else
          {:error, reason}
        end
    end
  end
end
