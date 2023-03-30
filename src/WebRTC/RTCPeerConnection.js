// module WebRTC.RTCPeerConnection

export const _addTrack = function(conn) {
    return function(track) {
        return function(stream) {
            return function() {
                return conn.addTrack(track, stream);
            }
        }
    }
}

export const _createAnswer = function(conn) {
    return function() {
        return conn.createAnswer();
    }
}

export const _createOffer = function(conn) {
    return function(options) {
        return function() {
            return conn.createOffer(options);
        }
    }
}

export const _generateCertificate = function(configuration) {
    return function() {
        return RTCPeerConnection.generateCertificate(config)
    }
}

export const _newRTCPeerConnection = function(configuration) {
    return function() {
        var conn = new RTCPeerConnection(configuration);
        return conn;
    }
}

export const _setLocalDescription = function(conn) {
    return function(description) {
        return function() {
            return conn.setLocalDescription(description);
        }
    }
}

export const _setRemoteDescription = function(conn) {
    return function(description) {
        return function() {
            return conn.setRemoteDescription(description);
        }
    }
}

export const _addIceCandidate = function(conn) {
    return function(candidate) {
        return function() {
            return conn.addIceCandidate(new RTCIceCandidate(candidate));
        }
    }

}

export const _close = function(conn) {
    return function() {
        conn.close();
    }
}

export const _iceConnectionState = function(conn) {
    return function() {
        return conn.iceConnectionState;
    }
}

export const _candidateFromString = function(candidateStr) {
    return function() {
        return JSON.parse(candidateStr);
    }
}

