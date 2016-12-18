module Loop.State exposing (initialState, update, queue, play, stop)

import Task exposing (Task)
import WebAudio
import Loop.Types exposing (..)


initialState : String -> Event -> ( Model, Cmd Msg )
initialState name event =
    ( initialModelFromEvent name event
    , attemptLoad name
    )


update : Msg -> Model -> ( Model, OutMsg )
update msg model =
    case msg of
        LoadSucceed sound ->
            ( { model | sound = Loaded sound }
            , NoMsg
            )

        LoadFail error ->
            ( model, NoMsg )

        PlaySucceed sound ->
            ( { model | state = Playing, sound = Loaded sound }
            , case model.state of
                Queued ->
                    Played

                _ ->
                    NoMsg
            )

        PlayFail error ->
            ( model, NoMsg )

        StopSucceed () ->
            ( { model | state = NotPlaying }
            , Stopped
            )


queue : Model -> ( Model, Cmd Msg )
queue model =
    ( { model | state = Queued }
    , Cmd.none
    )


play : Model -> Cmd Msg
play model =
    case model.state of
        NotPlaying ->
            Cmd.none

        _ ->
            attemptPlay model.sound


stop : Model -> ( Model, Cmd Msg )
stop model =
    case model.state of
        Playing ->
            ( { model | state = NotPlaying }
            , attemptStop model.sound
            )

        _ ->
            ( { model | state = NotPlaying }
            , Cmd.none
            )


attemptLoad : String -> Cmd Msg
attemptLoad name =
    let
        url =
            "sounds/" ++ name ++ ".m4a"
    in
        Task.attempt loadMsg (loadSound url)


loadMsg : Result String WebAudio.Sound -> Msg
loadMsg result =
    case result of
        Ok sound ->
            LoadSucceed sound

        Err error ->
            LoadFail error


loadSound : String -> Task String WebAudio.Sound
loadSound url =
    WebAudio.loadSound url


attemptPlay : Sound -> Cmd Msg
attemptPlay sound =
    case sound of
        Loaded webAudioSound ->
            Task.attempt playMsg (playSound webAudioSound)

        NotLoaded ->
            Cmd.none


playMsg : Result String WebAudio.Sound -> Msg
playMsg result =
    case result of
        Ok sound ->
            PlaySucceed sound

        Err error ->
            PlayFail error


playSound : WebAudio.Sound -> Task String WebAudio.Sound
playSound webAudioSound =
    WebAudio.playSound webAudioSound


attemptStop : Sound -> Cmd Msg
attemptStop sound =
    case sound of
        Loaded webAudioSound ->
            Task.perform StopSucceed (stopSound webAudioSound)

        NotLoaded ->
            Cmd.none


stopSound : WebAudio.Sound -> Task Never ()
stopSound webAudioSound =
    WebAudio.stopSound webAudioSound
