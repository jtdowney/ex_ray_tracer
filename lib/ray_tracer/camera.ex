defmodule RayTracer.Camera do
  @moduledoc """
  Camera for a `RayTracer.World` that can render a `RayTracer.Canvas`.
  """

  import RayTracer.Core
  alias RayTracer.{Canvas, Matrix, Ray, Vector, World}

  defstruct [
    :hsize,
    :vsize,
    :field_of_view,
    :pixel_size,
    :half_width,
    :half_height,
    transform: Matrix.identity(4)
  ]

  def camera(hsize, vsize, field_of_view) do
    half_view = :math.tan(field_of_view / 2)
    aspect = hsize / vsize

    {half_width, half_height} =
      if aspect >= 1 do
        half_width = half_view
        half_height = half_view / aspect
        {half_width, half_height}
      else
        half_width = half_view * aspect
        half_height = half_view
        {half_width, half_height}
      end

    pixel_size = half_width * 2 / hsize

    %RayTracer.Camera{
      hsize: hsize,
      vsize: vsize,
      field_of_view: field_of_view,
      pixel_size: pixel_size,
      half_width: half_width,
      half_height: half_height
    }
  end

  def ray_for_pixel(camera, px, py) do
    xoffset = (px + 0.5) * camera.pixel_size
    yoffset = (py + 0.5) * camera.pixel_size

    world_x = camera.half_width - xoffset
    world_y = camera.half_height - yoffset

    transform_inv = camera.transform |> Matrix.inverse()
    pixel = transform_inv |> Matrix.mul(point(world_x, world_y, -1))
    origin = transform_inv |> Matrix.mul(point(0, 0, 0))
    direction = sub(pixel, origin) |> Vector.normalize()

    Ray.ray(origin, direction)
  end

  def render(camera, world) do
    canvas = Canvas.canvas(camera.hsize, camera.vsize)

    for(x <- 0..(camera.hsize - 1), y <- 0..(camera.vsize - 1), do: {x, y})
    |> Task.async_stream(fn {x, y} ->
      ray = ray_for_pixel(camera, x, y)
      color = World.color_at(world, ray)
      {x, y, color}
    end)
    |> Enum.reduce(canvas, fn {:ok, {x, y, color}}, canvas ->
      Canvas.write_pixel(canvas, x, y, color)
    end)
  end
end
