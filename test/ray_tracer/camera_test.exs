defmodule RayTracer.CameraTest do
  use ExUnit.Case

  import RayTracer.{Core, Camera}
  alias RayTracer.{Canvas, Light, Material, Matrix, Sphere, Transformation, World}

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
    w = World.world() |> Map.put(:light, light) |> World.add_object(s1) |> World.add_object(s2)

    %{world: w, light: light, s1: s1, s2: s2}
  end

  test "Constructing a camera" do
    hsize = 160
    vsize = 120
    field_of_view = :math.pi() / 2
    c = camera(hsize, vsize, field_of_view)
    assert c.hsize == hsize
    assert c.vsize == vsize
    assert c.field_of_view == field_of_view
    assert c.transform == Matrix.identity(4)
  end

  test "The pixel size for a horizontal canvas" do
    c = camera(200, 125, :math.pi() / 2)
    assert approx_eq(c.pixel_size, 0.01)
  end

  test "The pixel size for a vertical canvas" do
    c = camera(125, 200, :math.pi() / 2)
    assert approx_eq(c.pixel_size, 0.01)
  end

  test "Constructing a ray through the center of the canvas" do
    c = camera(201, 101, :math.pi() / 2)
    r = ray_for_pixel(c, 100, 50)
    assert approx_eq(r.origin, point(0, 0, 0))
    assert approx_eq(r.direction, vector(0, 0, -1))
  end

  test "Constructing a ray through a corner of the canvas" do
    c = camera(201, 101, :math.pi() / 2)
    r = ray_for_pixel(c, 0, 0)
    assert approx_eq(r.origin, point(0, 0, 0))
    assert approx_eq(r.direction, vector(0.66519, 0.33259, -0.66851))
  end

  test "Constructing a ray when the camera is transformed" do
    t = Transformation.rotation_y(:math.pi() / 4) |> Transformation.translation(0, -2, 5)
    c = camera(201, 101, :math.pi() / 2) |> Map.put(:transform, t)
    r = ray_for_pixel(c, 100, 50)
    assert approx_eq(r.origin, point(0, 2, -5))
    assert approx_eq(r.direction, vector(:math.sqrt(2) / 2, 0, -:math.sqrt(2) / 2))
  end

  test "Rendering a world with a camera", %{world: w} do
    from = point(0, 0, -5)
    to = point(0, 0, 0)
    up = vector(0, 1, 0)
    t = Transformation.view_transform(from, to, up)
    c = camera(11, 11, :math.pi() / 2) |> Map.put(:transform, t)
    image = render(c, w)
    pixel = Canvas.pixel_at(image, 5, 5)
    assert approx_eq(pixel, color(0.38066, 0.47583, 0.2855))
  end
end
