#![allow(clippy::needless_range_loop)]
#[macro_use]
extern crate cp;
#[allow(unused_imports)]
use cp::luma::util::ord::*;
use cp::luma::with_inf::*;
use std::cmp::{max, min};
use std::collections::{HashMap, HashSet};

fn main() {
    input! {
        a: i32,
        b: i32,
        c: i32,
        d: i32,
        s: chars,
        t: chars,
        h: u32,
        w: u32,
        bo: [[char; h]; w],
    }
    println!("{}", a + b);
}
