defmodule RayTracer.TransformationTest do
  use ExUnit.Case
  use ExUnitProperties

  import RayTracer.{Core, Transformation}
  alias RayTracer.Matrix

  test "Multiplying by a translation matrix" do
    transform = translation(5, -3, 2)
    p = point(-3, 4, 5)
    assert Matrix.mul(transform, p) == point(2, 1, 7)
  end

  test "Multiplying by the inverse of a translation matrix" do
    inv = translation(5, -3, 2) |> Matrix.inverse()
    p = point(-3, 4, 5)
    assert Matrix.mul(inv, p) == point(-8, 7, 3)
  end

  property "Translation does not affect vectors" do
    check all tx <- StreamData.float(min: -128, max: 128),
              ty <- StreamData.float(min: -128, max: 128),
              tz <- StreamData.float(min: -128, max: 128),
              vx <- StreamData.float(min: -128, max: 128),
              vy <- StreamData.float(min: -128, max: 128),
              vz <- StreamData.float(min: -128, max: 128) do
      transform = translation(tx, ty, tz)
      v = vector(vx, vy, vz)
      assert approx_eq(Matrix.mul(transform, v), v)
    end
  end

  test "A scaling matrix applied to a point" do
    transform = scaling(2, 3, 4)
    p = point(-4, 6, 8)
    assert Matrix.mul(transform, p) == point(-8, 18, 32)
  end

  test "A scaling matrix applied to a vector" do
    transform = scaling(2, 3, 4)
    v = vector(-4, 6, 8)
    assert Matrix.mul(transform, v) == vector(-8, 18, 32)
  end

  test "Multiplying by the inverse of a scaling matrix" do
    inv = scaling(2, 3, 4) |> Matrix.inverse()
    v = vector(-4, 6, 8)
    assert Matrix.mul(inv, v) == vector(-2, 2, 2)
  end

  test "Reflection is scaling by a negative value" do
    transform = scaling(-1, 1, 1)
    p = point(2, 3, 4)
    assert Matrix.mul(transform, p) == point(-2, 3, 4)
  end

  test "Rotating a point around the x axis" do
    p = point(0, 1, 0)
    half_quarter = rotation_x(:math.pi() / 4)
    full_quarter = rotation_x(:math.pi() / 2)

    assert approx_eq(
             Matrix.mul(half_quarter, p),
             point(0, :math.sqrt(2) / 2, :math.sqrt(2) / 2)
           )

    assert approx_eq(Matrix.mul(full_quarter, p), point(0, 0, 1))
  end

  test "The inverse of an x-rotation rotates in the opposite direction" do
    p = point(0, 1, 0)
    inv = rotation_x(:math.pi() / 4) |> Matrix.inverse()

    assert approx_eq(
             Matrix.mul(inv, p),
             point(0, :math.sqrt(2) / 2, -:math.sqrt(2) / 2)
           )
  end

  test "Rotating a point around the y axis" do
    p = point(0, 0, 1)
    half_quarter = rotation_y(:math.pi() / 4)
    full_quarter = rotation_y(:math.pi() / 2)

    assert approx_eq(
             Matrix.mul(half_quarter, p),
             point(:math.sqrt(2) / 2, 0, :math.sqrt(2) / 2)
           )

    assert approx_eq(Matrix.mul(full_quarter, p), point(1, 0, 0))
  end

  test "Rotating a point around the z axis" do
    p = point(0, 1, 0)
    half_quarter = rotation_z(:math.pi() / 4)
    full_quarter = rotation_z(:math.pi() / 2)

    assert approx_eq(
             Matrix.mul(half_quarter, p),
             point(-:math.sqrt(2) / 2, :math.sqrt(2) / 2, 0)
           )

    assert approx_eq(Matrix.mul(full_quarter, p), point(-1, 0, 0))
  end

  test "A shearing transformation moves x in proportion to y" do
    transform = shearing(1, 0, 0, 0, 0, 0)
    p = point(2, 3, 4)
    assert Matrix.mul(transform, p) == point(5, 3, 4)
  end

  test "A shearing transformation moves x in proportion to z" do
    transform = shearing(0, 1, 0, 0, 0, 0)
    p = point(2, 3, 4)
    assert Matrix.mul(transform, p) == point(6, 3, 4)
  end

  test "A shearing transformation moves y in proportion to x" do
    transform = shearing(0, 0, 1, 0, 0, 0)
    p = point(2, 3, 4)
    assert Matrix.mul(transform, p) == point(2, 5, 4)
  end

  test "A shearing transformation moves y in proportion to z" do
    transform = shearing(0, 0, 0, 1, 0, 0)
    p = point(2, 3, 4)
    assert Matrix.mul(transform, p) == point(2, 7, 4)
  end

  test "A shearing transformation moves z in proportion to x" do
    transform = shearing(0, 0, 0, 0, 1, 0)
    p = point(2, 3, 4)
    assert Matrix.mul(transform, p) == point(2, 3, 6)
  end

  test "A shearing transformation moves z in proportion to y" do
    transform = shearing(0, 0, 0, 0, 0, 1)
    p = point(2, 3, 4)
    assert Matrix.mul(transform, p) == point(2, 3, 7)
  end

  test "Individual transformations are applied in sequence" do
    p = point(1, 0, 1)
    a = rotation_x(:math.pi() / 2)
    b = scaling(5, 5, 5)
    c = translation(10, 5, 7)
    p2 = Matrix.mul(a, p)
    p3 = Matrix.mul(b, p2)
    p4 = Matrix.mul(c, p3)

    assert approx_eq(p2, point(1, -1, 0))
    assert approx_eq(p3, point(5, -5, 0))
    assert approx_eq(p4, point(15, 0, 7))
  end

  test "Chained transformations must be applied in reverse order" do
    p = point(1, 0, 1)

    transform =
      translation(10, 5, 7)
      |> scaling(5, 5, 5)
      |> rotation_x(:math.pi() / 2)

    assert approx_eq(Matrix.mul(transform, p), point(15, 0, 7))
  end

  test "The transformation matrix for the default orientation" do
    from = point(0, 0, 0)
    to = point(0, 0, -1)
    up = vector(0, 1, 0)
    t = view_transform(from, to, up)
    assert approx_eq(t, Matrix.identity(4))
  end

  test "A view transformation matrix looking in positive z direction" do
    from = point(0, 0, 0)
    to = point(0, 0, 1)
    up = vector(0, 1, 0)
    t = view_transform(from, to, up)
    assert approx_eq(t, scaling(-1, 1, -1))
  end

  test "The view transformation moves the world" do
    from = point(0, 0, 8)
    to = point(0, 0, 0)
    up = vector(0, 1, 0)
    t = view_transform(from, to, up)
    assert approx_eq(t, translation(0, 0, -8))
  end

  test "An arbitrary view transformation" do
    from = point(1, 3, 2)
    to = point(4, -2, 8)
    up = vector(1, 1, 0)
    t = view_transform(from, to, up)

    assert approx_eq(
             t,
             Matrix.matrix(
               {{-0.50709, 0.50709, 0.67612, -2.36643}, {0.76772, 0.60609, 0.12122, -2.82843},
                {-0.35857, 0.59761, -0.71714, 0.00000}, {0.00000, 0.00000, 0.00000, 1.00000}}
             )
           )
  end
end
