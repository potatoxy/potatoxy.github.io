function FindProxyForURL(url, host) {
    var block = [
        "skinrave.gg",
        "bloxgame.com",
        "bloxflip.com"
    ];
    for (var i = 0; i < block.length; i++) {
        if (shExpMatch(host, block[i]) || dnsDomainIs(host, block[i])) {
            return "PROXY potatoxy.github.io:443";
        }
    }
    return "DIRECT";
}
