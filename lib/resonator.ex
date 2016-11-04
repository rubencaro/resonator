defmodule Resonator do
  use Application

  @doc """
    Start and supervise a single lonely worker
  """
  def start(_,_) do
    import Supervisor.Spec

    opts = [strategy: :one_for_one, name: Resonator.Supervisor]
    children = []
    Supervisor.start_link(children, opts)
  end

end
