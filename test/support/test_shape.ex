defmodule TestShape do
  alias RayTracer.{Material, Matrix}

  defstruct [:saved_ray, transform: Matrix.identity(4), material: Material.material()]

  def test_shape() do
    %TestShape{}
  end
end

defimpl RayTracer.Renderable, for: TestShape do
  def local_intersect(object, ray) do
    object = Map.put(object, :saved_ray, ray)
    [object]
  end

  def local_normal_at(_object, point), do: point |> put_elem(3, 0)
end
