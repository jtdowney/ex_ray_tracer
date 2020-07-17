defmodule RayTracer.TransformationTest do
  use ExUnit.Case
  use ExUnitProperties

  import RayTracer.Matrix
  import RayTracer.Transformation
  import RayTracer.Tuple
  import :math

  test "Multiplying by a translation matrix" do
    transform = translation(5, -3, 2)
    p = point(-3, 4, 5)
    assert mul(transform, p) == point(2, 1, 7)
  end

  test "Multiplying by the inverse of a translation matrix" do
    inv = translation(5, -3, 2) |> inverse
    p = point(-3, 4, 5)
    assert mul(inv, p) == point(-8, 7, 3)
  end

  property "Translation does not affect vectors" do
    check all tx <- StreamData.float(),
              ty <- StreamData.float(),
              tz <- StreamData.float(),
              vx <- StreamData.float(),
              vy <- StreamData.float(),
              vz <- StreamData.float() do
      transform = translation(tx, ty, tz)
      v = vector(vx, vy, vz)
      assert mul(transform, v) == v
    end
  end

  test "A scaling matrix applied to a point" do
    transform = scaling(2, 3, 4)
    p = point(-4, 6, 8)
    assert mul(transform, p) == point(-8, 18, 32)
  end

  test "A scaling matrix applied to a vector" do
    transform = scaling(2, 3, 4)
    v = vector(-4, 6, 8)
    assert mul(transform, v) == vector(-8, 18, 32)
  end

  test "Multiplying by the inverse of a scaling matrix" do
    inv = scaling(2, 3, 4) |> inverse
    v = vector(-4, 6, 8)
    assert mul(inv, v) == vector(-2, 2, 2)
  end

  test "Reflection is scaling by a negative value" do
    transform = scaling(-1, 1, 1)
    p = point(2, 3, 4)
    assert mul(transform, p) == point(-2, 3, 4)
  end

  test "Rotating a point around the x axis" do
    p = point(0, 1, 0)
    half_quarter = rotation_x(pi() / 4)
    full_quarter = rotation_x(pi() / 2)
    assert RayTracer.Tuple.approx_eq(mul(half_quarter, p), point(0, sqrt(2) / 2, sqrt(2) / 2))
    assert RayTracer.Tuple.approx_eq(mul(full_quarter, p), point(0, 0, 1))
  end

  test "The inverse of an x-rotation rotates in the opposite direction" do
    p = point(0, 1, 0)
    inv = rotation_x(pi() / 4) |> inverse
    assert RayTracer.Tuple.approx_eq(mul(inv, p), point(0, sqrt(2) / 2, -sqrt(2) / 2))
  end

  test "Rotating a point around the y axis" do
    p = point(0, 0, 1)
    half_quarter = rotation_y(pi() / 4)
    full_quarter = rotation_y(pi() / 2)
    assert RayTracer.Tuple.approx_eq(mul(half_quarter, p), point(sqrt(2) / 2, 0, sqrt(2) / 2))
    assert RayTracer.Tuple.approx_eq(mul(full_quarter, p), point(1, 0, 0))
  end

  test "Rotating a point around the z axis" do
    p = point(0, 1, 0)
    half_quarter = rotation_z(pi() / 4)
    full_quarter = rotation_z(pi() / 2)
    assert RayTracer.Tuple.approx_eq(mul(half_quarter, p), point(-sqrt(2) / 2, sqrt(2) / 2, 0))
    assert RayTracer.Tuple.approx_eq(mul(full_quarter, p), point(-1, 0, 0))
  end

  test "A shearing transformation moves x in proportion to y" do
    transform = shearing(1, 0, 0, 0, 0, 0)
    p = point(2, 3, 4)
    assert mul(transform, p) == point(5, 3, 4)
  end

  test "A shearing transformation moves x in proportion to z" do
    transform = shearing(0, 1, 0, 0, 0, 0)
    p = point(2, 3, 4)
    assert mul(transform, p) == point(6, 3, 4)
  end

  test "A shearing transformation moves y in proportion to x" do
    transform = shearing(0, 0, 1, 0, 0, 0)
    p = point(2, 3, 4)
    assert mul(transform, p) == point(2, 5, 4)
  end

  test "A shearing transformation moves y in proportion to z" do
    transform = shearing(0, 0, 0, 1, 0, 0)
    p = point(2, 3, 4)
    assert mul(transform, p) == point(2, 7, 4)
  end

  test "A shearing transformation moves z in proportion to x" do
    transform = shearing(0, 0, 0, 0, 1, 0)
    p = point(2, 3, 4)
    assert mul(transform, p) == point(2, 3, 6)
  end

  test "A shearing transformation moves z in proportion to y" do
    transform = shearing(0, 0, 0, 0, 0, 1)
    p = point(2, 3, 4)
    assert mul(transform, p) == point(2, 3, 7)
  end

  test "Individual transformations are applied in sequence" do
    p = point(1, 0, 1)
    a = rotation_x(pi() / 2)
    b = scaling(5, 5, 5)
    c = translation(10, 5, 7)
    p2 = mul(a, p)
    p3 = mul(b, p2)
    p4 = mul(c, p3)

    assert RayTracer.Tuple.approx_eq(p2, point(1, -1, 0))
    assert RayTracer.Tuple.approx_eq(p3, point(5, -5, 0))
    assert RayTracer.Tuple.approx_eq(p4, point(15, 0, 7))
  end

  test "Chained transformations must be applied in reverse order" do
    p = point(1, 0, 1)

    transform =
      translation(10, 5, 7)
      |> scaling(5, 5, 5)
      |> rotation_x(pi() / 2)

    assert RayTracer.Tuple.approx_eq(mul(transform, p), point(15, 0, 7))
  end
end
