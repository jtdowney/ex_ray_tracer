import RayTracer.Core
alias RayTracer.{Camera, Canvas, Light, Material, Transformation, World}
alias RayTracer.Shapes.{Plane, Sphere}

m = Material.material() |> Map.put(:color, color(1, 0.9, 0.9)) |> Map.put(:specular, 0)
floor = Plane.plane() |> Map.put(:material, m)

t = Transformation.translation(-0.5, 1, 0.5)

m =
  Material.material()
  |> Map.put(:color, color(0.1, 1, 0.5))
  |> Map.put(:diffuse, 0.7)
  |> Map.put(:specular, 0.3)

middle = Sphere.sphere() |> Map.put(:transform, t) |> Map.put(:material, m)

t = Transformation.translation(1.5, 0.5, -0.5) |> Transformation.scaling(0.5, 0.5, 0.5)

m =
  Material.material()
  |> Map.put(:color, color(0.5, 1, 0.1))
  |> Map.put(:diffuse, 0.7)
  |> Map.put(:specular, 0.3)

right = Sphere.sphere() |> Map.put(:transform, t) |> Map.put(:material, m)

t = Transformation.translation(-1.5, 0.33, -0.75) |> Transformation.scaling(0.33, 0.33, 0.33)

m =
  Material.material()
  |> Map.put(:color, color(1, 0.8, 0.1))
  |> Map.put(:diffuse, 0.7)
  |> Map.put(:specular, 0.3)

left = Sphere.sphere() |> Map.put(:transform, t) |> Map.put(:material, m)

light = Light.point_light(point(-10, 10, -10), color(1, 1, 1))

world =
  World.world()
  |> Map.put(:light, light)
  |> World.add_object(floor)
  |> World.add_object(left)
  |> World.add_object(right)
  |> World.add_object(middle)

t = Transformation.view_transform(point(0, 1.5, -5), point(0, 1, 0), vector(0, 1, 0))

Camera.camera(1000, 500, :math.pi() / 3)
|> Map.put(:transform, t)
|> Camera.render(world)
|> Canvas.to_ppm()
|> IO.puts()
