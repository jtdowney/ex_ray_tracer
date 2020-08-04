defmodule RayTracer.Shapes.Plane do
  @moduledoc """
  A plane object.
  """

  alias RayTracer.{Material, Matrix}

  defstruct transform: Matrix.identity(4), material: Material.material()

  def plane() do
    %RayTracer.Shapes.Plane{}
  end
end

defimpl RayTracer.Renderable, for: RayTracer.Shapes.Plane do
  import RayTracer.Core
  alias RayTracer.Intersection

  def local_intersect(_object, %RayTracer.Ray{direction: {_, y, _, _}}) when abs(y) < epsilon() do
    []
  end

  def local_intersect(object, %RayTracer.Ray{
        direction: {_, direction_y, _, _},
        origin: {_, origin_y, _, _}
      }) do
    t = -origin_y / direction_y
    i = Intersection.intersection(t, object)

    [i]
  end

  def local_normal_at(_object, _world_point), do: vector(0, 1, 0)
end
