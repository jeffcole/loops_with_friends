# Loops With Friends

[Loops With Friends] is a collaborative music-making web app built with [Elixir]/[Phoenix], [Elm], and the [WebAudio API].

It supports up to seven users in a given "jam," in which each user gets their own music loop. Each user can start and stop their loop to make music in real time with the other users in the jam. The app automatically creates and balances additional jams as users join and leave.

See these blog posts for more on how it's built.

1. [Collaborative Music Loops in Elixir and Elm]
1. [Jamming with Phoenix Presence]
1. [Talk to My (Elixir) Agent]
1. [Phoenix Channel Race Conditions]
1. [Testing Phoenix Sockets and Channels]
1. [Injecting Agent Names in Elixir Tests]
1. [Using Stubs to Isolate Elixir Tests]
1. [Testing Function Delegation in Elixir]

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

- [ ] Eliminate the loop queueing gap by playing all loops on page load at zero volume, and setting the volume on user message receipt.

## Attribution

The loops used by the app are [Apple Loops].

## License

Copyright © 2017 Jeff Cole. See [LICENSE](LICENSE) for more information.

[Loops With Friends]: http://loops-with-friends.herokuapp.com
[Elixir]: http://elixir-lang.org/
[Phoenix]: http://www.phoenixframework.org/
[Elm]: http://elm-lang.org/
[WebAudio API]: https://webaudio.github.io/web-audio-api/
[Collaborative Music Loops in Elixir and Elm]: http://jeff-cole.com/collaborative-music-loops-in-elixir-and-elm
[Jamming with Phoenix Presence]: http://jeff-cole.com/jamming-with-phoenix-presence
[Talk to My (Elixir) Agent]: http://jeff-cole.com/talk-to-my-elixir-agent
[Phoenix Channel Race Conditions]: http://jeff-cole.com/phoenix-channel-race-conditions
[Testing Phoenix Sockets and Channels]: http://jeff-cole.com/testing-phoenix-sockets-and-channels
[Injecting Agent Names in Elixir Tests]: http://jeff-cole.com/injecting-agent-names-in-elixir-tests
[Using Stubs to Isolate Elixir Tests]: http://jeff-cole.com/using-stubs-to-isolate-elixir-tests
[Testing Function Delegation in Elixir]: http://jeff-cole.com/testing-function-delegation-in-elixir
[Install]: http://www.phoenixframework.org/docs/installation
[Apple Loops]: https://support.apple.com/en-us/HT201808
