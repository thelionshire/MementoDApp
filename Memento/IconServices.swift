//
//  IconServices.swift
//  Memento
//
//  Created by Russ (thelionshire) on 5/25/20.
//  Copyright © 2020 Ubik Capital. All rights reserved.
//
import Foundation
import ICONKit
import BigInt

// ICON services required for app
class IconServices{
  
  static let shared = IconServices()
  //let iconService = ICONService(provider: "https://ctz.solidwallet.io/api/v3", nid: "0x1") // mainnet
  let iconService = ICONService(provider: "https://bicon.net.solidwallet.io/api/v3", nid: "0x3") // testnet
  let myPassword = "iconpassword"  // default password for testing, TODO change to allow user to input
  var wallet: Wallet!
  var myBalance: Double!
  var myAddress: String!
  
  init() {
    do{
      // Set path for keystore and load keystore
      let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
      let url = NSURL(fileURLWithPath: path)
      let jsonData = try Data(contentsOf: url.appendingPathComponent("iconkeystore")!)
      
      // decode key using pw (not secure right now in test phase (auto created))
      let decoder = JSONDecoder()
      let keystore = try decoder.decode(Keystore.self, from: jsonData)
      self.wallet = try Wallet(keystore: keystore, password: myPassword)
      self.myBalance = updateBalance()
      self.myAddress = self.wallet.address
    }catch  {
      // handle errors
      self.myBalance = 0.0
      print(error.localizedDescription)
    }
  }
  
// function to get balance and update in app
  func updateBalance() -> Double {
  let result = iconService.getBalance(address: wallet.address).execute()
    
    switch result {
    case .success(let balance):
      let newBalance = balance / BigUInt(100000000000000)
      let doubleBalance = Double(newBalance)
      let thisBalance = doubleBalance/10000.0
      self.myBalance = thisBalance
      return thisBalance
  
    case .failure(let error):
      // handle errors
      print(error.localizedDescription)
      return 0.0
    }
  }

// function to perform transaction to upload data to chain
    func loadImage(base64ImageString : String) -> String{
        do{
            // create message upload transaction (send to same wallet as user)
          let messageUpload = MessageTransaction()
            .from(wallet.address)
            .to(wallet.address)
            .stepLimit(BigUInt(100000000))
            .nonce("0x1")
            .nid(self.iconService.nid)
            //.dataType?.hexEncodedString()
            //.data
            //.data(base64ImageString)
            //.data(base64ImageString)
            .message(base64ImageString)
          // sign transaction and send
          let signed = try SignedTransaction(transaction: messageUpload, privateKey: wallet.key.privateKey)
          let wrequest = iconService.sendTransaction(signedTransaction: signed)
          let wresponse = wrequest.execute()
          // print respond for debugging
          print(wresponse)
          let responseHash = try! wresponse.get()
            _ = self.updateBalance()
          // return hash for user to see
          return responseHash
        } catch {
            _ = self.updateBalance()
          return "none"
        }
        
    }
  
}

