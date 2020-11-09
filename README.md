# Elm Game

A basic scaffold to start a game with stuff like hot code reloading already taken care of.

## Developing

### Prereqs

* node/yarn - this repo is set up to use [ASDF](https://github.com/asdf-vm/asdf) but NVM is fine too

### Get started

```
yarn # Elm doesn't use NPM for packages, but it's an easy way to install Elm itself
yarn serve # run server and open browser
yarn serve --debug # run server with Elm's time traveling debugger enabled
```

Then open up `src/Main.elm` and change a number in the `update` function to a different number, and
notice that it changes how the `+`/`-` buttons behave.

Also notice that this is using hot code reloading: when you change `Main.elm`, the Elm code is
reloaded without wiping out the app state. This is convenient but can also bite you in certain
circumstances, so for now - while you are learning - if you notice weird things in your app then
just manually refresh the page in your browser and it'll be right as rain.

If you run with `--debug` then that's actually getting passed through to `elm-live` (check
`package.json`) which in turn passes it through to `elm make` (the Elm compiler) to make it do a
debug build. In a debug build, you can open up the debugger by clicking the little square at the
bottom right of the browser window, and use the UI that it shows to go back and forth through the
app's state.

### Other commands

* `yarn build` - if `yarn serve` doesn't work because you have a compile error, use this to run
  just the build
* `yarn elm install some/package` - install a package
* `yarn elm repl` - get a prompt where you can test out Elm commands

### Editor support

If you use vscode, you should install the [Elm
extension](https://marketplace.visualstudio.com/items?itemName=Elmtooling.elm-ls-vscode);
format-on-save is turned on for this workspace already so whenever you save you should see your file
get reformatted.

Otherwise, go read https://github.com/elm/editor-plugins to find the plugin for your editor;
sometimes there are better plugins than the official one too so search the interwebs as well.

## Exercises

### Your first steps with Elm

If you are new to Elm, check out the `button` branch and complete these exercises on that branch:

1. Make the + button add `3` to the current total instead of `1`
2. Add a square button which squares the current total and makes that the new total
3. Add an undo button which you can click once to set you back to the state before you pressed the
   last button (after the undo button is clicked once, it should be disabled)
4. Extend the undo button so that it lets you undo until you got back to the start (when you get
   back to the start, the undo button should be disabled)
5. Add some UI which displays all previous operations and the totals they resulted in (if you have
   time, make it so clicking an entry goes back to that state)

The next session *won't* build on this, so don't sweat it if you can't get all this working. Just do
your best to get as far as you can (the further you get, the easier it will be in later sessions!).

Remember you can ask for help if you get stuck, even if it's outside of the session time.

### Starting the game

On this branch you can see a spinning square which changes colors; it was taken from the Elm Canvas
library's starting example and then modified to explain a bit and to add input handling.

Your task is to take that and turn it into a game of Asteroids! Here's a suggested plan of attack
for your first hour or so:

1. draw a stationary ship on the screen as hardcoded x/y position (ship should be a triangle, not a
   square!)
2. make left/right arrow keys rotate ship left/right
   1. record when left/right arrow keys are held down
   2. model this rotation in radians (radian refresher: pi radians == 360 degrees)
   3. based on which arrow keys are held down, multiply hardcoded turning speed by delta time from
      elm’s request animation frame: rotation = rotation * direction * TURN_SPEED * delta_time
3. make up key fire the ship’s thrusters and apply acceleration to move the ship forward in the
   faced direction
   1. record when up key is pressed and released
   2. if up key down, then vx = vx + cos(rotation) * THRUST_AMOUNT * delta_time and x = x + vx (and
      similar for y direction except using sin instead of cos)
4. ship going off the edge should wrap to the opposite edge of the screen (maintaining same
   velocity)

### Adding hazards

Now that you have a ship that you can fly around, let's make it dangerous!

1. draw some asteroids on screen in hardcoded start positions
2. move the asteroids around on the screen with hardcoded starting velocity
3. asteroids should wrap around the screen as well
   1. if you think this through, you should be able to share the logic for updating asteroids with
      the logic that updates the ship's position (both for velocity and wrapping on screen edge)
4. restart the game when the ship hits an asteroid
   1. assume a given asteroid and ship are both circular, each with known fixed radiuses r1 & r2,
      then if r1 + r2 > ((x1-x2)^2 + (y1-y2)^2)^0.5 → ship and asteroid have collided


### Making it go pew pew

Let's show those asteroids who is the boss by giving our ship some firepower!

1. hit space to shoot a bullet
2. fire bullet when space is pressed down initially but not when it is held down
3. bullet should travel in the direction the ship is facing
4. after just under a screen’s length, the bullet should disappear (so you can’t shoot yourself)
5. bullet hitting asteroid should kill the asteroid and spawn new smaller asteroids that go off in
   separate directions at higher velocity than the initial asteroid
