//
//  ViewController.swift
//  TalkAI
//
//  Created by HsiaoHsien Huang on 2018/7/30.
//  Copyright © 2018年 HsiaoHsien Huang. All rights reserved.
//

import UIKit
import ApiAI

class ViewController: UIViewController {

/*
     因為要使用AI,所以先import ApiAI
     把提問的textfield設成questionsMessage
     把ai回復的textview設成answersTextView
     當問題問完，需要個button把問題丟出去，所以把button設成sendMessage
*/
    @IBOutlet weak var questionsMessage: UITextField!
    @IBOutlet weak var answersTextView: UITextView!
    @IBAction func sendMessage(_ sender: UIButton) {
        
        let request = ApiAI.shared().textRequest()
        
        if let text = questionsMessage.text, text != "" {
            request?.query = text
        } else {
            return
        }
       //上面這段是先確認問題輸入框內是有字元，然後才把問題的內容丟給api.AI裡的function去處理
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            if let textResponse = response.result.fulfillment.speech {
                self.answersTextView.text = textResponse
            }
        }, failure: { (request, error) in
            print(error!)
        })
        //上面這段是把api.AI回傳回來的內容顯示在textview裡
        
        ApiAI.shared().enqueue(request)
        questionsMessage.text = ""
        //上面這段是把問題丟出後，會將提問的字清除，以方便輸入下個問題
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //上面這個function是ai回覆的textview會被鍵盤擋住
    //所以這個功能是當輸入完問題後，可以點擊一下畫面上其它地方，然後會把鍵盤收起來。
    //在實作這個功能之前，要先在提問的textfield上點右鍵，與delegate做連結。
}

