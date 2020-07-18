defmodule RayTracer.Canvas do
  import RayTracer.Core

  @default_pixel color(0, 0, 0)

  def canvas(width, height) do
    %{width: width, height: height, pixels: %{}}
  end

  def write_pixel(%{pixels: pixels} = canvas, x, y, color) do
    pixels = Map.put(pixels, {x, y}, color)
    %{canvas | pixels: pixels}
  end

  def pixel_at(canvas, x, y) do
    canvas.pixels |> Map.get({x, y}, @default_pixel)
  end

  def to_ppm(%{width: width, height: height} = canvas) do
    header = [
      "P3",
      "#{width} #{height}",
      "255"
    ]

    data =
      0..(height - 1)
      |> Stream.flat_map(&build_row(canvas, &1))
      |> Enum.to_list()

    ppm = (header ++ data) |> Enum.join("\n")
    ppm <> "\n"
  end

  defp build_row(%{width: width} = canvas, y) do
    0..(width - 1)
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
