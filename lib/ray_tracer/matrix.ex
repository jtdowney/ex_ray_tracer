defmodule RayTracer.Matrix do
  def matrix(elements) do
    %{size: tuple_size(elements), elements: elements}
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

  def values(%{size: size} = m) do
    top = size - 1
    for i <- 0..top, j <- 0..top, do: at(m, i, j)
  end

  def approx_eq(%{size: size1}, %{size: size2}) when size1 != size2, do: false

  def approx_eq(m1, m2) do
    e = RayTracer.epsilon()

    Enum.zip(values(m1), values(m2))
    |> Enum.all?(fn {a, b} ->
      abs(a - b) <= e
    end)
  end

  def at(%{elements: elements}, i, j) do
    elements |> elem(i) |> elem(j)
  end

  def row(%{elements: elements}, i) do
    elements |> elem(i) |> Tuple.to_list()
  end

  def column(%{elements: elements}, j) do
    elements |> Tuple.to_list() |> Enum.map(&elem(&1, j))
  end

  def mul(%{size: size} = a, b) when is_map(b) do
    top = size - 1

    for i <- 0..top do
      for j <- 0..top do
        for(n <- 0..top, do: at(a, i, n) * at(b, n, j)) |> Enum.sum()
      end
      |> List.to_tuple()
    end
    |> List.to_tuple()
    |> matrix()
  end

  def mul(%{size: size} = a, b) when is_tuple(b) do
    top = size - 1

    for i <- 0..top do
      for(n <- 0..top, do: at(a, i, n) * elem(b, n)) |> Enum.sum()
    end
    |> List.to_tuple()
  end

  def transpose(%{size: size} = m) do
    top = size - 1

    for i <- 0..top do
      for j <- 0..top do
        at(m, j, i)
      end
      |> List.to_tuple()
    end
    |> List.to_tuple()
    |> matrix()
  end

  def determinant(%{size: 2, elements: {{a, b}, {c, d}}}) do
    a * d - b * c
  end

  def determinant(%{size: size} = m) do
    for j <- 0..(size - 1) do
      at(m, 0, j) * cofactor(m, 0, j)
    end
    |> Enum.sum()
  end

  def submatrix(%{size: size} = m, a, b) do
    top = size - 1

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

  def inverse(%{size: size} = m) do
    if invertible?(m) do
      determinant = determinant(m)
      top = size - 1

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
