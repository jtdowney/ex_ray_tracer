defprotocol RayTracer.Renderable do
  def local_intersect(object, ray)
  def local_normal_at(object, world_point)
end

defmodule RayTracer.Shape do
  alias RayTracer.{Matrix, Ray, Renderable, Vector}

  def intersect(object, ray) do
    transform_inv = Map.get(object, :transform) |> Matrix.inverse()
    local_ray = Ray.transform(ray, transform_inv)
    Renderable.local_intersect(object, local_ray)
  end

  def normal_at(object, point) do
    transform_inv = Map.get(object, :transform) |> Matrix.inverse()
    local_point = Matrix.mul(transform_inv, point)
    local_normal = Renderable.local_normal_at(object, local_point)

    transform_inv
    |> Matrix.transpose()
    |> Matrix.mul(local_normal)
    |> put_elem(3, 0)
    |> Vector.normalize()
  end
end
