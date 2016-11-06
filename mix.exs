defmodule Resonator.Mixfile do
  use Mix.Project

  def project do
    [app: :resonator,
     version: "0.1.0",
     elixir: ">= 1.3.2",
     package: package,
     deps: deps,
     description: "External API's change resonator",
     test_coverage: [tool: Resonator.Cover],
     aliases: aliases ]
  end

  def application do
    [ applications: [] ]
  end

  defp package do
    [maintainers: ["Rubén Caro"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/rubencaro/resonator"}]
  end

  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev},
     {:httpoison, "~> 0.9"},
     {:credo, "~> 0.4", only: [:dev, :test]}]
  end

  defp aliases do
    [test: ["test --cover", "credo"]]
  end
end
