# Loops With Friends

[Loops With Friends] is a collaborative music-making web app built with [Elixir]/[Phoenix], [Elm], and the [WebAudio API].

It supports up to seven users in a given "jam," in which each user gets their own music loop. Each user can start and stop their loop to make music in real time with the other users in the jam. The app automatically creates and balances additional jams as users join and leave.

See these blog posts for more on how it's built.

- [The Back End - Part I]
- [The Back End - Part II]
- [Healthy Elixir Tests]
- More to come

## Development

1. [Install] Elixir, Phoenix, and dependencies.

1. Clone and `cd` into the repository.
  ```shell
  git clone https://github.com/jeffcole/loops_with_friends.git
  cd loops_with_friends
  ```

1. Install Elixir dependencies.
  ```shell
  mix deps.get
  ```

1. Create and migrate the database.
  ```shell
  mix ecto.create && mix ecto.migrate
  ```

1. Install asset dependencies.
  ```shell
  npm install
  ```

1. Install Elm packages.
  ```shell
  cd web/static/elm
  ../../../node_modules/.bin/elm-package install
  cd ../../..
  ```

1. Run the server.
  ```shell
  mix phoenix.server
  ```

1. Visit `http://localhost:4000` in the browser.

## Testing

Run the test suite with `mix test`.

## Todo

- Add a welcome modal so that a tap can unlock the audio context on mobile.

## Attribution

The loops used by the app are [Apple Loops].

## License

Copyright © 2016 Jeff Cole. See [LICENSE](LICENSE) for more information.

[Loops With Friends]: http://www.loopswithfriends.com/
[Elixir]: http://elixir-lang.org/
[Phoenix]: http://www.phoenixframework.org/
[Elm]: http://elm-lang.org/
[WebAudio API]: https://webaudio.github.io/web-audio-api/
[The Back End - Part I]: http://jeff-cole.com/collaborative-music-loops-in-elixir-and-elm-the-back-end-part-1/
[The Back End - Part II]:  http://jeff-cole.com/collaborative-music-loops-in-elixir-and-elm-the-back-end-part-2/
[Healthy Elixir Tests]: http://jeff-cole.com/collaborative-music-loops-in-elixir-and-elm-healthy-elixir-tests/
[Install]: http://www.phoenixframework.org/docs/installation
[Apple Loops]: https://support.apple.com/en-us/HT201808
