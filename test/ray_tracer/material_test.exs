defmodule RayTracer.MaterialTest do
  use ExUnit.Case

  alias RayTracer.Light
  import RayTracer.{Core, Material}

  test "The default material" do
    m = material()
    assert m.color == color(1, 1, 1)
    assert m.ambient == 0.1
    assert m.diffuse == 0.9
    assert m.specular == 0.9
    assert m.shininess == 200
  end

  test "Lighting with the eye between the light and the surface" do
    m = material()
    position = point(0, 0, 0)
    eyev = vector(0, 0, -1)
    normalv = vector(0, 0, -1)
    light = Light.point_light(point(0, 0, -10), color(1, 1, 1))
    result = lighting(m, light, position, eyev, normalv)
    assert approx_eq(result, color(1.9, 1.9, 1.9))
  end

  test "Lighting with the eye between light and surface, eye offset 45°" do
    m = material()
    position = point(0, 0, 0)
    eyev = vector(0, :math.sqrt(2) / 2, -:math.sqrt(2) / 2)
    normalv = vector(0, 0, -1)
    light = Light.point_light(point(0, 0, -10), color(1, 1, 1))
    result = lighting(m, light, position, eyev, normalv)
    assert approx_eq(result, color(1.0, 1.0, 1.0))
  end

  test "Lighting with eye opposite surface, light offset 45°" do
    m = material()
    position = point(0, 0, 0)
    eyev = vector(0, 0, -1)
    normalv = vector(0, 0, -1)
    light = Light.point_light(point(0, 10, -10), color(1, 1, 1))
    result = lighting(m, light, position, eyev, normalv)
    assert approx_eq(result, color(0.7364, 0.7364, 0.7364))
  end

  test "Lighting with eye in the path of the reflection vector" do
    m = material()
    position = point(0, 0, 0)
    eyev = vector(0, -:math.sqrt(2) / 2, -:math.sqrt(2) / 2)
    normalv = vector(0, 0, -1)
    light = Light.point_light(point(0, 10, -10), color(1, 1, 1))
    result = lighting(m, light, position, eyev, normalv)
    assert approx_eq(result, color(1.6364, 1.6364, 1.6364))
  end

  test "Lighting with the light behind the surface" do
    m = material()
    position = point(0, 0, 0)
    eyev = vector(0, 0, -1)
    normalv = vector(0, 0, -1)
    light = Light.point_light(point(0, 0, 10), color(1, 1, 1))
    result = lighting(m, light, position, eyev, normalv)
    assert approx_eq(result, color(0.1, 0.1, 0.1))
  end

  test "Lighting with the surface in shadow" do
    m = material()
    position = point(0, 0, 0)
    eyev = vector(0, 0, -1)
    normalv = vector(0, 0, -1)
    light = Light.point_light(point(0, 0, -10), color(1, 1, 1))
    result = lighting(m, light, position, eyev, normalv, true)
    assert approx_eq(result, color(0.1, 0.1, 0.1))
  end
end
