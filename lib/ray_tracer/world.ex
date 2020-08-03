defmodule RayTracer.World do
  @moduledoc """
  Represents a world with objects, a light, that can be rendered with a `RayTracer.Camera`.
  """

  defstruct [:light, objects: []]

  import RayTracer.Core
  alias RayTracer.{Intersection, Material, Ray, Shape, Vector}

  def world() do
    %RayTracer.World{}
  end

  def add_object(%RayTracer.World{objects: objects} = world, object) do
    Map.put(world, :objects, [object | objects])
  end

  def intersect(%RayTracer.World{objects: objects}, r) do
    Enum.flat_map(objects, &Shape.intersect(&1, r)) |> Intersection.intersections()
  end

  def shade_hit(%RayTracer.World{light: light} = world, comps) do
    shadowed = shadowed?(world, comps.over_point)

    Material.lighting(
      comps.object.material,
      light,
      comps.point,
      comps.eyev,
      comps.normalv,
      shadowed
    )
  end

  def color_at(world, ray) do
    hit = intersect(world, ray) |> Intersection.hit()

    if hit do
      comps = Intersection.prepare_computations(hit, ray)
      shade_hit(world, comps)
    else
      color(0, 0, 0)
    end
  end

  def shadowed?(world, point) do
    v = sub(world.light.position, point)
    distance = Vector.magnitude(v)
    direction = Vector.normalize(v)

    r = Ray.ray(point, direction)
    xs = intersect(world, r)
    hit = Intersection.hit(xs)

    hit && hit.t < distance
  end
end
