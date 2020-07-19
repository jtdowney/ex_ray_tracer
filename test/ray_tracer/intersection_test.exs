defmodule RayTracer.IntersectionTest do
  use ExUnit.Case

  import RayTracer.{Core, Intersection}
  alias RayTracer.{Ray, Sphere, Transformation}

  test "An intersection encapsulates t and object" do
    s = Sphere.sphere()
    i = intersection(3.5, s)
    assert i.t == 3.5
    assert i.object == s
  end

  test "Aggregating intersections" do
    s = Sphere.sphere()
    i1 = intersection(1, s)
    i2 = intersection(2, s)
    xs = intersections([i1, i2])
    assert Enum.at(xs, 0).t == 1
    assert Enum.at(xs, 1).t == 2
  end

  test "Intersect sets the object on the intersection" do
    s = Sphere.sphere()
    i1 = intersection(1, s)
    i2 = intersection(2, s)
    xs = intersections([i1, i2])
    assert Enum.at(xs, 0).object == s
    assert Enum.at(xs, 1).object == s
  end

  test "The hit, when all intersections have positive t" do
    s = Sphere.sphere()
    i1 = intersection(1, s)
    i2 = intersection(2, s)
    xs = intersections([i1, i2])
    assert hit(xs) == i1
  end

  test "The hit, when some intersections have negative t" do
    s = Sphere.sphere()
    i1 = intersection(-1, s)
    i2 = intersection(1, s)
    xs = intersections([i1, i2])
    assert hit(xs) == i2
  end

  test "The hit, when all intersections have negative t" do
    s = Sphere.sphere()
    i1 = intersection(-2, s)
    i2 = intersection(-1, s)
    xs = intersections([i1, i2])
    assert hit(xs) == nil
  end

  test "The hit is always the lowest nonnegative intersection" do
    s = Sphere.sphere()
    i1 = intersection(5, s)
    i2 = intersection(7, s)
    i3 = intersection(-3, s)
    i4 = intersection(2, s)
    xs = intersections([i1, i2, i3, i4])
    assert hit(xs) == i4
  end

  test "Precomputing the state of an intersection" do
    r = Ray.ray(point(0, 0, -5), vector(0, 0, 1))
    shape = Sphere.sphere()
    i = intersection(4, shape)
    comps = prepare_computations(i, r)
    assert comps.t == i.t
    assert comps.object == i.object
    assert comps.point == point(0, 0, -1)
    assert comps.eyev == vector(0, 0, -1)
    assert comps.normalv == vector(0, 0, -1)
  end

  test "The hit, when an intersection occurs on the outside" do
    r = Ray.ray(point(0, 0, -5), vector(0, 0, 1))
    shape = Sphere.sphere()
    i = intersection(4, shape)
    comps = prepare_computations(i, r)
    refute comps.inside
  end

  test "The hit, when an intersection occurs on the inside" do
    r = Ray.ray(point(0, 0, 0), vector(0, 0, 1))
    shape = Sphere.sphere()
    i = intersection(1, shape)
    comps = prepare_computations(i, r)
    assert comps.inside
    assert comps.point == point(0, 0, 1)
    assert comps.eyev == vector(0, 0, -1)
    assert comps.normalv == vector(0, 0, -1)
  end

  test "The hit should offset the point" do
    r = Ray.ray(point(0, 0, -5), vector(0, 0, 1))
    shape = Sphere.sphere() |> Map.put(:transform, Transformation.translation(0, 0, 1))
    i = intersection(5, shape)
    comps = prepare_computations(i, r)
    assert comps.over_point |> elem(2) < -epsilon() / 2
    assert comps.point |> elem(2) > comps.over_point |> elem(2)
  end
end
