import RayTracer.Tuple
import RayTracer.Vector

defmodule Chapter1 do
  def tick(%{gravity: gravity, wind: wind}, %{position: position, velocity: velocity}) do
    position = add(position, velocity)
    velocity = velocity |> add(gravity) |> add(wind)
    %{position: position, velocity: velocity}
  end
end

p = %{position: point(0, 1, 0), velocity: vector(1, 1, 0) |> normalize()}
e = %{gravity: vector(0, -0.1, 0), wind: vector(-0.01, 0, 0)}

Stream.iterate(p, fn prev -> Chapter1.tick(e, prev) end)
|> Enum.take_while(fn p -> p.position.y > 0 end)
|> IO.inspect()
