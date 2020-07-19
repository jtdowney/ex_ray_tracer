defmodule RayTracer.World do
  defstruct [:light, objects: []]

  import RayTracer.Core
  alias RayTracer.{Intersection, Material, Sphere}

  def world() do
    %RayTracer.World{}
  end

  def add_object(%RayTracer.World{objects: objects} = world, object) do
    Map.put(world, :objects, [object | objects])
  end

  def intersect(%RayTracer.World{objects: objects}, r) do
    Enum.flat_map(objects, &Sphere.intersect(&1, r)) |> Intersection.intersections()
  end

  def shade_hit(%RayTracer.World{light: light}, comps) do
    Material.lighting(comps.object.material, light, comps.point, comps.eyev, comps.normalv)
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
end
