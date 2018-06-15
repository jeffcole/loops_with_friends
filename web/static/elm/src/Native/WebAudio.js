var _jeffcole$loops$Native_WebAudio = function() {


  var Task = _elm_lang$core$Native_Scheduler;


  window.AudioContext = window.AudioContext || window.webkitAudioContext;
  var context = new AudioContext();

  // Unlock the context on mobile devices.
  window.addEventListener('touchend', function() {
  	var buffer = context.createBuffer(1, 1, 22050);
  	var source = context.createBufferSource();
  	source.buffer = buffer;

  	source.connect(context.destination);

    if (source.start) {
      source.start(0);
    } else if (source.play) {
      source.play(0);
    } else if (source.noteOn) {
      source.noteOn(0);
    }

  }, false);


  function loadSound(sourcePath) {
    return Task.nativeBinding(function (callback) {

      var request = new XMLHttpRequest();
      request.open('GET', sourcePath, true);
      request.responseType = 'arraybuffer';

      request.onload = function() {
        context.decodeAudioData(
          request.response,

          function (buffer) {
            var bufferSource = context.createBufferSource();
            bufferSource.buffer = buffer;

            var elmSound = {
              ctor: 'Sound',
              src: sourcePath,
              bufferSource: bufferSource
            };

            callback(Task.succeed(elmSound));
          },

          function() {
            callback(Task.fail('Decode error'));
          }
        );
      };

      request.send();
    });
  }


  function playSound(sound) {
    return Task.nativeBinding(function (callback) {
      // `start` may be called on a buffer source only once, thus we return a
      // new one with each call to `playSound`.
      // https://developer.mozilla.org/en-US/docs/Web/API/AudioBufferSourceNode
      var bufferSource = context.createBufferSource();
      bufferSource.buffer = sound.bufferSource.buffer;

      var gainNode = context.createGain();
      bufferSource.connect(gainNode);
      gainNode.connect(context.destination);
      gainNode.gain.value = 0.05;

      bufferSource.start(0);

      sound.bufferSource = bufferSource;

      callback(Task.succeed(sound));
    });
  }


  function stopSound(sound) {
    return Task.nativeBinding(function (callback) {
      sound.bufferSource.stop();

      callback(Task.succeed());
    });
  }


  return {
    loadSound: loadSound,
    playSound: playSound,
    stopSound: stopSound
  };
}();
