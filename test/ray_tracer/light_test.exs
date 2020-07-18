defmodule RayTracer.LightTest do
  use ExUnit.Case

  import RayTracer.{Core, Light}

  test "A point light has a position and intensity" do
    intensity = color(1, 1, 1)
    position = point(0, 0, 0)
    light = point_light(position, intensity)
    assert light.position == position
    assert light.intensity == intensity
  end
end
