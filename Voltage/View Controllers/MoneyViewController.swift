//
//  MoneyViewController.swift
//  Voltage
//
//  Created by Ben Harold on 2/2/18.
//  Copyright © 2018 Harold Consulting. All rights reserved.
//

import Cocoa
import AVFoundation

class MoneyViewController: NSViewController {
    
    var output_list = [FundOutput]()
    
    var channel_list = [FundChannel]()
    
    var on_chain_balance: Int = 0
    
    var channel_balance: Int = 0
    
    var channel_capacity: Int = 0
    
    var audio_players = [AVAudioPlayer]()
    
    var decoder: JSONDecoder = JSONDecoder.init()
    
    @IBOutlet weak var balance_satoshis: NSTextFieldCell!
    
    @IBOutlet weak var balance_bits: NSTextFieldCell!
        
    @IBOutlet weak var balance_btc: NSTextFieldCell!
    
    @IBOutlet weak var channel_capacity_bits: NSTextField!
    
    @IBOutlet weak var channel_balance_bits: NSTextField!
    
    @IBOutlet weak var channel_receivable_bits: NSTextField!
    
    @IBAction func hodl_button(_ sender: Any) {
        instant_rap_air_horn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load_outputs()
    }
    
    func recalculate_balances() {
        calculate_on_chain_balance()
        calculate_channel_balance()
        calculate_channel_capacity()
        calculate_channel_receivable()
    }
    
    func calculate_on_chain_balance() {
        on_chain_balance = 0
        for output in output_list {
            on_chain_balance += output.value
        }
        balance_satoshis.intValue = Int32(on_chain_balance)
        balance_bits.stringValue = String(describing: Decimal(on_chain_balance) / 100)
        balance_btc.stringValue = String(describing: Decimal(on_chain_balance) / 100000000)
    }
    
    func calculate_channel_balance() {
        channel_balance = 0
        for channel in channel_list {
            channel_balance += channel.channel_sat
        }
        channel_balance_bits.stringValue = String(describing: Decimal(channel_balance) / 100)
    }
    
    func calculate_channel_capacity() {
        channel_capacity = 0
        for channel in channel_list {
            channel_capacity += channel.channel_total_sat
        }
        channel_capacity_bits.stringValue = String(describing: Decimal(channel_capacity) / 100)
    }
    
    func calculate_channel_receivable() {
        channel_receivable_bits.stringValue = String(describing: (channel_capacity_bits.floatValue - channel_balance_bits.floatValue))
    }
    
    func load_outputs() {
        let service: LightningRPCSocket = LightningRPCSocket.create()
        let listoutputs: LightningRPCQuery = LightningRPCQuery(id: Int(getpid()), method: "listfunds", params: [])
        let response: Data = service.send(query: listoutputs)
        do {
            let result: FundList = try decoder.decode(FundResult.self, from: response).result
            output_list = result.outputs
            channel_list = result.channels
        } catch {
            do {
                let error_message = try decoder.decode(ErrorResult.self, from: response).error
                print("MoneyViewController.load_outputs() RPC error: " + error_message)
            } catch {
                print("MoneyViewController.load_outputs() RPC error: \(error)")
            }
            //alert(message: "There was an error decoding the list of outputs. Is your c-lightning node running?")
            print("MoneyViewController.load_outputs() JSON decoder error: \(error)")
        }

        recalculate_balances()
    }
    
    // I have not measured the memory usage of this. I presume that since the
    // `audio_players` list is never emptied, it just continues to eat memory as
    // you mash the HODL button. Maybe someday when literally everything else in
    // the world has been done I'll make time to *look into* cleaning this up.
    func instant_rap_air_horn() {
        do {
            let sound_name = NSSound.Name(rawValue: "horn")
            if let bundle = Bundle.main.path(forSoundResource: sound_name) {
                let sound_url = URL(fileURLWithPath: bundle)
                let audio_player = try AVAudioPlayer(contentsOf: sound_url)
                audio_players.append(audio_player)
                audio_players.last?.prepareToPlay()
                audio_players.last?.play()
            }
        } catch {
            print(error)
        }
    }
    
}
