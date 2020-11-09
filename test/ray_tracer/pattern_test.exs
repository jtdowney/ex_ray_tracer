defmodule RayTracer.PatternTest do
  use ExUnit.Case

  alias RayTracer.Shapes.Sphere
  alias RayTracer.{StripePattern, Transformation}
  import RayTracer.{Core, Pattern, Patternable}

  test "Creating a stripe pattern" do
    pattern = StripePattern.stripe_pattern(white(), black())
    assert pattern.a == white()
    assert pattern.b == black()
  end

  test "A stripe pattern is constant in y" do
    pattern = StripePattern.stripe_pattern(white(), black())
    assert pattern_at(pattern, point(0, 0, 0)) == white()
    assert pattern_at(pattern, point(0, 1, 0)) == white()
    assert pattern_at(pattern, point(0, 2, 0)) == white()
  end

  test "A stripe pattern is constant in z" do
    pattern = StripePattern.stripe_pattern(white(), black())
    assert pattern_at(pattern, point(0, 0, 0)) == white()
    assert pattern_at(pattern, point(0, 0, 1)) == white()
    assert pattern_at(pattern, point(0, 0, 2)) == white()
  end

  test "A stripe pattern alternates in x" do
    pattern = StripePattern.stripe_pattern(white(), black())
    assert pattern_at(pattern, point(0, 0, 0)) == white()
    assert pattern_at(pattern, point(0.9, 0, 0)) == white()
    assert pattern_at(pattern, point(1, 0, 0)) == black()
    assert pattern_at(pattern, point(-0.1, 0, 0)) == black()
    assert pattern_at(pattern, point(-1.1, 0, 0)) == white()
  end

  test "Stripes with an object transformation" do
    object = Sphere.sphere() |> Map.put(:transform, Transformation.scaling(2, 2, 2))
    pattern = StripePattern.stripe_pattern(white(), black())
    c = pattern_at_shape(pattern, object, point(1.5, 0, 0))
    assert c == white()
  end

  test "Stripes with a pattern transformation" do
    object = Sphere.sphere()

    pattern =
      StripePattern.stripe_pattern(white(), black())
      |> Map.put(:transform, Transformation.scaling(2, 2, 2))

    c = pattern_at_shape(pattern, object, point(1.5, 0, 0))
    assert c == white()
  end

  test "Stripes with an object and a pattern transformation" do
    object = Sphere.sphere() |> Map.put(:transform, Transformation.scaling(2, 2, 2))

    pattern =
      StripePattern.stripe_pattern(white(), black())
      |> Map.put(:transform, Transformation.translation(0.5, 0, 0))

    c = pattern_at_shape(pattern, object, point(2.5, 0, 0))
    assert c == white()
  end
end
