defmodule RayTracer.Tuple do
  def approx_eq({ax, ay, az, aw}, {bx, by, bz, bw}) do
    e = RayTracer.epsilon()
    xdiff = abs(ax - bx)
    ydiff = abs(ay - by)
    zdiff = abs(az - bz)
    wdiff = abs(aw - bw)
    xdiff <= e && ydiff <= e && zdiff <= e && wdiff <= e
  end

  def tuple(x, y, z, w) do
    {x, y, z, w}
  end

  def color(red, green, blue) do
    tuple(red, green, blue, 0.0)
  end

  def point(x, y, z) do
    tuple(x, y, z, 1.0)
  end

  def vector(x, y, z) do
    tuple(x, y, z, 0.0)
  end

  def add({ax, ay, az, aw}, {bx, by, bz, bw}) do
    tuple(ax + bx, ay + by, az + bz, aw + bw)
  end

  def sub({ax, ay, az, aw}, {bx, by, bz, bw}) do
    tuple(ax - bx, ay - by, az - bz, aw - bw)
  end

  def hadamard_product({ax, ay, az, aw}, {bx, by, bz, bw}) do
    tuple(ax * bx, ay * by, az * bz, aw * bw)
  end

  def negate({x, y, z, w}) do
    tuple(-x, -y, -z, -w)
  end

  def scalar_mul({x, y, z, w}, n) do
    tuple(x * n, y * n, z * n, w * n)
  end

  def scalar_div({x, y, z, w}, n) when n != 0 do
    tuple(x / n, y / n, z / n, w / n)
  end

  def is_point?({_, _, _, w}) do
    w == 1.0
  end

  def is_vector?({_, _, _, w}) do
    w == 0.0
  end
end
