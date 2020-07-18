defmodule RayTracer.Sphere do
  import RayTracer.{Intersection, Matrix, Ray, Tuple, Vector}

  def sphere() do
    %{shape: :sphere, transform: identity(4)}
  end

  def intersect(%{shape: :sphere, transform: transform} = object, ray) do
    ray = transform(ray, inverse(transform))
    sphere_to_ray = sub(ray.origin, point(0, 0, 0))
    a = dot(ray.direction, ray.direction)
    b = 2 * dot(ray.direction, sphere_to_ray)
    c = dot(sphere_to_ray, sphere_to_ray) - 1
    discriminant = :math.pow(b, 2) - 4 * a * c

    if discriminant < 0 do
      intersections([])
    else
      [(-b - :math.sqrt(discriminant)) / (2 * a), (-b + :math.sqrt(discriminant)) / (2 * a)]
      |> Enum.map(&intersection(&1, object))
      |> intersections
    end
  end

  def put_transform(sphere, transform) do
    Map.put(sphere, :transform, transform)
  end
end
