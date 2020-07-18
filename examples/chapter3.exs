import RayTracer.Core
alias RayTracer.Matrix

# What happens when you invert the identity matrix?
Matrix.identity(4) |> Matrix.inverse() |> IO.inspect()

# What do you get when you multiply a matrix by its inverse?
m = Matrix.matrix({{1, 5, 3}, {4, 5, 6}, {7, 8, 9}})
m_inv = Matrix.inverse(m)
Matrix.mul(m, m_inv) |> IO.inspect()

# Is there any difference between the inverse of the transpose of a matrix, and the transpose of the inverse?
m = Matrix.matrix({{1, 5, 3}, {4, 5, 6}, {7, 8, 9}})
m |> Matrix.transpose() |> Matrix.inverse() |> IO.inspect()
m |> Matrix.inverse() |> Matrix.transpose() |> IO.inspect()

# try changing any single element of the identity matrix to a different number, and then multiplying it by a tuple
t = tuple(1, 2, 3, 4)
Matrix.mul(Matrix.identity(4), t) |> IO.inspect()

t = tuple(1, 2, 3, 4)
i = Matrix.matrix({{1, 0, 0, 1}, {0, 1, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}})
Matrix.mul(i, t) |> IO.inspect()
