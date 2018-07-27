# Voltage

The only wallet with a HODL button.

Voltage is a GUI for `c-lightning` on macOS.

If you've got a `c-lightning` node and a Mac, then this project *might* be of remote interest to **you**!

## Current Status

I haven't built any binaries yet, so if you want to try it out you'll need to open the project in Xcode and build it from there.

Right now Voltage has five tabs:

- Money - Send and receieve on-chain Bitcoin, create new lightning invoices
- Invoices - Corresponds to `lightning-cli listinvoices`
- Payments - Corresponds to `lightning-cli listpayments`
- Peers - Corresponds to `lightning-cli listpeers`
- Channels - Corresponds to `lightning-cli listchannels`
- Info - Corresponds to `lightning-cli getinfo`

Please be aware that there are no confirmations when you send or receive testnet Bitcoin. Just hit the reload button after the next block is found and your balances will be updated.

### Short Term Goals

- [X] Receive on-chain payments
- [X] Send on-chain payments
- [ ] Open lightning channels
- [ ] Close lightning channels
- [X] Create lightning invoices
- [ ] Pay lightning invoices
- [X] Make all of the lists sortable
- [ ] Integrate [CoreBitcoin](https://github.com/oleganza/CoreBitcoin)
- [X] Getinfo from the "About Voltage" menu item maybe?
- [X] Make RPC calls in a background thread
- [X] Use `NotificationCenter` to handle RPC errors
- [ ] Pre-load all tables when application launches (meh)
- [X] Pre-load receiving address for "Get Money" button
- [ ] Validate lightning invoices
- [ ] ~~Use a single socket instance for all RPC calls~~ bad idea
- [ ] Remove `Faker` as a dependency in the Voltage target. It should only be required in tests.
- [ ] Figure out code signing
- [ ] Store transaction data locally (meh)

## Usage

### Local

Voltage requires an active `c-lightning` node. If you are running `c-lightning` on your Mac, the default settings should work for you.

If you are using a non-standard data directory for `c-lightning`, you can use the preferences pane to change the socket path.

### Remote

If you're like me and you don't have  `bitcoind` and/or `c-lightning` on your laptop, fret not! Just setup an `ssh` tunnel to your node's socket.

The following command will tunnel to the socket located at `/home/user/.lightning/lightning-rpc` on your remote machine and link to a new socket on your local machine at `~/.lightning/lightning-rpc`:

    ssh -nNT -L ~/.lightning/lightning-rpc:/home/user/.lightning/lightning-rpc user@example.com

Once you've established the socket, Voltage should work. If you setup the socket in a location other than `~/.lightning/lightning-rpc` you'll need to update the "Socket Path" setting in the preferences pane.

## Errors

Common RPC errors include:

### Error code: -9988(0x-2704), No such file or directory

The path to the `c-lightning` socket as defined in Preferences does not lead to a file.

### Error code: -9988(0x-2704), Connection refused

Voltage found the socket, but the connection was refused. This usually happens if you are using an ssh tunnel to connect to `c-lightning` and the session gets disconnected.

### Voltage.SocketError.no_response

The RPC query was sent, but zero bytes of data came back over the wire. Check to make sure `c-lightning` is running.

## Contributing

Pull requests are welcome! Criticism encouraged!

## License

[BSD 3-Clause](LICENSE.md)
