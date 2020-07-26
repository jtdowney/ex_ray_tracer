defmodule RayTracer.Transformation do
  @moduledoc """
  Construction of transformation matricies for objects and the `RayTracer.Camera`.
  """

  import RayTracer.Core
  alias RayTracer.{Matrix, Vector}

  def translation(x, y, z) do
    Matrix.matrix({{1, 0, 0, x}, {0, 1, 0, y}, {0, 0, 1, z}, {0, 0, 0, 1}})
  end

  def translation(m, x, y, z) do
    t = translation(x, y, z)
    Matrix.mul(m, t)
  end

  def scaling(x, y, z) do
    Matrix.matrix({{x, 0, 0, 0}, {0, y, 0, 0}, {0, 0, z, 0}, {0, 0, 0, 1}})
  end

  def scaling(m, x, y, z) do
    t = scaling(x, y, z)
    Matrix.mul(m, t)
  end

  def rotation_x(r) do
    sin = :math.sin(r)
    cos = :math.cos(r)
    Matrix.matrix({{1, 0, 0, 0}, {0, cos, -sin, 0}, {0, sin, cos, 0}, {0, 0, 0, 1}})
  end

  def rotation_x(m, r) do
    t = rotation_x(r)
    Matrix.mul(m, t)
  end

  def rotation_y(r) do
    sin = :math.sin(r)
    cos = :math.cos(r)
    Matrix.matrix({{cos, 0, sin, 0}, {0, 1, 0, 0}, {-sin, 0, cos, 0}, {0, 0, 0, 1}})
  end

  def rotation_y(m, r) do
    t = rotation_y(r)
    Matrix.mul(m, t)
  end

  def rotation_z(r) do
    sin = :math.sin(r)
    cos = :math.cos(r)
    Matrix.matrix({{cos, -sin, 0, 0}, {sin, cos, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}})
  end

  def rotation_z(m, r) do
    t = rotation_z(r)
    Matrix.mul(m, t)
  end

  def shearing(xy, xz, yx, yz, zx, zy) do
    Matrix.matrix({{1, xy, xz, 0}, {yx, 1, yz, 0}, {zx, zy, 1, 0}, {0, 0, 0, 1}})
  end

  def shearing(m, xy, xz, yx, yz, zx, zy) do
    t = shearing(xy, xz, yx, yz, zx, zy)
    Matrix.mul(m, t)
  end

  def view_transform({fromx, fromy, fromz, _} = from, to, up) do
    up = Vector.normalize(up)
    {forwardx, forwardy, forwardz, _} = forward = sub(to, from) |> Vector.normalize()
    {leftx, lefty, leftz, _} = left = Vector.cross(forward, up)
    {true_upx, true_upy, true_upz, _} = Vector.cross(left, forward)

    orientation =
      Matrix.matrix(
        {{leftx, lefty, leftz, 0}, {true_upx, true_upy, true_upz, 0},
         {-forwardx, -forwardy, -forwardz, 0}, {0, 0, 0, 1}}
      )

    orientation |> translation(-fromx, -fromy, -fromz)
  end
end
