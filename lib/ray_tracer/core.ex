defmodule RayTracer.Core do
  @moduledoc """
  Core constructors and utilities for ray tracing.
  """

  defmacro epsilon(), do: quote(do: 0.00001)
  defmacro black(), do: quote(do: color(0, 0, 0))
  defmacro white(), do: quote(do: color(1, 1, 1))

  def approx_eq(a, b) when is_number(a) and is_number(b) do
    abs(a - b) <= epsilon()
  end

  def approx_eq(a, b) when is_list(a) and is_list(b) do
    Enum.zip(a, b) |> Enum.all?(fn {a, b} -> approx_eq(a, b) end)
  end

  def approx_eq(%RayTracer.Matrix.Native{} = a, %RayTracer.Matrix.Native{} = b) do
    RayTracer.Matrix.approx_eq(a, b)
  end

  def approx_eq(a, b) when is_map(a) and is_map(b) do
    approx_eq(Map.to_list(a), Map.to_list(b))
  end

  def approx_eq(a, b) when is_tuple(a) and is_tuple(b) do
    approx_eq(Tuple.to_list(a), Tuple.to_list(b))
  end

  def approx_eq(a, b) do
    a == b
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
