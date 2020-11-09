defmodule TestPattern do
  alias RayTracer.Matrix

  defstruct transform: Matrix.identity(4)

  def test_pattern(), do: %TestPattern{}
end

defimpl RayTracer.Patternable, for: TestPattern do
  def pattern_at(_, point), do: point
end
