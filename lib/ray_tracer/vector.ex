defmodule RayTracer.Vector do
  import RayTracer.Tuple

  @spec magnitude(RayTracer.Tuple.t()) :: float
  def magnitude({x, y, z, _}) do
    (:math.pow(x, 2) + :math.pow(y, 2) + :math.pow(z, 2))
    |> :math.sqrt()
  end

  @spec normalize(RayTracer.Tuple.t()) :: RayTracer.Tuple.t()
  def normalize(v) do
    magnitude = magnitude(v)
    scalar_div(v, magnitude)
  end

  @spec dot(RayTracer.Tuple.t(), RayTracer.Tuple.t()) :: float
  def dot({ax, ay, az, aw}, {bx, by, bz, bw}) do
    ax * bx + ay * by + az * bz + aw * bw
  end

  @spec cross(RayTracer.Tuple.t(), RayTracer.Tuple.t()) :: RayTracer.Tuple.t()
  def cross({ax, ay, az, _}, {bx, by, bz, _}) do
    vector(ay * bz - az * by, az * bx - ax * bz, ax * by - ay * bx)
  end
end
