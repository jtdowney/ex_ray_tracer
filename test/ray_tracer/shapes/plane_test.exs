defmodule RayTracer.Shapes.PlaneTest do
  use ExUnit.Case

  import RayTracer.Core
  import RayTracer.Shapes.Plane
  alias RayTracer.{Ray, Renderable}

  test "The normal of a plane is constant everywhere" do
    p = plane()
    n1 = Renderable.local_normal_at(p, point(0, 0, 0))
    n2 = Renderable.local_normal_at(p, point(10, 0, -10))
    n3 = Renderable.local_normal_at(p, point(-5, 0, 150))

    assert n1 == vector(0, 1, 0)
    assert n2 == vector(0, 1, 0)
    assert n3 == vector(0, 1, 0)
  end

  test "Intersect with a ray parallel to the plane" do
    p = plane()
    r = Ray.ray(point(0, 10, 0), vector(0, 0, 1))
    xs = Renderable.local_intersect(p, r)

    assert Enum.empty?(xs)
  end

  test "Intersect with a coplanar ray" do
    p = plane()
    r = Ray.ray(point(0, 0, 0), vector(0, 0, 1))
    xs = Renderable.local_intersect(p, r)

    assert Enum.empty?(xs)
  end

  test "A ray intersecting a plane from above" do
    p = plane()
    r = Ray.ray(point(0, 1, 0), vector(0, -1, 0))
    [i] = Renderable.local_intersect(p, r)

    assert i.t == 1
    assert i.object == p
  end

  test "A ray intersecting a plane from below" do
    p = plane()
    r = Ray.ray(point(0, -1, 0), vector(0, 1, 0))
    [i] = Renderable.local_intersect(p, r)

    assert i.t == 1
    assert i.object == p
  end
end
