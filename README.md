# Voltage

Voltage is an experimental implementation of a GUI interface for `c-lightning` on macOS. It uses JSON-RPC to communicate with the daemon via a UNIX socket.

## Local Usage

Voltage requires a socket connection to an active `c-lightning` node. If you are running `c-lightning` on your local machine with the default data directory, it should "just work".

If you are using a non-standard data directory for `c-lightning`, you can use the preferences pane to change the socket path.

## Remote Usage

If you're like me and you don't have your `bitcoind` and/or `c-lightning` node on your laptop, fret not! The only thing you need to do is establish an `ssh` tunnel to your node's socket. The following command should tunnel to the socket located at `/home/user/.lightning/lightning-rpc` on your remote machine and link to a new socket on your local machine at `~/.lightning/lightning-rpc`:

    ssh -nNT -L ~/.lightning/lightning-rpc:/home/user/.lightning/lightning-rpc user@example.com

Once you've established the socket, Voltage should work. If you setup the socket in a location other than `~/.lightning/lightning-rpc` you'll need to update the "Socket Path" setting in the preferences pane.

## Contributing

Pull requests are welcome!

## License

[BSD 3-Clause](LICENSE.md)
