defmodule RayTracer do
  @spec epsilon() :: float
  def epsilon() do
    Application.get_env(:ray_tracer, :epsilon)
  end
end
