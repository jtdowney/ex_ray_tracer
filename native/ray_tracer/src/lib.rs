use rustler::{NifResult, Term};

pub mod matrix;
pub mod tuple;

pub fn decode_float(term: Term<'_>) -> NifResult<f32> {
    term.decode::<f32>()
        .or_else(|_| term.decode::<i16>().map(f32::from))
}
