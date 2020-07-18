import RayTracer.Core
alias RayTracer.{Canvas, Intersection, Light, Material, Ray, Sphere, Vector}

ray_origin = point(0, 0, -5)
wall_z = 10
wall_size = 7
half_wall_size = wall_size / 2
canvas_size = 100
pixel_size = wall_size / canvas_size

light_position = point(-10, 10, -10)
light_color = color(1, 1, 1)
light = Light.point_light(light_position, light_color)

material = Material.material() |> Map.put(:color, color(1, 0.2, 1))
shape = Sphere.sphere() |> Map.put(:material, material)

canvas = Canvas.canvas(canvas_size, canvas_size)

for x <- 0..(canvas_size - 1),
    y <- 0..(canvas_size - 1) do
  world_x = -half_wall_size + pixel_size * x
  world_y = half_wall_size - pixel_size * y
  position = point(world_x, world_y, wall_z)
  direction = sub(position, ray_origin) |> Vector.normalize()
  ray = Ray.ray(ray_origin, direction)
  xs = Sphere.intersect(shape, ray)
  hit = Intersection.hit(xs)

  if hit do
    point = Ray.position(ray, hit.t)
    normal = Sphere.normal_at(hit.object, point)
    eye = ray.direction |> negate()

    color = Material.lighting(hit.object.material, light, point, eye, normal)
    {x, y, color}
  end
end
|> Stream.filter(& &1)
|> Enum.reduce(canvas, fn {x, y, color}, canvas ->
  Canvas.write_pixel(canvas, x, y, color)
end)
|> Canvas.to_ppm()
|> IO.puts()
