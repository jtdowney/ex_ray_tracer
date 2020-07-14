import RayTracer.Tuple
import RayTracer.Vector

defmodule Chapter1 do
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

p = Chapter1.projectile(point(0, 1, 0), vector(1, 1, 0) |> normalize())
e = Chapter1.environment(vector(0, -0.1, 0), vector(-0.01, 0, 0))

Stream.iterate(p, fn prev -> Chapter1.tick(e, prev) end)
|> Enum.take_while(fn %{position: {_, y, _, _}} -> y > 0 end)
|> IO.inspect()
