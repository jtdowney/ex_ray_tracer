defmodule RayTracer.CanvasTest do
  use ExUnit.Case

  import RayTracer.{Canvas, Core}

  test "Creating a canvas" do
    c = canvas(10, 20)
    assert c.width == 10
    assert c.height == 20
    assert c.pixels == %{}
  end

  test "Writing pixels to a canvas" do
    c = canvas(10, 20)
    red = color(1, 0, 0)
    c = write_pixel(c, 2, 3, red)
    assert pixel_at(c, 2, 3) == red
  end

  test "Constructing the PPM header" do
    ppm =
      canvas(5, 3)
      |> to_ppm()
      |> String.split("\n")
      |> Enum.take(3)

    assert ppm == [
             "P3",
             "5 3",
             "255"
           ]
  end

  test "Constructing the PPM pixel data" do
    c1 = color(1.5, 0, 0)
    c2 = color(0, 0.5, 0)
    c3 = color(-0.5, 0, 1)

    ppm =
      canvas(5, 3)
      |> write_pixel(0, 0, c1)
      |> write_pixel(2, 1, c2)
      |> write_pixel(4, 2, c3)
      |> to_ppm()
      |> String.split("\n")
      |> Stream.drop(3)
      |> Enum.take(3)

    assert ppm == [
             "255 0 0 0 0 0 0 0 0 0 0 0 0 0 0",
             "0 0 0 0 0 0 0 128 0 0 0 0 0 0 0",
             "0 0 0 0 0 0 0 0 0 0 0 0 0 0 255"
           ]
  end

  test "Splitting long lines in PPM files" do
    color = color(1, 0.8, 0.6)

    ppm =
      for(
        x <- 0..9,
        y <- 0..1,
        do: {x, y}
      )
      |> Enum.reduce(canvas(10, 2), fn {x, y}, c -> write_pixel(c, x, y, color) end)
      |> to_ppm()
      |> String.split("\n")
      |> Enum.drop(3)
      |> Enum.take(4)

    assert ppm == [
             "255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204",
             "153 255 204 153 255 204 153 255 204 153 255 204 153",
             "255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204",
             "153 255 204 153 255 204 153 255 204 153 255 204 153"
           ]
  end

  test "PM files are terminated by a newline character" do
    ppm = canvas(5, 3) |> to_ppm()
    assert String.last(ppm) == "\n"
  end
end
