//
//  TabataViewController.swift
//  Tabatabata
//
//  Created by Jordane HUY on 11/04/2018.
//  Copyright © 2018 Jordane HUY. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class TabataViewController: UIViewController, FormDudeViewControllerDelegate {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var dude = Dude()
    
    var minutes = 0
    var seconds = 4
    var totalSeconds = 0
    var step = 0
    var bipTime = 0
    var timer = Timer()
    
    var bip: AVAudioPlayer?
    
    @IBOutlet var viewLeftMenu: UIView!
    @IBOutlet var label_user: UIButton!
    @IBOutlet var label_message: UILabel!
    @IBOutlet var button_launch: UIButton!
    @IBOutlet var button_edit: UIButton!
    @IBOutlet var label_total_timer: UILabel!
    @IBOutlet var button_surrender: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dude = self.appDelegate.dude
    
        self.initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDudeUpdate" {
            if let vc = segue.destination as? FormDudeViewController {
                vc.delegate = self
                vc.dude = self.dude
            }
        }
    }
    
    func initView(){
        self.label_user.setTitle(dude.firstname, for: .normal)
    }
    
    func bipSound() {
        let path = Bundle.main.path(forResource: "beep-07.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            bip = try AVAudioPlayer(contentsOf: url)
            bip?.play()
        } catch {
            print("no sound found")
        }
    }
    
    func checkMessage(){
        if minutes == 4 {
            label_message.text = "VICTOIRE !"
        } else if seconds ==  0 || seconds == 30 {
            label_message.text = "ON POUSSE"
            bipTime = 20
        } else if seconds == 20 || seconds == 50  {
            label_message.text = "ON SE REPOSE"
            bipTime = 10
        }
    }
    
    @objc func counter() {
        if step == 0 {
            var strSeconds = ""
            
            seconds -= 1
            
            if seconds > 9 {
                strSeconds = "\(seconds)"
            } else {
                strSeconds = "0\(seconds)"
            }
            
            label_total_timer.text = "00:\(strSeconds)"
            
            self.bipSound()

            // begin real timer
            if seconds == 0 {
                step = 1
                self.checkMessage()
            }
        } else {
            var strMinutes = ""
            var strSeconds = ""
            
            seconds += 1
            totalSeconds += 1
            bipTime -= 1
            
            if bipTime <= 3 {
                self.bipSound()
            }
            
            if seconds == 60 {
                minutes += 1
                seconds = 0
            }
            
            self.checkMessage()
            
            if minutes > 9 {
                strMinutes = "\(minutes)"
            } else {
                strMinutes = "0\(minutes)"
            }
            
            if seconds > 9 {
                strSeconds = "\(seconds)"
            } else {
                strSeconds = "0\(seconds)"
            }
            
            label_total_timer.text = "\(strMinutes):\(strSeconds)"
            
            // End of tabata
            if minutes == 4 {
                timer.invalidate()
            }
        }
    }

    @IBAction func launchTabata(sender: UIButton) {
        self.button_launch.isHidden = true
        self.button_edit.isHidden = true
        self.button_surrender.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.label_total_timer.frame.origin.y = (self.view.frame.size.height / 2) - (self.label_total_timer.frame.size.height / 2)
        }, completion: { (finished: Bool) in
            self.label_message.isHidden = false
            
            UIView.animate(withDuration: 0.5, animations: {
                self.label_message.alpha = 1
                self.button_surrender.alpha = 1
            }, completion: { (finished: Bool) in
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TabataViewController.counter), userInfo: nil, repeats: true)
            })
        })
    }
    
    @IBAction func surrenderTabata(_ sender: Any) {
        self.timer.invalidate()

        UIView.animate(withDuration: 0.5, animations: {
            self.label_message.alpha = 0
            self.button_surrender.alpha = 0

            self.label_total_timer.frame.origin.y = 90
        }, completion: { (finished: Bool) in
            self.label_message.isHidden = true
            self.button_surrender.isHidden = true
            
            self.button_launch.isHidden = false
            self.button_edit.isHidden = false
            
            UIView.animate(withDuration: 0.5, animations: {
                
            }, completion: { (finished: Bool) in
                self.label_total_timer.text = "00:00"
                self.seconds = 4
                self.minutes = 0
                self.totalSeconds = 0
                self.bipTime = 0
                self.step = 0
                self.label_message.text = "Début dans :"
            })
        })
    }
    
    @IBAction func openLeftMenu(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.viewLeftMenu.frame.size.width = 160;
        }, completion: nil)
    }
    
    @IBAction func closeLeftMenu(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.viewLeftMenu.frame.size.width = 0;
        }, completion: nil)
    }
    
    @IBAction func disconnect(_ sender: Any) {
        self.closeLeftMenu(self)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    // MARK: - FormDudeViewControllerDelegate protocol
    
    func didSaveDude(sender: FormDudeViewController, dude: Dude) {
        print(dude)
        initView()
    }
}
