defmodule RayTracer.Intersection do
  defstruct [:t, :object]

  import RayTracer.Core
  alias RayTracer.{Ray, Sphere, Vector}

  def intersection(t, object) do
    %RayTracer.Intersection{t: t, object: object}
  end

  def intersections(intersections) do
    intersections |> Enum.sort_by(& &1.t)
  end

  def hit(intersections) do
    intersections |> Enum.find(&(&1.t >= 0))
  end

  def prepare_computations(%RayTracer.Intersection{t: t, object: object}, ray) do
    point = Ray.position(ray, t)
    eyev = ray.direction |> negate
    normalv = Sphere.normal_at(object, point)

    {inside, normalv} =
      if Vector.dot(normalv, eyev) < 0 do
        {true, normalv |> negate}
      else
        {false, normalv}
      end

    over_point = add(point, scalar_mul(normalv, epsilon()))

    %{
      t: t,
      object: object,
      point: point,
      eyev: eyev,
      normalv: normalv,
      inside: inside,
      over_point: over_point
    }
  end
end
