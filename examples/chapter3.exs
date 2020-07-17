import RayTracer.Matrix
import RayTracer.Tuple

# What happens when you invert the identity matrix?
identity(4) |> inverse |> IO.inspect()

# What do you get when you multiply a matrix by its inverse?
m = matrix({{1, 5, 3}, {4, 5, 6}, {7, 8, 9}})
m_inv = inverse(m)
mul(m, m_inv) |> IO.inspect()

# Is there any difference between the inverse of the transpose of a matrix, and the transpose of the inverse?
m = matrix({{1, 5, 3}, {4, 5, 6}, {7, 8, 9}})
m |> transpose |> inverse |> IO.inspect()
m |> inverse |> transpose |> IO.inspect()

# try changing any single element of the identity matrix to a different number, and then multiplying it by a tuple
t = tuple(1, 2, 3, 4)
mul(identity(4), t) |> IO.inspect()

t = tuple(1, 2, 3, 4)
i = matrix({{1, 0, 0, 1}, {0, 1, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}})
mul(i, t) |> IO.inspect()
