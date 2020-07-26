defmodule RayTracer.Matrix do
  @moduledoc """
  Representation of a square matrix and operations on those matricies.
  """

  defstruct [:size, :elements]

  def matrix(elements) do
    %RayTracer.Matrix{size: tuple_size(elements), elements: elements}
  end

  def identity(size) do
    top = size - 1

    for i <- 0..top do
      for j <- 0..top do
        if i == j, do: 1, else: 0
      end
      |> List.to_tuple()
    end
    |> List.to_tuple()
    |> matrix
  end

  def values(m) do
    top = m.size - 1
    for i <- 0..top, j <- 0..top, do: at(m, i, j)
  end

  def at(m, i, j) do
    m.elements |> elem(i) |> elem(j)
  end

  def mul(a, b) when is_map(b) do
    top = a.size - 1

    for i <- 0..top do
      for j <- 0..top do
        for(n <- 0..top, do: at(a, i, n) * at(b, n, j)) |> Enum.sum()
      end
      |> List.to_tuple()
    end
    |> List.to_tuple()
    |> matrix()
  end

  def mul(a, b) when is_tuple(b) do
    top = a.size - 1

    for i <- 0..top do
      for(n <- 0..top, do: at(a, i, n) * elem(b, n)) |> Enum.sum()
    end
    |> List.to_tuple()
  end

  def transpose(m) do
    top = m.size - 1

    for i <- 0..top do
      for j <- 0..top do
        at(m, j, i)
      end
      |> List.to_tuple()
    end
    |> List.to_tuple()
    |> matrix()
  end

  def determinant(%RayTracer.Matrix{size: 2, elements: {{a, b}, {c, d}}}) do
    a * d - b * c
  end

  def determinant(m) do
    for j <- 0..(m.size - 1) do
      at(m, 0, j) * cofactor(m, 0, j)
    end
    |> Enum.sum()
  end

  def submatrix(m, a, b) do
    top = m.size - 1

    for i <- 0..top, i != a do
      for j <- 0..top, j != b do
        at(m, i, j)
      end
      |> List.to_tuple()
    end
    |> List.to_tuple()
    |> matrix()
  end

  def minor(m, i, j) do
    submatrix(m, i, j) |> determinant()
  end

  def cofactor(m, i, j) do
    minor = minor(m, i, j)

    if rem(i + j, 2) == 0, do: minor, else: -minor
  end

  def invertible?(m) do
    determinant(m) != 0
  end

  def inverse(m) do
    determinant = determinant(m)

    if determinant != 0 do
      top = m.size - 1

      for i <- 0..top do
        for j <- 0..top do
          cofactor(m, i, j) / determinant
        end
        |> List.to_tuple()
      end
      |> List.to_tuple()
      |> matrix()
      |> transpose()
    else
      {:error, :not_invertable}
    end
  end
end
