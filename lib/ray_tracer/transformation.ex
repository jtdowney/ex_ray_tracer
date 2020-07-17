defmodule RayTracer.Transformation do
  import RayTracer.Matrix

  def translation(x, y, z) do
    matrix({{1, 0, 0, x}, {0, 1, 0, y}, {0, 0, 1, z}, {0, 0, 0, 1}})
  end

  def translation(m, x, y, z) do
    t = translation(x, y, z)
    mul(m, t)
  end

  def scaling(x, y, z) do
    matrix({{x, 0, 0, 0}, {0, y, 0, 0}, {0, 0, z, 0}, {0, 0, 0, 1}})
  end

  def scaling(m, x, y, z) do
    t = scaling(x, y, z)
    mul(m, t)
  end

  def rotation_x(r) do
    sin = :math.sin(r)
    cos = :math.cos(r)
    matrix({{1, 0, 0, 0}, {0, cos, -sin, 0}, {0, sin, cos, 0}, {0, 0, 0, 1}})
  end

  def rotation_x(m, r) do
    t = rotation_x(r)
    mul(m, t)
  end

  def rotation_y(r) do
    sin = :math.sin(r)
    cos = :math.cos(r)
    matrix({{cos, 0, sin, 0}, {0, 1, 0, 0}, {-sin, 0, cos, 0}, {0, 0, 0, 1}})
  end

  def rotation_y(m, r) do
    t = rotation_y(r)
    mul(m, t)
  end

  def rotation_z(r) do
    sin = :math.sin(r)
    cos = :math.cos(r)
    matrix({{cos, -sin, 0, 0}, {sin, cos, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}})
  end

  def rotation_z(m, r) do
    t = rotation_z(r)
    mul(m, t)
  end

  def shearing(xy, xz, yx, yz, zx, zy) do
    matrix({{1, xy, xz, 0}, {yx, 1, yz, 0}, {zx, zy, 1, 0}, {0, 0, 0, 1}})
  end

  def shearing(m, xy, xz, yx, yz, zx, zy) do
    t = shearing(xy, xz, yx, yz, zx, zy)
    mul(m, t)
  end
end
