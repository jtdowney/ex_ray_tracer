defmodule RayTracer.MatrixTest do
  use ExUnit.Case
  use ExUnitProperties

  import RayTracer.{Core, Matrix}

  def matrix_gen do
    gen all a <- {StreamData.float(), StreamData.float(), StreamData.float()},
            b <- {StreamData.float(), StreamData.float(), StreamData.float()},
            c <- {StreamData.float(), StreamData.float(), StreamData.float()} do
      matrix({a, b, c})
    end
  end

  test "Constructing and inspecting a 4x4 matrix" do
    m = matrix({{1, 2, 3, 4}, {5.5, 6.5, 7.5, 8.5}, {9, 10, 11, 12}, {13.5, 14.5, 15.5, 16.5}})
    assert m.size == 4
    assert at(m, 0, 0) == 1
    assert at(m, 0, 3) == 4
    assert at(m, 1, 0) == 5.5
    assert at(m, 1, 2) == 7.5
    assert at(m, 2, 2) == 11
    assert at(m, 3, 0) == 13.5
    assert at(m, 3, 2) == 15.5
  end

  test "A 2x2 matrix ought to be representable" do
    m = matrix({{-3, -5}, {1, -2}})
    assert m.size == 2
    assert at(m, 0, 0) == -3
    assert at(m, 0, 1) == -5
    assert at(m, 1, 0) == 1
    assert at(m, 1, 1) == -2
  end

  test "A 3x3 matrix ought to be representable" do
    m = matrix({{-3, 5, 0}, {1, -2, -7}, {0, 1, 1}})
    assert m.size == 3
    assert at(m, 0, 0) == -3
    assert at(m, 1, 1) == -2
    assert at(m, 2, 2) == 1
  end

  test "Matrix equality with identical matrices" do
    m1 = matrix({{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 8, 7, 6}, {5, 4, 3, 2}})
    m2 = matrix({{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 8, 7, 6}, {5, 4, 3, 2}})
    assert approx_eq(m1, m2)
  end

  test "Matrix equality with different matrices" do
    m1 = matrix({{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 8, 7, 6}, {5, 4, 3, 2}})
    m2 = matrix({{2, 3, 4, 5}, {6, 7, 8, 9}, {8, 7, 6, 5}, {4, 3, 2, 1}})
    refute approx_eq(m1, m2)
  end

  test "Multiplying two matrices" do
    a = matrix({{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 8, 7, 6}, {5, 4, 3, 2}})
    b = matrix({{-2, 1, 2, 3}, {3, 2, 1, -1}, {4, 3, 6, 5}, {1, 2, 7, 8}})

    assert mul(a, b) ==
             matrix({{20, 22, 50, 48}, {44, 54, 114, 108}, {40, 58, 110, 102}, {16, 26, 46, 42}})
  end

  test "A matrix multiplied by a tuple" do
    a = matrix({{1, 2, 3, 4}, {2, 4, 4, 2}, {8, 6, 4, 1}, {0, 0, 0, 1}})
    b = tuple(1, 2, 3, 1)

    assert mul(a, b) == tuple(18, 24, 33, 1)
  end

  property "Multiplying a matrix by the identity matrix" do
    check all m <- matrix_gen() do
      assert mul(m, identity(3)) == m
    end
  end

  test "Transposing a matrix" do
    a = matrix({{0, 9, 3, 0}, {9, 8, 0, 8}, {1, 8, 5, 3}, {0, 0, 5, 8}})
    assert transpose(a) == matrix({{0, 9, 1, 0}, {9, 8, 8, 0}, {3, 0, 5, 5}, {0, 8, 3, 8}})
  end

  test "Transposing the identity matrix" do
    assert transpose(identity(4)) == identity(4)
  end

  test "Calculating the determinant of a 2x2 matrix" do
    a = matrix({{1, 5}, {-3, 2}})
    assert determinant(a) == 17
  end

  test "A submatrix of a 3x3 matrix is a 2x2 matrix" do
    a = matrix({{1, 5, 0}, {-3, 2, 7}, {0, 6, -3}})
    assert submatrix(a, 0, 2) == matrix({{-3, 2}, {0, 6}})
  end

  test "A submatrix of a 4x4 matrix is a 3x3 matrix" do
    a = matrix({{-6, 1, 1, 6}, {-8, 5, 8, 6}, {-1, 8, 8, 2}, {-7, 1, -1, 1}})
    assert submatrix(a, 2, 1) == matrix({{-6, 1, 6}, {-8, 8, 6}, {-7, -1, 1}})
  end

  test "Calculating a minor of a 3x3 matrix" do
    a = matrix({{3, 5, 0}, {2, -1, -7}, {6, -1, 5}})
    b = submatrix(a, 1, 0)
    assert determinant(b) == 25
    assert minor(a, 1, 0) == 25
  end

  test "Calculating a cofactor of a 3x3 matrix" do
    a = matrix({{3, 5, 0}, {2, -1, -7}, {6, -1, 5}})
    assert minor(a, 0, 0) == -12
    assert cofactor(a, 0, 0) == -12
    assert minor(a, 1, 0) == 25
    assert cofactor(a, 1, 0) == -25
  end

  test "Calculating the determinant of a 3x3 matrix" do
    a = matrix({{1, 2, 6}, {-5, 8, -4}, {2, 6, 4}})
    assert cofactor(a, 0, 0) == 56
    assert cofactor(a, 0, 1) == 12
    assert cofactor(a, 0, 2) == -46
    assert determinant(a) == -196
  end

  test "Calculating the determinant of a 4x4 matrix" do
    a = matrix({{-2, -8, 3, 5}, {-3, 1, 7, 3}, {1, 2, -9, 6}, {-6, 7, 7, -9}})
    assert cofactor(a, 0, 0) == 690
    assert cofactor(a, 0, 1) == 447
    assert cofactor(a, 0, 2) == 210
    assert cofactor(a, 0, 3) == 51
    assert determinant(a) == -4071
  end

  test "Testing an invertible matrix for invertibility" do
    a = matrix({{6, 4, 4, 4}, {5, 5, 7, 6}, {4, -9, 3, -7}, {9, 1, 7, -6}})
    assert determinant(a) == -2120
    assert invertible?(a)
  end

  test "Testing a noninvertible matrix for invertibility" do
    a = matrix({{-4, 2, -2, -3}, {9, 6, 2, 6}, {0, -5, 1, -5}, {0, 0, 0, 0}})
    assert determinant(a) == 0
    refute invertible?(a)
  end

  test "Calculating the inverse of a matrix" do
    a = matrix({{-5, 2, 6, -8}, {1, -5, 1, 8}, {7, 7, -6, -7}, {1, -3, 7, 4}})
    b = inverse(a)
    assert determinant(a) == 532
    assert cofactor(a, 2, 3) == -160
    assert at(b, 3, 2) == -160 / 532
    assert cofactor(a, 3, 2) == 105
    assert at(b, 2, 3) == 105 / 532

    assert approx_eq(
             b,
             matrix({
               {0.21805, 0.45113, 0.24060, -0.04511},
               {-0.80827, -1.45677, -0.44361, 0.52068},
               {-0.07895, -0.22368, -0.05263, 0.19737},
               {-0.52256, -0.81391, -0.30075, 0.30639}
             })
           )
  end

  test "Calculating the inverse of another matrix" do
    a = matrix({{8, -5, 9, 2}, {7, 5, 6, 1}, {-6, 0, 9, 6}, {-3, 0, -9, -4}})

    assert approx_eq(
             inverse(a),
             matrix({
               {-0.15385, -0.15385, -0.28205, -0.53846},
               {-0.07692, 0.12308, 0.02564, 0.03077},
               {0.35897, 0.35897, 0.43590, 0.92308},
               {-0.69231, -0.69231, -0.76923, -1.92308}
             })
           )
  end

  test "Calculating the inverse of a third matrix" do
    a = matrix({{9, 3, 0, 9}, {-5, -2, -6, -3}, {-4, 9, 6, 4}, {-7, 6, 6, 2}})

    assert approx_eq(
             inverse(a),
             matrix({
               {-0.04074, -0.07778, 0.14444, -0.22222},
               {-0.07778, 0.03333, 0.36667, -0.33333},
               {-0.02901, -0.14630, -0.10926, 0.12963},
               {0.17778, 0.06667, -0.26667, 0.33333}
             })
           )
  end

  test "Multiplying a product by its inverse" do
    a = matrix({{3, -9, 7, 3}, {3, -8, 2, -9}, {-4, 4, 4, 1}, {-6, 5, -1, 1}})
    b = matrix({{8, 2, 2, 2}, {3, -1, 7, 0}, {7, 0, 5, 4}, {6, -2, 0, 5}})
    c = mul(a, b)
    b2 = inverse(b)
    a2 = mul(c, b2)
    assert approx_eq(a2, a)
  end
end
