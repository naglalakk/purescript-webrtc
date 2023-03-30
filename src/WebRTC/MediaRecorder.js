/* Media Recorder */
export const _newMediaRecorder = function(stream) {
    return function() {
        /* TODO: make this actual options */
        var options = {
            mimeType: 'video/webm'
        };
        return new MediaRecorder(stream, options);
    }
}

export const pause = function(recorder) {
    return function() {
        recorder.pause();
    }
}

export const requestData = function(recorder) {
    return function() {
        recorder.requestData();
    }
}

export const resume = function(recorder) {
    return function() {
        recorder.resume();
    }
}

export const start = function(recorder) {
    return function() {
        recorder.start();
    }
}

export const stop = function(recorder) {
    return function() {
        recorder.stop();
    }
}
