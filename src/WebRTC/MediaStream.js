// module WebRTC.MediaStream

export const _getTracks = function(stream) {
    return function() {
        return stream.getTracks();
    }
}

export const _getUserMedia = function(constraints) {
    return function() {
        return navigator.mediaDevices.getUserMedia(constraints);
    }
}
