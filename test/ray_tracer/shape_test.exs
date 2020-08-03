defmodule RayTracer.ShapeTest do
  use ExUnit.Case

  alias RayTracer.{Material, Matrix, Ray, Shape, Transformation}
  import RayTracer.Core
  import TestShape

  test "The default transformation" do
    s = test_shape()
    assert Map.get(s, :transform) == Matrix.identity(4)
  end

  test "The default material" do
    s = test_shape()
    assert Map.get(s, :material) == Material.material()
  end

  test "Intersecting a scaled shape with a ray" do
    r = Ray.ray(point(0, 0, -5), vector(0, 0, 1))
    s = test_shape()
    s = Map.put(s, :transform, Transformation.scaling(2, 2, 2))
    xs = Shape.intersect(s, r)
    s = hd(xs)
    assert s.saved_ray.origin == point(0, 0, -2.5)
    assert s.saved_ray.direction == vector(0, 0, 0.5)
  end

  test "Intersecting a translated shape with a ray" do
    r = Ray.ray(point(0, 0, -5), vector(0, 0, 1))
    s = test_shape()
    s = Map.put(s, :transform, Transformation.translation(5, 0, 0))
    xs = Shape.intersect(s, r)
    s = hd(xs)
    assert s.saved_ray.origin == point(-5, 0, -5)
    assert s.saved_ray.direction == vector(0, 0, 1)
  end

  test "Computing the normal on a translated shape" do
    s = test_shape()
    s = Map.put(s, :transform, Transformation.translation(0, 1, 0))
    n = Shape.normal_at(s, point(0, 1.70711, -0.70711))
    assert approx_eq(n, vector(0, 0.70711, -0.70711))
  end

  test "Computing the normal on a transformed shape" do
    t = Transformation.scaling(1, 0.5, 1) |> Transformation.rotation_z(:math.pi() / 5)
    s = test_shape() |> Map.put(:transform, t)

    n = Shape.normal_at(s, point(0, :math.sqrt(2) / 2, -:math.sqrt(2) / 2))
    assert approx_eq(n, vector(0, 0.97014, -0.24254))
  end
end
