use crate::decode_float;
use rustler::{types, Decoder, Encoder, Env, NifResult, Term};

#[derive(Debug, Copy, Clone, Default)]
pub struct Tuple(pub f32, pub f32, pub f32, pub f32);

impl Encoder for Tuple {
    fn encode<'a>(&self, env: Env<'a>) -> Term<'a> {
        let t = (self.0, self.1, self.2, self.3);
        t.encode(env)
    }
}

impl<'a> Decoder<'a> for Tuple {
    fn decode(term: Term<'a>) -> NifResult<Tuple> {
        let parts = types::tuple::get_tuple(term)?;
        let a = decode_float(parts[0])?;
        let b = decode_float(parts[1])?;
        let c = decode_float(parts[2])?;
        let d = decode_float(parts[3])?;
        Ok(Tuple(a, b, c, d))
    }
}
