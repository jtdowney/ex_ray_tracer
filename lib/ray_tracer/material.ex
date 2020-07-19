defmodule RayTracer.Material do
  alias RayTracer.Vector
  import RayTracer.Core

  defstruct color: color(1, 1, 1), ambient: 0.1, diffuse: 0.9, specular: 0.9, shininess: 200

  def material() do
    %RayTracer.Material{}
  end

  def lighting(m, light, point, eyev, normalv) do
    effective_color = hadamard_product(m.color, light.intensity)
    lightv = sub(light.position, point) |> Vector.normalize()
    ambient = scalar_mul(effective_color, m.ambient)
    light_dot_normal = Vector.dot(lightv, normalv)

    if light_dot_normal < 0 do
      ambient
    else
      diffuse = scalar_mul(effective_color, m.diffuse) |> scalar_mul(light_dot_normal)

      reflectv = negate(lightv) |> Vector.reflect(normalv)
      reflect_dot_eye = Vector.dot(reflectv, eyev)

      if reflect_dot_eye <= 0 do
        add(ambient, diffuse)
      else
        factor = :math.pow(reflect_dot_eye, m.shininess)
        specular = scalar_mul(light.intensity, m.specular) |> scalar_mul(factor)
        add(ambient, diffuse) |> add(specular)
      end
    end
  end
end
