// module WebRTC.MediaStreamTrack

exports._stop = function(track) {
    return function() {
        track.stop();
    }
}
