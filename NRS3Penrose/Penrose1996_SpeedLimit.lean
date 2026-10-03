/-
Copyright (c) 2026 Eduardo Nava-Hernandez. All rights reserved.
Released under the NRS Noncommercial License 1.0.0 as described in the file LICENSE.
Authors: Eduardo Nava-Hernandez
-/
module

public import NRS3MandelstamTammCramerRao.MandelstamTamm1945
public import Mathlib.Analysis.Real.Pi.Bounds

/-!
# Penrose 1996 — the time–energy relation is a bound, not a lifetime

Penrose estimates the collapse time of a spatial superposition as `τ = ħ / ΔE` (Diósi–Penrose;
tested underground by Donadi et al., Nat. Phys. 17, 74 (2021)), reading the time–energy
relation as the lifetime of an unstable state. Unitary dynamics gives a bound instead, and that
bound is Mandelstam–Tamm (1945): nothing here is defined anew. The survival amplitude
`A(t) = ∑ p_k e^{−i E_k t}` and the spread `ΔE` (`ħ = 1`) are those of `MandelstamTamm1945`.

* At Penrose's time `1 / ΔE`, `‖A‖ ≥ cos 1 > 1/2`: the state has not decayed.
* No state is orthogonal before `π / (2 ΔE)`.
* Two equal branches: `‖A(t)‖ = |cos (ΔE t)|`, orthogonal exactly at `π / (2 ΔE)` and back to
  `1` with period `π / ΔE`. Unitary evolution never decays: a collapse at rate `ΔE / ħ` needs
  non-unitary dynamics.

## Main results

- `Penrose1996.one_sub_le_norm_amplitude` : `1 − ΔE² t² / 2 ≤ ‖A(t)‖` for every `t`.
- `Penrose1996.cos_one_le_norm_amplitude` : `cos 1 ≤ ‖A(t)‖` up to Penrose's time.
- `Penrose1996.half_lt_norm_amplitude` : `1/2 < ‖A(t)‖` up to Penrose's time.
- `Penrose1996.speed_limit` : `A(t) = 0` forces `π / 2 ≤ ΔE t`.
- `Penrose1996.twoBranch_orthogonal` : two branches are orthogonal at `π / (2 ΔE)`.
- `Penrose1996.twoBranch_periodic` : `‖A(t + π / ΔE)‖ = ‖A(t)‖`: no decay.
-/

@[expose] public noncomputable section

namespace Penrose1996

open Real MandelstamTamm1945

variable {n : ℕ} {p E : Fin n → ℝ}

theorem amplitude_neg (t : ℝ) : amplitude p E (-t) = amplitude p (-E) t := by
  simp only [amplitude, phase, Pi.neg_apply, mul_neg, neg_mul]

theorem spread_neg : spread p (-E) = spread p E := by
  have hm : mean p (-E) = -mean p E := by
    simp [mean, Finset.sum_neg_distrib]
  simp only [spread, hm, Pi.neg_apply]
  congr 1
  exact Finset.sum_congr rfl fun _ _ => by ring

theorem one_sub_le_norm_amplitude_of_nonneg (hp : ∀ k, 0 ≤ p k) (h1 : ∑ k, p k = 1) {t : ℝ}
    (ht0 : 0 ≤ t) : 1 - (spread p E * t) ^ 2 / 2 ≤ ‖amplitude p E t‖ := by
  rcases le_or_gt (spread p E * t) (π / 2) with ht | ht
  · exact (one_sub_sq_div_two_le_cos).trans (cos_le_norm_amplitude hp h1 ht0 ht)
  · have : (3 / 2 : ℝ) ^ 2 < (spread p E * t) ^ 2 := by
      have := pi_gt_three
      exact pow_lt_pow_left₀ (by linarith) (by norm_num) two_ne_zero
    linarith [norm_nonneg (amplitude p E t)]

