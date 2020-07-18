defmodule RayTracer.VectorTest do
  use ExUnit.Case
  use ExUnitProperties

  import RayTracer
  import RayTracer.Tuple
  import RayTracer.Vector

  test "Computing the magnitude of vectors" do
    v = vector(1, 0, 0)
    assert magnitude(v) == 1
    v = vector(0, 1, 0)
    assert magnitude(v) == 1
    v = vector(0, 0, 1)
    assert magnitude(v) == 1
    v = vector(1, 2, 3)
    assert magnitude(v) == :math.sqrt(14)
    v = vector(-1, -2, -3)
    assert magnitude(v) == :math.sqrt(14)
  end

  test "Normalizing vector" do
    v = vector(4, 0, 0)
    assert normalize(v) == vector(1, 0, 0)
    v = vector(1, 2, 3)
    assert approx_eq(normalize(v), vector(0.26726, 0.53452, 0.80178))
  end

  property "Normalized vectors have magnitude of 1" do
    check all x <- StreamData.float(),
              y <- StreamData.float(),
              z <- StreamData.float() do
      v = vector(x, y, z) |> normalize()
      assert_in_delta magnitude(v), 1, epsilon()
    end
  end

  test "The dot product of two vectors" do
    a = vector(1, 2, 3)
    b = vector(2, 3, 4)
    assert dot(a, b) == 20
  end

  test "The cross product of two vectors" do
    a = vector(1, 2, 3)
    b = vector(2, 3, 4)
    assert cross(a, b) == vector(-1, 2, -1)
    assert cross(b, a) == vector(1, -2, 1)
  end

  test "Reflecting a vector approaching at 45°" do
    v = vector(1, -1, 0)
    n = vector(0, 1, 0)
    r = reflect(v, n)
    assert r == vector(1, 1, 0)
  end

  test "Reflecting a vector off a slanted surface" do
    v = vector(0, -1, 0)
    n = vector(:math.sqrt(2) / 2, :math.sqrt(2) / 2, 0)
    r = reflect(v, n)
    assert approx_eq(r, vector(1, 0, 0))
  end
end
