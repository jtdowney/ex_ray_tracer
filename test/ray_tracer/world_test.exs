defmodule RayTracer.WorldTest do
  use ExUnit.Case

  import RayTracer.{Core, World}
  alias RayTracer.{Intersection, Light, Material, Ray, Shapes.Sphere, Transformation}

  setup do
    light = Light.point_light(point(-10, 10, -10), color(1, 1, 1))

    m =
      Material.material()
      |> Map.put(:color, color(0.8, 1.0, 0.6))
      |> Map.put(:diffuse, 0.7)
      |> Map.put(:specular, 0.2)

    s1 = Sphere.sphere() |> Map.put(:material, m)
    t = Transformation.scaling(0.5, 0.5, 0.5)
    s2 = Sphere.sphere() |> Map.put(:transform, t)
    w = world() |> Map.put(:light, light) |> add_object(s1) |> add_object(s2)

    %{world: w, light: light, s1: s1, s2: s2}
  end

  test "Creating a world" do
    w = world()
    assert w.objects == []
    assert w.light == nil
  end

  test "The default world", %{world: w, light: light, s1: s1, s2: s2} do
    assert w.light == light
    assert s1 in w.objects
    assert s2 in w.objects
  end

  test "Intersect a world with a ray", %{world: w} do
    r = Ray.ray(point(0, 0, -5), vector(0, 0, 1))
    xs = intersect(w, r)

    assert length(xs) == 4
    assert Enum.at(xs, 0).t == 4
    assert Enum.at(xs, 1).t == 4.5
    assert Enum.at(xs, 2).t == 5.5
    assert Enum.at(xs, 3).t == 6
  end

  test "Shading an intersection", %{world: w, s1: shape} do
    r = Ray.ray(point(0, 0, -5), vector(0, 0, 1))
    i = Intersection.intersection(4, shape)
    comps = Intersection.prepare_computations(i, r)
    c = shade_hit(w, comps)
    assert approx_eq(c, color(0.38066, 0.47583, 0.2855))
  end

  test "Shading an intersection from the inside", %{world: w, s2: shape} do
    light = Light.point_light(point(0, 0.25, 0), color(1, 1, 1))
    w = Map.put(w, :light, light)
    r = Ray.ray(point(0, 0, 0), vector(0, 0, 1))
    i = Intersection.intersection(0.5, shape)
    comps = Intersection.prepare_computations(i, r)
    c = shade_hit(w, comps)
    assert approx_eq(c, color(0.90498, 0.90498, 0.90498))
  end

  test "The color when a ray misses", %{world: w} do
    r = Ray.ray(point(0, 0, -5), vector(0, 1, 0))
    c = color_at(w, r)
    assert approx_eq(c, color(0, 0, 0))
  end

  test "The color when a ray hits", %{world: w} do
    r = Ray.ray(point(0, 0, -5), vector(0, 0, 1))
    c = color_at(w, r)
    assert approx_eq(c, color(0.38066, 0.47583, 0.2855))
  end

  test "The color with an intersection behind the ray", %{world: w} do
    r = Ray.ray(point(0, 0, -5), vector(0, 0, 1))
    c = color_at(w, r)
    assert approx_eq(c, color(0.38066, 0.47583, 0.2855))
  end

  test "There is no shadow when nothing is collinear with point and light", %{world: w} do
    p = point(0, 10, 0)
    refute shadowed?(w, p)
  end

  test "The shadow when an object is between the point and the light", %{world: w} do
    p = point(10, -10, 10)
    assert shadowed?(w, p)
  end

  test "There is no shadow when an object is behind the light", %{world: w} do
    p = point(-20, 20, -20)
    refute shadowed?(w, p)
  end

  test "There is no shadow when an object is behind the point", %{world: w} do
    p = point(-2, 2, -2)
    refute shadowed?(w, p)
  end

  test "shade_hit() is given an intersection in shadow" do
    s1 = Sphere.sphere()
    s2 = Sphere.sphere() |> Map.put(:transform, Transformation.translation(0, 0, 10))
    light = Light.point_light(point(0, 0, -10), color(1, 1, 1))
    w = world() |> Map.put(:light, light) |> add_object(s1) |> add_object(s2)
    r = Ray.ray(point(0, 0, 5), vector(0, 0, 1))
    i = Intersection.intersection(4, s2)
    comps = Intersection.prepare_computations(i, r)
    c = shade_hit(w, comps)
    assert approx_eq(c, color(0.1, 0.1, 0.1))
  end
end
