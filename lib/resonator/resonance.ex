alias Resonator, as: R
require R.Helpers, as: H

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
  @type endpoint_definition :: keyword()

  @callback change(R.Http.response) :: :ok | {:changed, R.Http.response}
  @callback fire(R.Http.response) :: :ok
  @callback endpoint() :: endpoint_definition
  @callback error(R.Http.response) :: :ok
  @callback options() :: R.Resonance.Options.t
end
