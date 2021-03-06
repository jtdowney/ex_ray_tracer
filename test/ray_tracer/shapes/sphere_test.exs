defmodule RayTracer.Shapes.SphereTest do
  use ExUnit.Case

  alias RayTracer.{Material, Matrix, Ray, Shape, Transformation, Vector}
  import RayTracer.Core
  import RayTracer.Shapes.Sphere

  test "A ray intersects a sphere at two points" do
    r = Ray.ray(point(0, 0, -5), vector(0, 0, 1))
    s = sphere()
    xs = Shape.intersect(s, r)
    assert length(xs) == 2
    assert Enum.at(xs, 0).t == 4
    assert Enum.at(xs, 1).t == 6
  end

  test "A ray intersects a sphere at a tangent" do
    r = Ray.ray(point(0, 1, -5), vector(0, 0, 1))
    s = sphere()
    xs = Shape.intersect(s, r)
    assert length(xs) == 2
    assert Enum.at(xs, 0).t == 5
    assert Enum.at(xs, 1).t == 5
  end

  test "A ray misses a sphere" do
    r = Ray.ray(point(0, 2, -5), vector(0, 0, 1))
    s = sphere()
    xs = Shape.intersect(s, r)
    assert xs == []
  end

  test "A ray originates inside a sphere" do
    r = Ray.ray(point(0, 0, 0), vector(0, 0, 1))
    s = sphere()
    xs = Shape.intersect(s, r)
    assert length(xs) == 2
    assert Enum.at(xs, 0).t == -1
    assert Enum.at(xs, 1).t == 1
  end

  test "A sphere is behind a ray" do
    r = Ray.ray(point(0, 0, 5), vector(0, 0, 1))
    s = sphere()
    xs = Shape.intersect(s, r)
    assert length(xs) == 2
    assert Enum.at(xs, 0).t == -6
    assert Enum.at(xs, 1).t == -4
  end

  test "A sphere's default transformation" do
    s = sphere()
    assert s.transform == Matrix.identity(4)
  end

  test "Changing a sphere's transformation" do
    s = sphere()
    t = Transformation.translation(2, 3, 4)
    s = Map.put(s, :transform, t)
    assert s.transform == t
  end

  test "Intersecting a scaled sphere with a ray" do
    r = Ray.ray(point(0, 0, -5), vector(0, 0, 1))
    s = sphere()
    s = Map.put(s, :transform, Transformation.scaling(2, 2, 2))
    xs = Shape.intersect(s, r)
    assert length(xs) == 2
    assert Enum.at(xs, 0).t == 3
    assert Enum.at(xs, 1).t == 7
  end

  test "Intersecting a translated sphere with a ray" do
    r = Ray.ray(point(0, 0, -5), vector(0, 0, 1))
    s = sphere()
    s = Map.put(s, :transform, Transformation.translation(5, 0, 0))
    xs = Shape.intersect(s, r)
    assert xs == []
  end

  test "The normal on a sphere at a point on the x axis" do
    s = sphere()
    n = Shape.normal_at(s, point(1, 0, 0))
    assert n == vector(1, 0, 0)
  end

  test "The normal on a sphere at a point on the y axis" do
    s = sphere()
    n = Shape.normal_at(s, point(0, 1, 0))
    assert n == vector(0, 1, 0)
  end

  test "The normal on a sphere at a point on the z axis" do
    s = sphere()
    n = Shape.normal_at(s, point(0, 0, 1))
    assert n == vector(0, 0, 1)
  end

  test "The normal on a sphere at a nonaxial point" do
    s = sphere()
    n = Shape.normal_at(s, point(:math.sqrt(3) / 3, :math.sqrt(3) / 3, :math.sqrt(3) / 3))
    assert n == vector(:math.sqrt(3) / 3, :math.sqrt(3) / 3, :math.sqrt(3) / 3)
  end

  test "The normal is a normalized vector" do
    s = sphere()
    n = Shape.normal_at(s, point(:math.sqrt(3) / 3, :math.sqrt(3) / 3, :math.sqrt(3) / 3))
    assert n == Vector.normalize(n)
  end

  test "Computing the normal on a translated sphere" do
    s = sphere()
    s = Map.put(s, :transform, Transformation.translation(0, 1, 0))
    n = Shape.normal_at(s, point(0, 1.70711, -0.70711))
    assert approx_eq(n, vector(0, 0.70711, -0.70711))
  end

  test "Computing the normal on a transformed sphere" do
    s = sphere()
    m = Transformation.scaling(1, 0.5, 1) |> Transformation.rotation_z(:math.pi() / 5)
    s = Map.put(s, :transform, m)
    n = Shape.normal_at(s, point(0, :math.sqrt(2) / 2, -:math.sqrt(2) / 2))
    assert approx_eq(n, vector(0, 0.97014, -0.24254))
  end

  test "A sphere has a default material" do
    s = sphere()
    assert s.material == Material.material()
  end

  test "A sphere may be assigned a material" do
    s = sphere()
    m = Material.material()
    m = Map.put(m, :ambient, 1)
    s = Map.put(s, :material, m)
    assert s.material == m
  end
end
