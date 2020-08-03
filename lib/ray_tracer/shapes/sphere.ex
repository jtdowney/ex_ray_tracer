defmodule RayTracer.Shapes.Sphere do
  @moduledoc """
  A sphere object.
  """

  import RayTracer.Core
  alias RayTracer.{Material, Matrix}

  defstruct transform: Matrix.identity(4), material: Material.material()

  def sphere() do
    %RayTracer.Shapes.Sphere{}
  end
end

defimpl RayTracer.Renderable, for: RayTracer.Shapes.Sphere do
  import RayTracer.Core
  alias RayTracer.{Intersection, Vector}

  def local_intersect(object, local_ray) do
    sphere_to_ray = sub(local_ray.origin, point(0, 0, 0))
    a = Vector.dot(local_ray.direction, local_ray.direction)
    b = 2 * Vector.dot(local_ray.direction, sphere_to_ray)
    c = Vector.dot(sphere_to_ray, sphere_to_ray) - 1
    discriminant = :math.pow(b, 2) - 4 * a * c

    if discriminant < 0 do
      []
    else
      [(-b - :math.sqrt(discriminant)) / (2 * a), (-b + :math.sqrt(discriminant)) / (2 * a)]
      |> Enum.map(&Intersection.intersection(&1, object))
    end
  end

  def local_normal_at(_object, local_point) do
    sub(local_point, point(0, 0, 0)) |> Vector.normalize()
  end
end
