//
//  ViewController.swift
//  AlamofireSwiftProtobufExt
//
//  Created by appdev on 2018/3/16.
//  Copyright © 2018年 opz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftProtobuf

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO:
        let url = "YOURS_URL";
        
        var rqst = CSMsgRequest()
        rqst.req = "test"
        
        let rqstCoding = AlamofirePBDataEncoding(msg: rqst)
        
        Alamofire.request(url, method: .post, parameters: [:], encoding: rqstCoding, headers: [:]).responsePBCsmsg { (rsp) in
            if let error = rsp.result.error {
                print("fail", error.localizedDescription )
                return;
            }
            if let obj: CSMsgRespond = rsp.result.value {
                print("success", obj )
            } else {
                print("fail to get rsp obj")
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

