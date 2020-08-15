// module WebRTC.RTCPeerConnection

exports._addTrack = function(conn) {
    return function(track) {
        return function(stream) {
            return function() {
                return conn.addTrack(track, stream);
            }
        }
    }
}

exports._createAnswer = function(conn) {
    return function() {
        return conn.createAnswer();
    }
}

exports._createOffer = function(conn) {
    return function(options) {
        return function() {
            return conn.createOffer(options);
        }
    }
}

exports._generateCertificate = function(configuration) {
    return function() {
        return RTCPeerConnection.generateCertificate(config)
    }
}

exports._newRTCPeerConnection = function(configuration) {
    return function() {
        var conn = new RTCPeerConnection(configuration);
        return conn;
    }
}

exports._setLocalDescription = function(conn) {
    return function(description) {
        return function() {
            return conn.setLocalDescription(description);
        }
    }
}

exports._setRemoteDescription = function(conn) {
    return function(description) {
        return function() {
            return conn.setRemoteDescription(description);
        }
    }
}

exports._addIceCandidate = function(conn) {
    return function(candidate) {
        return function() {
            return conn.addIceCandidate(new RTCIceCandidate(candidate));
        }
    }

}
