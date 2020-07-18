import RayTracer.Core
alias RayTracer.{Canvas, Vector}

defmodule Chapter2 do
  def tick(%{gravity: gravity, wind: wind}, %{position: position, velocity: velocity}) do
    position = add(position, velocity)
    velocity = velocity |> add(gravity) |> add(wind)
    %{position: position, velocity: velocity}
  end

  def projectile(position, velocity) do
    %{position: position, velocity: velocity}
  end

  def environment(gravity, wind) do
    %{gravity: gravity, wind: wind}
  end
end

color = color(1, 0, 0)
start = point(0, 1, 0)
velocity = vector(1, 1.8, 0) |> Vector.normalize() |> scalar_mul(11.25)
p = Chapter2.projectile(start, velocity)

gravity = vector(0, -0.1, 0)
wind = vector(-0.01, 0, 0)
e = Chapter2.environment(gravity, wind)

c = %{height: height} = Canvas.canvas(900, 550)

Stream.iterate(p, fn prev -> Chapter2.tick(e, prev) end)
|> Stream.take_while(fn %{position: {_, y, _, _}} -> y > 0 end)
|> Stream.map(fn %{position: {x, y, _, _}} ->
  x = round(x)
  y = round(height - y)
  {x, y}
end)
|> Enum.reduce(c, fn {x, y}, c ->
  Canvas.write_pixel(c, x, y, color)
end)
|> Canvas.to_ppm()
|> IO.puts()
