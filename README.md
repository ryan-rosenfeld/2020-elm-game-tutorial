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

### Editor support

If you use vscode, you should install the [Elm
extension](https://marketplace.visualstudio.com/items?itemName=Elmtooling.elm-ls-vscode);
format-on-save is turned on for this workspace already so whenever you save you should see your file
get reformatted.

Otherwise, go read https://github.com/elm/editor-plugins to find the plugin for your editor;
sometimes there are better plugins than the official one too so search the interwebs as well.

## Your first exercises

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
