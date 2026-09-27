
# Gravity Simulations: From a Stable Orbit to Chaos

Two MATLAB scripts that simulate gravitating bodies by numerically integrating Newton's equations of motion with ode45(via Runge Kutta method), and then animate the result. Note: the code for animation is given for granted by the question itself, the original coursework was to work out the modelling dynamic of two body system along with Newton's law and setting up the ODE on MatLab. 

- **`two_body_2d.m`** — the classic 2-body problem in a plane. One body orbits another in a fixed, repeating ellipse. 
- **`three_body_3d_chaos.m`** — precisely the same idea extended to **three** bodies in **3D**, used to demonstrate that adding just one more body turns a perfectly predictable system into a chaotic one. Still unfinished file is yet be to uploaded...


## Why two scripts?

The 2-body problem is integrable: there's a closed-form solution, and two initial conditions that start close together stay close together forever. The moment you add a third gravitating body, no general closed-form solution exists, and the system becomes chaotic: two initial conditions that differ by a tiny amount can diverge completely after a while. The two scripts here are meant to be run side by side so you can see that contrast for yourself.


### `Two Body Oribit`

Solves the reduced Kepler problem in relative coordinates `(x, y)`, then reconstructs each body's position from the mass ratio. I annimated both bodies as filled circles orbiting their common center of mass over several periods.

- Masses: `m1 = 1`, `m2 = 4`
- Eccentricity: `e = 0.7`
- Integrator: `ode45`, `RelTol = 1e-6`

### `Three Body Orbit`

Solves the general 3D N-body equations of motion (positions **and** velocities, in the inertial frame — no reduction to relative coordinates, since that trick only works for two bodies) for three masses arranged in the classic **Pythagorean three-body problem** (masses `3, 4, 5` at the corners of a 3-4-5 right triangle, released from rest), tilted slightly out of the `xy`-plane so the motion is genuinely three-dimensional.

It runs the simulation **twice** — once as-is, and once with a `1e-8` nudge to one body's initial `x`-coordinate — and produces four figures:

1. The 3D trajectories of all three bodies.
2. The two runs overlaid (solid vs. dashed) so you can watch them stay together, then visibly split apart.
3. The separation between the two runs on a **log scale** — a straight line here means *exponential* growth, the signature of chaos (as opposed to the *linear* growth you'd see perturbing the 2-body problem). The script also fits this and prints an estimated finite-time Lyapunov exponent.
4. A 3D animation of the three bodies as spheres, sized roughly by mass.

- Masses: `m = [3, 4, 5]`, `G = 1`
- Integrator: `ode45`, `RelTol = 1e-11`, `AbsTol = 1e-13` (chaotic systems need tight tolerances)
- Integration horizon: `t = 0` to `60`, long enough to see a close encounter and one body get ejected

## Requirements

- MATLAB (R2016b or later)


## What the script does?

1. Integrates the equations of motion with `ode45`.
2. Opens one or more figure windows with the static plots.
3. Runs a live animation in a figure window (uses `drawnow`, so it needs a display — see note below for headless/CI use).

**Note:** the animation loops use `drawnow` and therefore expect a graphical display. If you're running headlessly (e.g. in CI, or over SSH without X forwarding), comment out the animation section, or run with a virtual display (e.g. `xvfb-run octave three_body_3d_chaos.m`).

## Ideas for extending this(in the future)

- Increase `N` and add more bodies to `three_body_3d_chaos.m` (the equations of motion are already written generally for any number of bodies).
- Perturb a different coordinate, or a different body, and compare how quickly it diverges.
- Try a different chaos-adjacent three-body starting configuration (e.g. the figure-eight orbit is famously *not* chaotic — a nice contrast case).
- Plot total energy and angular momentum over time as a sanity check on the integration accuracy.


