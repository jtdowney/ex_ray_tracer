import RayTracer.{Transformation, Tuple}
alias RayTracer.{Canvas, Matrix}

color = color(1, 1, 1)
transform = rotation_z(:math.pi() / 6)

size = 500
canvas = Canvas.canvas(size, size)
p = point(0, size / 2 - 30, 0)

1..12
|> Enum.scan(p, fn _, p -> Matrix.mul(transform, p) end)
|> Enum.reduce(canvas, fn {x, y, _, _}, canvas ->
  i = round(x + size / 2)
  j = round(y + size / 2)

  Canvas.write_pixel(canvas, i, j, color)
end)
|> Canvas.to_ppm()
|> IO.puts()
