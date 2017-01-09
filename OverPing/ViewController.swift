//
//  ViewController.swift
//  OverPing
//
//  Created by Nevyn Bengtsson on 1/8/17.
//  Copyright © 2017 Nevyn Bengtsson. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, PingDelegate {

    var pings : [Ping] = []
    var timer : Timer?
    @IBOutlet var tableView : NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(performNewPing), userInfo: nil, repeats: true)
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int
    {
        return pings.count;
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        return tableView.make(withIdentifier: "PingCell", owner: self)
    }

    
    func tableView(_ tableView: NSTableView, didAdd rowView: NSTableRowView, forRow row: Int)
    {
        let cell = rowView.view(atColumn: 0) as! PingCell
        let ping = pings[row]
        cell.pingView.startPing()
        configurePing(cell, ping)
    }
    
    func configurePing(_ cell: PingCell, _ ping: Ping)
    {

        if let time = ping.secs {
            cell.pingView.pongReceived(time: time)
            
            let str = time < 1 ? "\(Int(time * 1000.0))ms" :  NSString(format: "%.2fs", time) as String
            cell.pingText.stringValue = str
        } else if let err = ping.error {
            cell.pingText.stringValue = err.localizedDescription
            cell.pingView.error()
        } else {
            cell.pingText.stringValue = ""
        }
    }


    @objc func performNewPing()
    {
        let ping = Ping()
        ping.delegate = self
        ping.run()
        self.pings.insert(ping, at: 0)
        self.tableView.insertRows(at: IndexSet(integer:0), withAnimation: .slideDown)
    }
    
    func ping(_ ping: Ping, didFinishWithTime time: Double)
    {
        guard let idx = pings.index(of: ping) else {
            return
        }
        guard let rowView = self.tableView.rowView(atRow: idx, makeIfNecessary: false) else {
            return
        }
        guard let cell = rowView.view(atColumn: 0) as? PingCell else {
            return
        }
        configurePing(cell, ping)
    }
    
    func ping(_ ping: Ping, failedWithError err: PingError)
    {
        guard let idx = pings.index(of: ping) else {
            return
        }
        guard let rowView = self.tableView.rowView(atRow: idx, makeIfNecessary: false) else {
            return
        }
        guard let cell = rowView.view(atColumn: 0) as? PingCell else {
            return
        }

        print("ERR \(err)")
        configurePing(cell, ping)
    }
}

class PingCell : NSView
{
    @IBOutlet var pingView : PingView!
    @IBOutlet var pingText : NSTextField!
}
