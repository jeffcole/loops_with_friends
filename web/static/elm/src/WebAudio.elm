module WebAudio exposing (..)

import Task
import Native.WebAudio


type Sound
    = Sound


loadSound : String -> Task.Task String Sound
loadSound =
    Native.WebAudio.loadSound


playSound : Sound -> Task.Task String Sound
playSound =
    Native.WebAudio.playSound


stopSound : Sound -> Task.Task Never ()
stopSound =
    Native.WebAudio.stopSound
