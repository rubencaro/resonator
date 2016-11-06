require Resonator.Helpers, as: H

defmodule Resonator.Resonance do
  @moduledoc """
  Behaviour to define what given resonances should look like.

  Example:

  ```elixir
  defmodule MyResonance do
    @behaviour Resonator.Resonance

    def change(_response) do
      # ... change detection logic
    end

    def fire(_response) do
      # ... response to change
    end

    def endpoint do
      # ... endpoint access logic
    end

    def error(_response) do
      # ... error handling logic
    end

    def options do
      # ... options definition
    end
  end

  Resonator.add(MyResonance)
  ```
  """
  alias Resonator.Http

  @callback change(Http.response) :: :ok | {:changed, Http.response}
  @callback fire(Http.response) :: :ok
  H.todo "Define return type"
  @callback endpoint() :: keyword()
  @callback error(Http.response) :: :ok
  H.todo "Define return type"
  @callback options() :: keyword()
end
