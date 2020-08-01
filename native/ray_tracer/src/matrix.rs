use crate::decode_float;
use crate::tuple::Tuple;
use byteorder::{NativeEndian, ReadBytesExt, WriteBytesExt};
use rustler::error::Error as NifError;
use rustler::{types, Binary, Decoder, Encoder, Env, ListIterator, NifResult, OwnedBinary, Term};
use std::iter::FromIterator;
use std::ops::{Index, IndexMut, Mul};

const MODULE_NAME: &str = "Elixir.RayTracer.Matrix.Native";
const EPSILON: f32 = 0.00001;

mod atoms {
    rustler::atoms! {
        module = super::MODULE_NAME,
        data,
        invalid_operation,
        not_invertable,
    }
}

fn decode_size(size: usize) -> NifResult<usize> {
    let value = match size {
        16 => 4,
        9 => 3,
        4 => 2,
        _ => return Err(NifError::Atom("invalid_matrix")),
    };

    Ok(value)
}

#[derive(Debug)]
struct Matrix {
    data: Vec<f32>,
    size: usize,
}

impl Matrix {
    fn new(size: usize) -> Self {
        let data = vec![0.0; size * size];
        Matrix { data, size }
    }

    fn transpose(&self) -> Self {
        let mut result = Matrix::new(self.size);
        for i in 0..self.size {
            for j in 0..self.size {
                result[(i, j)] = self[(j, i)];
            }
        }

        result
    }

    fn determinant(&self) -> f32 {
        match self.size {
            2 => self.data[0] * self.data[3] - self.data[1] * self.data[2],
            n => (0..n)
                .zip(0..n)
                .map(|(i, j)| self[(0, j)] * self.cofactor(0, i))
                .sum(),
        }
    }

    fn submatrix(&self, row: usize, col: usize) -> Matrix {
        (0..self.size)
            .filter(|&i| row != i)
            .flat_map(|i| {
                (0..self.size)
                    .filter(|&j| col != j)
                    .map(move |j| self[(i, j)])
            })
            .collect()
    }

    fn minor(&self, row: usize, col: usize) -> f32 {
        self.submatrix(row, col).determinant()
    }

    fn cofactor(&self, row: usize, col: usize) -> f32 {
        let value = self.minor(row, col);
        if (row + col) % 2 == 0 {
            value
        } else {
            -value
        }
    }

    fn inverse(&self) -> Option<Matrix> {
        let d = self.determinant();
        if d == 0.0 {
            return None;
        }

        let mut output = Matrix::new(self.size);
        for i in 0..self.size {
            for j in 0..self.size {
                let c = self.cofactor(i, j);
                output[(j, i)] = c / d;
            }
        }

        Some(output)
    }
}

impl Index<(usize, usize)> for Matrix {
    type Output = f32;

    fn index(&self, (i, j): (usize, usize)) -> &Self::Output {
        let offset = i * self.size + j;
        &self.data[offset]
    }
}

impl IndexMut<(usize, usize)> for Matrix {
    fn index_mut(&mut self, (i, j): (usize, usize)) -> &mut Self::Output {
        let offset = i * self.size + j;
        &mut self.data[offset]
    }
}

impl Mul<Matrix> for Matrix {
    type Output = Matrix;

    fn mul(self, other: Matrix) -> Self::Output {
        assert_eq!(self.size, other.size);

        let mut result = Matrix::new(self.size);

        for i in 0..self.size {
            for j in 0..self.size {
                result[(i, j)] = (0..self.size).map(|n| self[(i, n)] * other[(n, j)]).sum();
            }
        }

        result
    }
}

impl Mul<Tuple> for Matrix {
    type Output = Tuple;

    fn mul(self, other: Tuple) -> Self::Output {
        let mut result = Tuple::default();
        result.0 = self[(0, 0)] * other.0
            + self[(0, 1)] * other.1
            + self[(0, 2)] * other.2
            + self[(0, 3)] * other.3;
        result.1 = self[(1, 0)] * other.0
            + self[(1, 1)] * other.1
            + self[(1, 2)] * other.2
            + self[(1, 3)] * other.3;
        result.2 = self[(2, 0)] * other.0
            + self[(2, 1)] * other.1
            + self[(2, 2)] * other.2
            + self[(2, 3)] * other.3;
        result.3 = self[(3, 0)] * other.0
            + self[(3, 1)] * other.1
            + self[(3, 2)] * other.2
            + self[(3, 3)] * other.3;
        result
    }
}

