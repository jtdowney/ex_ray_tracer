defmodule RayTracer.Vector do
  import RayTracer.Tuple

  @spec magnitude(RayTracer.Tuple.t()) :: float
  def magnitude(%{x: x, y: y, z: z}) do
    (:math.pow(x, 2) + :math.pow(y, 2) + :math.pow(z, 2))
    |> :math.sqrt()
  end

  @spec normalize(RayTracer.Tuple.t()) :: RayTracer.Tuple.t()
  def normalize(v) do
    magnitude = magnitude(v)
    scalar_div(v, magnitude)
  end

  @spec dot(RayTracer.Tuple.t(), RayTracer.Tuple.t()) :: float
  def dot(a, b) do
    a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w
  end

  @spec cross(RayTracer.Tuple.t(), RayTracer.Tuple.t()) :: RayTracer.Tuple.t()
  def cross(a, b) do
    vector(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x)
  end
end
