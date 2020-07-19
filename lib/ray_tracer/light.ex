defmodule RayTracer.Light do
  defmodule PointLight do
    defstruct [:position, :intensity]
  end

  def point_light(position, intensity) do
    %PointLight{position: position, intensity: intensity}
  end
end
