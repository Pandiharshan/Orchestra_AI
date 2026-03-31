

## Redesign Login/Signup Screen — Warm Minimal Luxury

The current Login.tsx already follows many design system principles (surface hierarchy, gradient-primary, inset-field, label-meta). The redesign will elevate it to fully match the "Modern Atelier" spec.

### Changes to `src/pages/Login.tsx`

**Layout & Atmosphere**
- Split into a two-panel layout on desktop: left side with a branded editorial illustration area (gradient-primary background with a large display-lg tagline), right side with the form. On smaller screens, form-only centered.
- Add a subtle decorative element — a large, soft radial gradient orb behind the form for depth.

**Logo & Branding**
- Increase logo size and add more vertical breathing room (mb-16 instead of mb-10).
- Use `tracking-[-0.02em]` on the brand name for the editorial tight feel.

**Card Container**
- Remove `rounded-2xl` border appearance; use `surface-lowest` on `surface` canvas (already done) but increase padding to `p-10` for more luxury spacing.
- Ensure no borders — pure tonal separation only.

**Form Fields**
- Increase vertical spacing between fields from `space-y-4` to `space-y-6`.
- Add `duration-200` transition on focus background change.
- Use proper `label-meta` styling (already uppercase + tracking).

**Google Button**
- Style with `surface-container-low`, add hover lift (`hover:-translate-y-0.5 hover:shadow-ambient`), ensure `duration-200` transition.

**Divider**
- Replace the `h-px bg-muted` lines with a softer approach: use `surface-dim` at reduced opacity for the line, maintaining the warm tone rule.

**Primary CTA**
- Keep `gradient-primary` with hover lift. Add slightly larger padding (`py-3.5`).

**Remember Me / Forgot Password**
- Style checkbox with warm primary color (no default browser checkbox — use a styled span or the existing Checkbox component from shadcn).
- "Forgot password?" uses `text-primary` with `hover:opacity-80` instead of underline.

**Toggle (Sign in / Sign up)**
- Add a smooth `motion.div` layout animation when switching between modes to feel premium.
- When in signup mode, add a "Full Name" field above email with a staggered entrance animation.

**Signup additions**
- Add a "Full Name" input field when `isSignup` is true.
- Add a "Confirm Password" field when `isSignup` is true.

### Files Modified
1. **`src/pages/Login.tsx`** — Complete redesign with two-panel layout, refined spacing, animated mode switching, and full design system compliance.

