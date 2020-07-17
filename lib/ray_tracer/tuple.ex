defmodule RayTracer.Tuple do
  @type t :: {float, float, float, float}

  @spec approx_eq(t, t) :: boolean
  def approx_eq({ax, ay, az, aw}, {bx, by, bz, bw}) do
    e = RayTracer.epsilon()
    xdiff = abs(ax - bx)
    ydiff = abs(ay - by)
    zdiff = abs(az - bz)
    wdiff = abs(aw - bw)
    xdiff <= e && ydiff <= e && zdiff <= e && wdiff <= e
  end

  @spec tuple(float, float, float, float) :: t
  def tuple(x, y, z, w) do
    {x, y, z, w}
  end

  @spec color(float, float, float) :: t
  def color(red, green, blue) do
    tuple(red, green, blue, 0.0)
  end

  @spec point(float, float, float) :: t
  def point(x, y, z) do
    tuple(x, y, z, 1.0)
  end

  @spec vector(float, float, float) :: t
  def vector(x, y, z) do
    tuple(x, y, z, 0.0)
  end

  @spec add(t, t) :: t
  def add({ax, ay, az, aw}, {bx, by, bz, bw}) do
    tuple(ax + bx, ay + by, az + bz, aw + bw)
  end

  @spec sub(t, t) :: t
  def sub({ax, ay, az, aw}, {bx, by, bz, bw}) do
    tuple(ax - bx, ay - by, az - bz, aw - bw)
  end

  @spec hadamard_product(t, t) :: t
  def hadamard_product({ax, ay, az, aw}, {bx, by, bz, bw}) do
    tuple(ax * bx, ay * by, az * bz, aw * bw)
  end

  @spec negate(t) :: t
  def negate({x, y, z, w}) do
    tuple(-x, -y, -z, -w)
  end

  @spec scalar_mult(t, float) :: t
  def scalar_mult({x, y, z, w}, n) do
    tuple(x * n, y * n, z * n, w * n)
  end

  @spec scalar_div(t, float) :: t
  def scalar_div({x, y, z, w}, n) when n != 0 do
    tuple(x / n, y / n, z / n, w / n)
  end

  @spec is_point?(t) :: boolean
  def is_point?({_, _, _, w}) do
    w == 1.0
  end

  @spec is_vector?(t) :: boolean
  def is_vector?({_, _, _, w}) do
    w == 0.0
  end
end
