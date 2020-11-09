defprotocol RayTracer.Patternable do
  def pattern_at(pattern, point)
end

defmodule RayTracer.Pattern do
  alias RayTracer.{Matrix, Patternable}

  def pattern_at_shape(pattern, shape, world_point) do
    object_point = Matrix.inverse(shape.transform) |> Matrix.mul(world_point)
    pattern_point = Matrix.inverse(pattern.transform) |> Matrix.mul(object_point)

    Patternable.pattern_at(pattern, pattern_point)
  end
end

defmodule RayTracer.StripePattern do
  alias RayTracer.Matrix
  defstruct [:a, :b, transform: Matrix.identity(4)]

  def stripe_pattern(a, b), do: %__MODULE__{a: a, b: b}
end

defimpl RayTracer.Patternable, for: RayTracer.StripePattern do
  def pattern_at(pattern, {x, _, _, _}) when rem(floor(x), 2) == 0, do: pattern.a
  def pattern_at(pattern, _point), do: pattern.b
end
