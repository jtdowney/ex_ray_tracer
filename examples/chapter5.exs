alias RayTracer.{Canvas, Intersection, Ray, Sphere, Vector}
import RayTracer.Tuple

ray_origin = point(0, 0, -5)
wall_z = 10
wall_size = 7
half_wall_size = wall_size / 2
canvas_size = 100
pixel_size = wall_size / canvas_size
color = color(1, 0, 0)

shape = Sphere.sphere()
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
  {x, y, hit}
end
|> Stream.filter(fn {_, _, hit} -> hit end)
|> Enum.reduce(canvas, fn {x, y, _}, canvas ->
  Canvas.write_pixel(canvas, x, y, color)
end)
|> Canvas.to_ppm()
|> IO.puts()
