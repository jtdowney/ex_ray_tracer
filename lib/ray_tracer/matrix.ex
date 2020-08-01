defmodule RayTracer.Matrix do
  @moduledoc """
  Representation of a square matrix and operations on those matricies.
  """

  use Memoize

  def matrix(elements) do
    elements
    |> Tuple.to_list()
    |> Enum.flat_map(&Tuple.to_list(&1))
    |> RayTracer.Matrix.Native.from_list()
  end

  def identity(size) do
    top = size - 1

    for i <- 0..top do
      for j <- 0..top do
        if i == j, do: 1, else: 0
      end
    end
    |> List.flatten()
    |> RayTracer.Matrix.Native.from_list()
  end

  defmemo(inverse(m), do: Native.inverse(m))

  def invertible?(m), do: determinant(m) != 0

  defdelegate at(m, i, j), to: RayTracer.Matrix.Native
  defdelegate approx_eq(a, b), to: RayTracer.Matrix.Native
  defdelegate cofactor(m, i, j), to: RayTracer.Matrix.Native
  defdelegate determinant(m), to: RayTracer.Matrix.Native
  defdelegate minor(m, i, j), to: RayTracer.Matrix.Native
  defdelegate mul(a, b), to: RayTracer.Matrix.Native
  defdelegate submatrix(m, i, j), to: RayTracer.Matrix.Native
  defdelegate transpose(m), to: RayTracer.Matrix.Native
  defdelegate values(m), to: RayTracer.Matrix.Native

  defmodule Native do
    use Rustler, otp_app: :ray_tracer, crate: "ray_tracer"

    defstruct [:data]

    def from_list(_xs), do: error()

    def at(_m, _i, _j), do: error()
    def approx_eq(_a, _b), do: error()
    def cofactor(_m, _i, _j), do: error()
    def determinant(_m), do: error()
    def inverse(_m), do: error()
    def minor(_m, _i, _j), do: error()
    def mul(_a, _b), do: error()
    def submatrix(_m, _i, _j), do: error()
    def transpose(_m), do: error()
    def values(_m), do: error()

    defp error(), do: :erlang.nif_error(:nif_not_loaded)
  end
end