/-- **The Taylor bound, as a corollary of Mandelstam–Tamm**: `1 − ΔE² t² / 2 ≤ ‖A(t)‖` for
every `t`. -/
theorem one_sub_le_norm_amplitude (hp : ∀ k, 0 ≤ p k) (h1 : ∑ k, p k = 1) (t : ℝ) :
    1 - (spread p E * t) ^ 2 / 2 ≤ ‖amplitude p E t‖ := by
  rcases le_total 0 t with ht | ht
  · exact one_sub_le_norm_amplitude_of_nonneg hp h1 ht
  · have h := one_sub_le_norm_amplitude_of_nonneg (E := -E) hp h1 (neg_nonneg.mpr ht)
    rwa [spread_neg, ← amplitude_neg, neg_neg, mul_neg, neg_sq] at h

/-- **At Penrose's time the amplitude is at least `cos 1`.** -/
theorem cos_one_le_norm_amplitude (hp : ∀ k, 0 ≤ p k) (h1 : ∑ k, p k = 1) {t : ℝ}
    (ht0 : 0 ≤ t) (ht : spread p E * t ≤ 1) : cos 1 ≤ ‖amplitude p E t‖ := by
  have hσ : 0 ≤ spread p E * t := mul_nonneg (Real.sqrt_nonneg _) ht0
  have hpi : (1 : ℝ) ≤ π / 2 := by linarith [pi_gt_three]
  refine le_trans ?_ (cos_le_norm_amplitude hp h1 ht0 (ht.trans hpi))
  exact cos_le_cos_of_nonneg_of_le_pi hσ (by linarith [pi_gt_three]) ht

/-- **Penrose's time is not a lifetime**: up to `1 / ΔE` the amplitude exceeds `1/2`. -/
theorem half_lt_norm_amplitude (hp : ∀ k, 0 ≤ p k) (h1 : ∑ k, p k = 1) {t : ℝ}
    (ht0 : 0 ≤ t) (ht : spread p E * t ≤ 1) : 1 / 2 < ‖amplitude p E t‖ := by
  refine lt_of_lt_of_le ?_ (cos_one_le_norm_amplitude hp h1 ht0 ht)
  rw [← cos_pi_div_three]
  exact cos_lt_cos_of_nonneg_of_le_pi_div_two zero_le_one (by linarith [pi_gt_three])
    (by linarith [pi_gt_three])

/-- **No orthogonality before `π / (2 ΔE)`** (Mandelstam–Tamm). -/
theorem speed_limit (hp : ∀ k, 0 ≤ p k) (h1 : ∑ k, p k = 1) {t : ℝ} (ht0 : 0 ≤ t)
    (h0 : amplitude p E t = 0) : π / 2 ≤ spread p E * t :=
  orthogonality_time hp h1 ht0 h0

/-! ## Two equal branches -/

/-- **Two branches are orthogonal at `π / (2 ΔE)`.** -/
theorem twoBranch_orthogonal {E₀ E₁ : ℝ} (h : E₀ ≠ E₁) :
    amplitude half ![E₀, E₁] (π / (2 * spread half ![E₀, E₁])) = 0 := by
  have hd : spread half ![E₀, E₁] ≠ 0 := by
    rw [spread_half]
    exact abs_ne_zero.mpr fun h' => h (by linarith)
  rw [← norm_eq_zero, norm_amplitude_half, mul_div_assoc', mul_comm, mul_div_mul_right _ _ hd,
    cos_pi_div_two, abs_zero]

/-- **No decay**: the two-branch amplitude returns with period `π / ΔE`. -/
theorem twoBranch_periodic {E₀ E₁ : ℝ} (h : E₀ ≠ E₁) (t : ℝ) :
    ‖amplitude half ![E₀, E₁] (t + π / spread half ![E₀, E₁])‖ =
      ‖amplitude half ![E₀, E₁] t‖ := by
  have hd : spread half ![E₀, E₁] ≠ 0 := by
    rw [spread_half]
    exact abs_ne_zero.mpr fun h' => h (by linarith)
  rw [norm_amplitude_half, norm_amplitude_half, mul_add, mul_div_cancel₀ _ hd, cos_add_pi,
    abs_neg]

end Penrose1996