impl<'a> From<&'a [u8]> for Matrix {
    fn from(bytes: &'a [u8]) -> Self {
        let mut ptr = bytes;
        let length = bytes.len() / 4;
        let size = decode_size(length).unwrap();
        let mut data = Vec::with_capacity(length);

        for _ in 0..length {
            data.push(ptr.read_f32::<NativeEndian>().unwrap());
        }

        Matrix { data, size }
    }
}

impl FromIterator<f32> for Matrix {
    fn from_iter<T>(iter: T) -> Self
    where
        T: IntoIterator<Item = f32>,
    {
        let data: Vec<f32> = iter.into_iter().collect();
        let size = decode_size(data.len()).unwrap();
        Matrix { data, size }
    }
}

impl Encoder for Matrix {
    fn encode<'a>(&self, env: Env<'a>) -> Term<'a> {
        let mut data = OwnedBinary::new(self.data.len() * 4).unwrap();
        let mut bytes = data.as_mut_slice();

        for &value in &self.data {
            bytes.write_f32::<NativeEndian>(value).unwrap();
        }

        let mut matrix = types::elixir_struct::make_ex_struct(env, MODULE_NAME).unwrap();
        let term = data.release(env);
        matrix = matrix
            .map_put(atoms::data().encode(env), term.encode(env))
            .unwrap();
        matrix
    }
}

impl<'a> Decoder<'a> for Matrix {
    fn decode(term: Term<'a>) -> NifResult<Matrix> {
        let env = term.get_env();
        let module = types::elixir_struct::get_ex_struct_name(term)?;
        if module != atoms::module() {
            return Err(NifError::Atom("invalid_struct"));
        }

        let data: Binary<'a> = term.map_get(atoms::data().to_term(env))?.decode()?;
        let matrix = data.as_slice().into();

        Ok(matrix)
    }
}

#[rustler::nif]
fn from_list(list: ListIterator) -> NifResult<Matrix> {
    list.map(decode_float).collect::<NifResult<Matrix>>()
}

#[rustler::nif]
fn at(matrix: Matrix, i: usize, j: usize) -> f32 {
    matrix[(i, j)]
}

#[rustler::nif]
fn mul<'a>(env: Env<'a>, a: Matrix, b: Term<'a>) -> NifResult<Term<'a>> {
    if let Ok(m) = b.decode::<Matrix>() {
        let result = a * m;
        Ok(result.encode(env))
    } else if let Ok(t) = b.decode::<Tuple>() {
        let result = a * t;
        Ok(result.encode(env))
    } else {
        Err(NifError::Term(Box::new(atoms::invalid_operation())))
    }
}

#[rustler::nif]
fn approx_eq(a: Matrix, b: Matrix) -> bool {
    a.data
        .iter()
        .zip(b.data.iter())
        .map(|(&a, &b)| (a - b).abs())
        .all(|diff| diff <= EPSILON)
}

#[rustler::nif]
fn transpose(m: Matrix) -> Matrix {
    m.transpose()
}

#[rustler::nif]
fn determinant(m: Matrix) -> f32 {
    m.determinant()
}

#[rustler::nif]
fn submatrix(m: Matrix, i: usize, j: usize) -> Matrix {
    m.submatrix(i, j)
}

#[rustler::nif]
fn minor(m: Matrix, i: usize, j: usize) -> f32 {
    m.minor(i, j)
}

#[rustler::nif]
fn cofactor(m: Matrix, i: usize, j: usize) -> f32 {
    m.cofactor(i, j)
}

#[rustler::nif]
fn inverse(m: Matrix) -> NifResult<Matrix> {
    m.inverse()
        .ok_or_else(|| NifError::Term(Box::new(atoms::not_invertable())))
}

#[rustler::nif]
fn values(m: Matrix) -> Vec<f32> {
    m.data
}

rustler::init!(
    "Elixir.RayTracer.Matrix.Native",
    [
        from_list,
        at,
        mul,
        approx_eq,
        transpose,
        determinant,
        minor,
        submatrix,
        cofactor,
        inverse,
        values,
    ]
);
