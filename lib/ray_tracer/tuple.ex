defmodule RayTracer.Tuple do
  @type t :: %{x: float, y: float, z: float, w: float}

  @spec approx_eq(t, t) :: boolean
  def approx_eq(a, b) do
    epsilon = RayTracer.epsilon()
    xdiff = abs(a.x - b.x)
    ydiff = abs(a.y - b.y)
    zdiff = abs(a.z - b.z)
    wdiff = abs(a.w - b.w)
    xdiff <= epsilon && ydiff <= epsilon && zdiff <= epsilon && wdiff <= epsilon
  end

  @spec tuple(float, float, float, float) :: t
  def tuple(x, y, z, w) do
    %{x: x, y: y, z: z, w: w}
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
  def add(a, b) do
    tuple(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w)
  end

  @spec sub(t, t) :: t
  def sub(a, b) do
    tuple(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w)
  end

  @spec negate(t) :: t
  def negate(a) do
    tuple(-a.x, -a.y, -a.z, -a.w)
  end

  @spec scalar_mult(t, float) :: t
  def scalar_mult(a, n) do
    tuple(a.x * n, a.y * n, a.z * n, a.w * n)
  end

  @spec scalar_div(t, float) :: t
  def scalar_div(a, n) do
    tuple(a.x / n, a.y / n, a.z / n, a.w / n)
  end

  @spec is_point?(t) :: boolean
  def is_point?(t) do
    t.w == 1.0
  end

  @spec is_vector?(t) :: boolean
  def is_vector?(t) do
    t.w == 0.0
  end
end
