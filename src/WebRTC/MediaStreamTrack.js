// module WebRTC.MediaStreamTrack

export const _stop = function(track) {
    return function() {
        track.stop();
    }
}
