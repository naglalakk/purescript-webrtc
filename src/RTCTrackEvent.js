exports._streams = function(rtcTrackEvent) {
    return function() {
        return rtcTrackEvent.streams;
    }
}
