defmodule RayTracer.MixProject do
  use Mix.Project

  def project do
    [
      app: :ray_tracer,
      version: "0.1.0",
      elixir: "~> 1.10",
      env: [epsilon: 0.00001],
      start_permanent: Mix.env() == :prod,
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
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, "~> 0.22.1", only: :dev, runtime: false},
      {:stream_data, "~> 0.5.0", only: [:dev, :test]}
    ]
  end
end
