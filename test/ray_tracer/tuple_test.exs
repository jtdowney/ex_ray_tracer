defmodule RayTracer.TupleTest do
  use ExUnit.Case
  use ExUnitProperties

  import RayTracer
  import RayTracer.Tuple

  test "tuple with w=1.0 is a point" do
    a = tuple(4.3, -4.2, 3.1, 1.0)
    {x, y, z, w} = a
    assert_in_delta x, 4.3, epsilon()
    assert_in_delta y, -4.2, epsilon()
    assert_in_delta z, 3.1, epsilon()
    assert_in_delta w, 1.0, epsilon()
    assert is_point?(a)
    refute is_vector?(a)
  end

  test "tuple with w=0.0 is a vector" do
    a = tuple(4.3, -4.2, 3.1, 0.0)
    {x, y, z, w} = a
    assert_in_delta x, 4.3, epsilon()
    assert_in_delta y, -4.2, epsilon()
    assert_in_delta z, 3.1, epsilon()
    assert_in_delta w, 0.0, epsilon()
    refute is_point?(a)
    assert is_vector?(a)
  end

  test "point() creates tuples with w=1" do
    p = point(4, -4, 3)
    assert p == tuple(4, -4, 3, 1)
  end

  test "vector() creates tuples with w=0" do
    p = vector(4, -4, 3)
    assert p == tuple(4, -4, 3, 0)
  end

  test "Adding two tuples" do
    a1 = tuple(3, -2, 5, 1)
    a2 = tuple(-2, 3, 1, 0)
    assert add(a1, a2) == tuple(1, 1, 6, 1)
  end

  test "Subtracting two points" do
    p1 = point(3, 2, 1)
    p2 = point(5, 6, 7)
    assert sub(p1, p2) == vector(-2, -4, -6)
  end

  test "Subtracting a vector from a point" do
    p = point(3, 2, 1)
    v = vector(5, 6, 7)
    assert sub(p, v) == point(-2, -4, -6)
  end

  test "Subtracting two vectors" do
    v1 = vector(3, 2, 1)
    v2 = vector(5, 6, 7)
    assert sub(v1, v2) == vector(-2, -4, -6)
  end

  test "Subtracting a vector from the zero vector" do
    zero = vector(0, 0, 0)
    v = vector(1, -2, 3)
    assert sub(zero, v) == vector(-1, 2, -3)
  end

  test "Negating a tuple" do
    a = tuple(1, -2, 3, -4)
    assert negate(a) == tuple(-1, 2, -3, 4)
  end

  test "Multiplying a tuple by a scalar" do
    a = tuple(1, -2, 3, -4)
    assert scalar_mult(a, 3.5) == tuple(3.5, -7, 10.5, -14)
  end

  test "Multiplying a tuple by a fraction" do
    a = tuple(1, -2, 3, -4)
    assert scalar_mult(a, 0.5) == tuple(0.5, -1, 1.5, -2)
  end

  test "Dividing a tuple by a scalar" do
    a = tuple(1, -2, 3, -4)
    assert scalar_div(a, 2) == tuple(0.5, -1, 1.5, -2)
  end

  test "Colors are (red, green, blue) tuples" do
    c = color(-0.5, 0.4, 1.7)
    {red, green, blue, _} = c
    assert red == -0.5
    assert green == 0.4
    assert blue == 1.7
  end

  test "Multiplying colors" do
    c1 = color(1, 0.2, 0.4)
    c2 = color(0.9, 1, 0.1)
    assert approx_eq(hadamard_product(c1, c2), color(0.9, 0.2, 0.04))
  end
end
