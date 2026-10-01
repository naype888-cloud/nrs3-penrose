# NRS³ · Penrose

**Penrose's collapse time `ħ / ΔE` is a bound, not a lifetime** — at that time every unitary
evolution still keeps a survival amplitude of at least `1/2`. Lean 4.

![NRS³ · Penrose](docs/figures/penrose1996_speed_limit.png)

## Results

| Statement | Lean |
|---|---|
| `‖A(t)‖ ≥ 1 − ΔE² t² / 2` for every finite spectrum | `one_sub_le_norm_amplitude` |
| no orthogonality before `√2 ħ/ΔE` | `speed_limit` |
| at Penrose's time `ħ/ΔE`: `‖A‖ ≥ 1/2` | `half_le_norm_amplitude` |
| two equal branches: `‖A(t)‖ = |cos ΔE t|`, orthogonal exactly at `πħ/(2ΔE)` | `twoBranch_norm_amplitude`, `twoBranch_orthogonal` |
| and back to `1` with period `πħ/ΔE`: no decay | `twoBranch_periodic` |

The sharp constant `π/2` for every state is in `nrs3-mandelstam-tamm` (at `ħ/ΔE` it gives
`‖A‖ ≥ cos 1 ≈ 0.54`).

## In NRS³

The time–energy side of NRS³ (`D40`, `D41` in the base repository) bounds how fast a state can
move. Read as a bound, it cannot make a superposition decay at rate `ΔE/ħ`: a gravity-related
collapse needs non-unitary dynamics.

## History

Penrose (1996) estimated the collapse time of a superposition of two mass distributions as
`τ = ħ / ΔE` from the gravitational self-energy of their difference; Diósi (1987) gave a stochastic
dynamics with the same scale. Donadi et al., *Nat. Phys.* 17, 74 (2021), ruled out the
parameter-free Diósi–Penrose model at Gran Sasso. Nothing here tests gravity; it only shows what
unitary quantum mechanics says at `ħ / ΔE`.

## Build

Lean 4 `v4.34.0`, Mathlib `v4.34.0`, nothing else.

```bash
lake exe cache get
lake build
lake env lean Verification/Axioms.lean   # only propext, Classical.choice, Quot.sound
```

Every file: no `sorry`, lines of at most 100 characters, English headers.

## The mosaic

- [NRS and NRS³ — the base theorem](https://github.com/naype888-cloud/nava-robertson-schrodinger)
- [NRS³ · Cramér–Rao](https://github.com/naype888-cloud/nrs3-cramer-rao)
- [NRS³ · Mandelstam–Tamm](https://github.com/naype888-cloud/nrs3-mandelstam-tamm)
- **[NRS³ · Penrose](https://github.com/naype888-cloud/nrs3-penrose)** (this one)
- [NRS³ · Dirac](https://github.com/naype888-cloud/nrs3-dirac)
- [NRS³ · Pauli](https://github.com/naype888-cloud/nrs3-pauli)
- [NRS³ · Poincaré](https://github.com/naype888-cloud/nrs3-poincare)

## License

NRS Noncommercial License 1.0.0, see [`LICENSE`](LICENSE). Author: Eduardo Nava-Hernandez.
