/* Media Recorder */
exports._newMediaRecorder = function(stream) {
    return function() {
        /* TODO: make this actual options */
        var options = {
            mimeType: 'video/webm'
        };
        return new MediaRecorder(stream, options);
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
