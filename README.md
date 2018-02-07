# Voltage

The only wallet with a HODL button.

Voltage is an experimental implementation of a GUI for `c-lightning` on macOS. It uses JSON-RPC to communicate with the daemon via a UNIX socket.

If you've got a `c-lightning` node and a Mac, then this project *might* be of remote interest to _you_!

## Current Status

This is pre-alpha software. Everything is done in the main thread, so the interface lags a bit when you click tabs or buttons which make RPC calls. The channels tab in particular can take quite a while to load, as the `listchannels` RPC call can be rather heafty.

I haven't built any binaries yet, so if you want to try it out you'll need to open the project in Xcode and build it from there.

Right now Voltage has five tabs:

- Money - Send and receieve on-chain testnet Bitcoin
- Invoices - Corresponds to `lightning-cli listinvoices`
- Payments - Corresponds to `lightning-cli listpayments`
- Peers - Corresponds to `lightning-cli listpeers`
- Channels - Corresponds to `lightning-cli listchannels`

Please be aware that there are no confirmations when you send or receive testnet Bitcoin. Also, there's currently no way to re-run RPC calls except on the payments tab. Like I said, pre-alpha.

### Short Term Goals

- [X] Payment list
- [X] Channel list
- [X] Invoices list
- [X] Peers list
- [X] Receive on-chain payments
- [X] Send on-chain payments
- [ ] Open lightning channels
- [ ] Close lightning channels
- [ ] Create lightning invoices
- [ ] Pay lightning invoices
- [ ] Make all of the lists sortable
- [ ] Integrate [CoreBitcoin](https://github.com/oleganza/CoreBitcoin)
- [ ] Getinfo from the "About Voltage" menu item maybe?
- [ ] Make RPC calls in a background thread
- [ ] Use `NotificationCenter` to handle RPC errors

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
