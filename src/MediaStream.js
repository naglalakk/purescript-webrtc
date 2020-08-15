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

/* Media Recorder */
exports._newMediaRecorder = function(stream) {
    return function() {
        return new MediaRecorder(stream);
    }
}

exports.pause = function(recorder) {
    return function() {
        recorder.pause();
    }
}

exports.requestData = function(recorder) {
    return function() {
        recorder.requestData();
    }
}

exports.resume = function(recorder) {
    return function() {
        recorder.resume();
    }
}

exports.start = function(recorder) {
    return function() {
        recorder.start();
    }
}

exports.stop = function(recorder) {
    return function() {
        recorder.stop();
    }
}

exports._setSrcObject = function(element) {
    return function(stream) {
        return function() {
            element.srcObject = stream;
        }
    }
}
