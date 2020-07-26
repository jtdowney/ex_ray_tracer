defmodule RayTracer.Light do
  @moduledoc """
  Light for a `RayTracer.World`.
  """

  defmodule PointLight do
    @moduledoc """
    A light that comes from a single point.
    """

    defstruct [:position, :intensity]
  end

  def point_light(position, intensity) do
    %PointLight{position: position, intensity: intensity}
  end
end
