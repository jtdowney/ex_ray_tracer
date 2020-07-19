defmodule RayTracer.Sphere do
  import RayTracer.Core
  alias RayTracer.{Intersection, Material, Matrix, Ray, Vector}

  def sphere() do
    %{shape: :sphere, transform: Matrix.identity(4), material: Material.material()}
  end

  def intersect(%{shape: :sphere, transform: transform} = object, ray) do
    ray = Ray.transform(ray, Matrix.inverse(transform))
    sphere_to_ray = sub(ray.origin, point(0, 0, 0))
    a = Vector.dot(ray.direction, ray.direction)
    b = 2 * Vector.dot(ray.direction, sphere_to_ray)
    c = Vector.dot(sphere_to_ray, sphere_to_ray) - 1
    discriminant = :math.pow(b, 2) - 4 * a * c

    if discriminant < 0 do
      []
    else
      [(-b - :math.sqrt(discriminant)) / (2 * a), (-b + :math.sqrt(discriminant)) / (2 * a)]
      |> Enum.map(&Intersection.intersection(&1, object))
    end
  end

  def normal_at(%{transform: transform}, world_point) do
    transform_inv = transform |> Matrix.inverse()
    object_point = transform_inv |> Matrix.mul(world_point)
    object_normal = sub(object_point, point(0, 0, 0)) |> Vector.normalize()

    transform_inv
    |> Matrix.transpose()
    |> Matrix.mul(object_normal)
    |> put_elem(3, 0)
    |> Vector.normalize()
  end
end
