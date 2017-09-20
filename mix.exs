defmodule Issues.Mixfile do
  use Mix.Project

  def project do
    [
      app: :issues,
      escript: escript_config(),
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      name: "Issues",
      source_url: "https://github.com/kradydal/elixir_github_issues",
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      { :httpoison, "~> 0.13.0" },
      { :poison, "~> 3.1" },
      { :ex_doc, "~> 0.16.4" },
      { :earmark, "~> 1.2" }
    ]
  end

  def escript_config do
    [ main_module: Issues.CLI ]
  end
end
