defmodule RayTracer.Ray do
  @moduledoc """
  A ray cast from a `RayTracer.Camera` in a `RayTracer.World`.
  """

  import RayTracer.Core
  alias RayTracer.Matrix

  defstruct [:origin, :direction]

  def ray(origin, direction) do
    %RayTracer.Ray{origin: origin, direction: direction}
  end

  def position(ray, t) do
    offset = scalar_mul(ray.direction, t)
    add(ray.origin, offset)
  end

  def transform(ray, transform) do
    origin = Matrix.mul(transform, ray.origin)
    direction = Matrix.mul(transform, ray.direction)
    ray(origin, direction)
  end
end
