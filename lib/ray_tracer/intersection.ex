defmodule RayTracer.Intersection do
  def intersection(t, object) do
    %{t: t, object: object}
  end

  def intersections(intersections) do
    intersections |> Enum.sort_by(& &1.t)
  end

  def hit(intersections) do
    intersections |> Enum.find(&(&1.t >= 0))
  end
end
