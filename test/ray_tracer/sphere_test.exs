defmodule RayTracer.SphereTest do
  use ExUnit.Case

  import RayTracer.{Matrix, Ray, Sphere, Transformation, Tuple}

  test "A ray intersects a sphere at two points" do
    r = ray(point(0, 0, -5), vector(0, 0, 1))
    s = sphere()
    xs = intersect(s, r)
    assert xs == [4, 6]
  end

  test "A ray intersects a sphere at a tangent" do
    r = ray(point(0, 1, -5), vector(0, 0, 1))
    s = sphere()
    xs = intersect(s, r)
    assert xs == [5, 5]
  end

  test "A ray misses a sphere" do
    r = ray(point(0, 2, -5), vector(0, 0, 1))
    s = sphere()
    xs = intersect(s, r)
    assert xs == []
  end

  test "A ray originates inside a sphere" do
    r = ray(point(0, 0, 0), vector(0, 0, 1))
    s = sphere()
    xs = intersect(s, r)
    assert xs == [-1, 1]
  end

  test "A sphere is behind a ray" do
    r = ray(point(0, 0, 5), vector(0, 0, 1))
    s = sphere()
    xs = intersect(s, r)
    assert xs == [-6, -4]
  end

  test "A sphere's default transformation" do
    s = sphere()
    assert s.transform == identity(4)
  end

  test "Changing a sphere's transformation" do
    s = sphere()
    t = translation(2, 3, 4)
    s = put_transform(s, t)
    assert s.transform == t
  end

  test "Intersecting a scaled sphere with a ray" do
    r = ray(point(0, 0, -5), vector(0, 0, 1))
    s = sphere()
    s = put_transform(s, scaling(2, 2, 2))
    xs = intersect(s, r)
    assert xs == [3, 7]
  end

  test "Intersecting a translated sphere with a ray" do
    r = ray(point(0, 0, -5), vector(0, 0, 1))
    s = sphere()
    s = put_transform(s, translation(5, 0, 0))
    xs = intersect(s, r)
    assert xs == []
  end
end
