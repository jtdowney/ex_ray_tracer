defmodule RayTracer.MixProject do
  use Mix.Project

  def project do
    [
      app: :ray_tracer,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      compilers: [:rustler] ++ Mix.compilers(),
      rustler_crates: rustler_crates(),
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
      {:credo, "~> 1.4.0", only: :dev},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, "~> 0.22.1", only: :dev, runtime: false},
      {:memoize, "~> 1.3.0"},
      {:rustler, "~> 0.22.0-rc.0"},
      {:stream_data, "~> 0.5.0", only: [:dev, :test]}
    ]
  end

  defp rustler_crates do
    [
      ray_tracer: [
        mode: rustc_mode(Mix.env())
      ]
    ]
  end

  defp rustc_mode(:prod), do: :release
  defp rustc_mode(_), do: :debug
end
