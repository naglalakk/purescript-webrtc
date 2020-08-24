// module WebRTC.MediaStream

exports._getTracks = function(stream) {
    return function() {
        return stream.getTracks();
    }
}

exports._getUserMedia = function(constraints) { 
    return function() {
        return navigator.mediaDevices.getUserMedia(constraints);
    }
}
