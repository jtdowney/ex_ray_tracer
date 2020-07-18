defmodule RayTracer.Ray do
  import RayTracer.{Matrix, Tuple}

  def ray(origin, direction) do
    %{origin: origin, direction: direction}
  end

  def position(%{origin: origin, direction: direction}, t) do
    offset = scalar_mul(direction, t)
    add(origin, offset)
  end

  def transform(%{origin: origin, direction: direction}, transform) do
    origin = mul(transform, origin)
    direction = mul(transform, direction)
    ray(origin, direction)
  end
end
