defmodule RayTracer.IntersectionTest do
  use ExUnit.Case

  import RayTracer.{Intersection, Sphere}

  test "An intersection encapsulates t and object" do
    s = sphere()
    i = intersection(3.5, s)
    assert i.t == 3.5
    assert i.object == s
  end

  test "Aggregating intersections" do
    s = sphere()
    i1 = intersection(1, s)
    i2 = intersection(2, s)
    xs = intersections([i1, i2])
    assert Enum.at(xs, 0).t == 1
    assert Enum.at(xs, 1).t == 2
  end

  test "Intersect sets the object on the intersection" do
    s = sphere()
    i1 = intersection(1, s)
    i2 = intersection(2, s)
    xs = intersections([i1, i2])
    assert Enum.at(xs, 0).object == s
    assert Enum.at(xs, 1).object == s
  end

  test "The hit, when all intersections have positive t" do
    s = sphere()
    i1 = intersection(1, s)
    i2 = intersection(2, s)
    xs = intersections([i1, i2])
    assert hit(xs) == i1
  end

  test "The hit, when some intersections have negative t" do
    s = sphere()
    i1 = intersection(-1, s)
    i2 = intersection(1, s)
    xs = intersections([i1, i2])
    assert hit(xs) == i2
  end

  test "The hit, when all intersections have negative t" do
    s = sphere()
    i1 = intersection(-2, s)
    i2 = intersection(-1, s)
    xs = intersections([i1, i2])
    assert hit(xs) == nil
  end

  test "The hit is always the lowest nonnegative intersection" do
    s = sphere()
    i1 = intersection(5, s)
    i2 = intersection(7, s)
    i3 = intersection(-3, s)
    i4 = intersection(2, s)
    xs = intersections([i1, i2, i3, i4])
    assert hit(xs) == i4
  end
end
