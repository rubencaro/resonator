defmodule Resonator.Mixfile do
  use Mix.Project

  def project do
    [app: :resonator,
     version: "0.1.0",
     elixir: ">= 1.3.2",
     package: package,
     deps: deps,
     description: "External API's change resonator" ]
  end

  def application do
    [ applications: [] ]
  end

  defp package do
    [maintainers: ["Rubén Caro"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/rubencaro/resonator"}]
  end

  defp deps, do: []
end
