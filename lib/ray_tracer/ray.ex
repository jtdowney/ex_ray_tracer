defmodule RayTracer.Ray do
  import RayTracer.Core
  alias RayTracer.Matrix

  def ray(origin, direction) do
    %{origin: origin, direction: direction}
  end

  def position(%{origin: origin, direction: direction}, t) do
    offset = scalar_mul(direction, t)
    add(origin, offset)
  end

  def transform(%{origin: origin, direction: direction}, transform) do
    origin = Matrix.mul(transform, origin)
    direction = Matrix.mul(transform, direction)
    ray(origin, direction)
  end
end
