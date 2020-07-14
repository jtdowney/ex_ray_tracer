defmodule RayTracer.Canvas do
  @type t :: %{width: integer, height: integer, pixels: %{}}

  @default_pixel RayTracer.Tuple.color(0, 0, 0)

  @spec canvas(integer, integer) :: t
  def canvas(width, height) do
    %{width: width, height: height, pixels: %{}}
  end

  @spec write_pixel(t, integer, integer, RayTracer.Tuple.t()) :: t
  def write_pixel(%{pixels: pixels} = canvas, x, y, color) do
    pixels = Map.put(pixels, {x, y}, color)
    %{canvas | pixels: pixels}
  end

  @spec pixel_at(t, integer, integer) :: RayTracer.Tuple.t()
  def pixel_at(canvas, x, y) do
    canvas.pixels |> Map.get({x, y}, @default_pixel)
  end

  @spec to_ppm(t) :: String.t()
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

  @spec build_row(t, integer) :: [String.t()]
  defp build_row(%{width: width} = canvas, y) do
    0..(width - 1)
    |> Stream.flat_map(&build_pixel(canvas, &1, y))
    |> Stream.chunk_every(17)
    |> Enum.map(&Enum.join(&1, " "))
  end

  @spec build_pixel(t, integer, integer) :: [integer]
  defp build_pixel(canvas, x, y) do
    {r, g, b, _} = pixel_at(canvas, x, y)
    [r, g, b] |> Enum.map(&clamp_color/1)
  end

  @spec clamp_color(float) :: integer
  defp clamp_color(c) do
    (c * 255) |> ceil() |> min(255) |> max(0)
  end
end
