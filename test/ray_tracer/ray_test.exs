defmodule RayTracer.RayTest do
  use ExUnit.Case

  import RayTracer.{Core, Ray}
  alias RayTracer.Transformation

  test "Creating and querying a ray" do
    origin = point(1, 2, 3)
    direction = vector(4, 5, 6)
    r = ray(origin, direction)

    assert r.origin == origin
    assert r.direction == direction
  end

  test "Computing a point from a distance" do
    r = ray(point(2, 3, 4), vector(1, 0, 0))
    assert position(r, 0) == point(2, 3, 4)
    assert position(r, 1) == point(3, 3, 4)
    assert position(r, -1) == point(1, 3, 4)
    assert position(r, 2.5) == point(4.5, 3, 4)
  end

  test "Translating a ray" do
    r = ray(point(1, 2, 3), vector(0, 1, 0))
    m = Transformation.translation(3, 4, 5)
    r2 = transform(r, m)
    assert r2.origin == point(4, 6, 8)
    assert r2.direction == vector(0, 1, 0)
  end

  test "Scaling a ray" do
    r = ray(point(1, 2, 3), vector(0, 1, 0))
    m = Transformation.scaling(2, 3, 4)
    r2 = transform(r, m)
    assert r2.origin == point(2, 6, 12)
    assert r2.direction == vector(0, 3, 0)
  end
end
