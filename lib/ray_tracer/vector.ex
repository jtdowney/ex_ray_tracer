defmodule RayTracer.Vector do
  import RayTracer.Tuple

  def magnitude({x, y, z, _}) do
    (:math.pow(x, 2) + :math.pow(y, 2) + :math.pow(z, 2))
    |> :math.sqrt()
  end

  def normalize(v) do
    magnitude = magnitude(v)
    scalar_div(v, magnitude)
  end

  def dot({ax, ay, az, aw}, {bx, by, bz, bw}) do
    ax * bx + ay * by + az * bz + aw * bw
  end

  def cross({ax, ay, az, _}, {bx, by, bz, _}) do
    vector(ay * bz - az * by, az * bx - ax * bz, ax * by - ay * bx)
  end

  def reflect(v, n) do
    sub(v, scalar_mul(n, 2 * dot(v, n)))
  end
end
