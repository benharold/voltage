# Voltage

Voltage is an experimental implementation of a GUI interface for `c-lightning` on macOS. It uses JSON-RPC to communicate with the daemon via a UNIX socket.

## Current Status

Voltage is functional! It's still very rough around the edges, but you can use it to view a list of payments and channels. The channels tab in particular can take quite a while to load, as the `listchannels` RPC call can be rather heafty and RPC calls are (currently) blocking the main thread.

I haven't built any binaries yet, so if you want to try it out you'll need to open the project in Xcode and build it from there.

### Short Term Goals

- [X] Payment list
- [X] Channel list
- [X] Format this list better
- [ ] Receive on-chain payments
- [ ] Send on-chain payments
- [ ] Open lightning channels
- [ ] Close lightning channels
- [ ] Getinfo from the "About Voltage" menu item maybe?
- [ ] Make RPC calls in a background thread

## Usage

### Local

Voltage requires a socket connection to an active `c-lightning` node. If you are running `c-lightning` on your local machine with the default data directory, it should "just work".

If you are using a non-standard data directory for `c-lightning`, you can use the preferences pane to change the socket path.

### Remote

If you're like me and you don't have your `bitcoind` and/or `c-lightning` node on your laptop, fret not! The only thing you need to do is establish an `ssh` tunnel to your node's socket. The following command should tunnel to the socket located at `/home/user/.lightning/lightning-rpc` on your remote machine and link to a new socket on your local machine at `~/.lightning/lightning-rpc`:

    ssh -nNT -L ~/.lightning/lightning-rpc:/home/user/.lightning/lightning-rpc user@example.com

Once you've established the socket, Voltage should work. If you setup the socket in a location other than `~/.lightning/lightning-rpc` you'll need to update the "Socket Path" setting in the preferences pane.

## Contributing

Pull requests are welcome!

## License

[BSD 3-Clause](LICENSE.md)
