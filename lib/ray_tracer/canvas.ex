defmodule RayTracer.Canvas do
  import RayTracer.Core

  @default_pixel color(0, 0, 0)

  defstruct [:width, :height, pixels: %{}]

  def canvas(width, height) do
    %RayTracer.Canvas{width: width, height: height}
  end

  def write_pixel(canvas, x, y, color) do
    pixels = Map.put(canvas.pixels, {x, y}, color)
    %{canvas | pixels: pixels}
  end

  def pixel_at(canvas, x, y) do
    canvas.pixels |> Map.get({x, y}, @default_pixel)
  end

  def to_ppm(canvas) do
    header = [
      "P3",
      "#{canvas.width} #{canvas.height}",
      "255"
    ]

    data =
      0..(canvas.height - 1)
      |> Stream.flat_map(&build_row(canvas, &1))
      |> Enum.to_list()

    ppm = (header ++ data) |> Enum.join("\n")
    ppm <> "\n"
  end

  defp build_row(canvas, y) do
    0..(canvas.width - 1)
    |> Stream.flat_map(&build_pixel(canvas, &1, y))
    |> Stream.chunk_every(17)
    |> Enum.map(&Enum.join(&1, " "))
  end

  defp build_pixel(canvas, x, y) do
    {r, g, b, _} = pixel_at(canvas, x, y)
    [r, g, b] |> Enum.map(&clamp_color/1)
  end

  defp clamp_color(c) do
    (c * 255) |> ceil() |> min(255) |> max(0)
  end
end
