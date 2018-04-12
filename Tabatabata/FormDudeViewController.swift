//
//  FormDudeViewController.swift
//  Tabatabata
//
//  Created by Jordane HUY on 11/04/2018.
//  Copyright © 2018 Jordane HUY. All rights reserved.
//

import UIKit

class FormDudeViewController: UIViewController {
   
    @IBOutlet var view_avatar: UIView!
    
    @IBOutlet var text_lastname: UITextField!
    
    @IBOutlet var text_firstname: UITextField!
    
    @IBOutlet var blocMan: UIView!
    @IBOutlet var blocWoman: UIView!
    @IBOutlet var blocRobot: UIView!
    
    var gender = 0
    var picture = ""
    
    var dude = Dude()
    
    weak var delegate:FormDudeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view_avatar.layer.cornerRadius = 55
        
        //Gesture gender
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.selectMan(sender:)))
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(self.selectWoman(sender:)))
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.selectRobot(sender:)))
        
        self.blocMan.addGestureRecognizer(gesture)
        self.blocWoman.addGestureRecognizer(gesture1)
        self.blocRobot.addGestureRecognizer(gesture2)
        
        initView()
    }
    
    func initView(){
        self.text_lastname.text = dude.lastname
        self.text_firstname.text = dude.firstname
        
        gender = dude.gender
        
        if dude.gender == 0 {
            self.blocMan.alpha = 1;
            self.blocWoman.alpha = 0.5;
            self.blocRobot.alpha = 0.5;
        } else if dude.gender == 1 {
            self.blocMan.alpha = 0.5;
            self.blocWoman.alpha = 1;
            self.blocRobot.alpha = 0.5;
        } else if dude.gender == 2 {
            self.blocMan.alpha = 0.5;
            self.blocWoman.alpha = 0.5;
            self.blocRobot.alpha = 1;
        }
        print(dude)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissForm(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func validForm(_ sender: Any) {
        var isError = false;
        
        if (self.text_lastname.text ?? "").isEmpty {
            isError = true
        }
        
        if (self.text_firstname.text ?? "").isEmpty {
            isError = true
        }
        
        if !isError {
            // Query Realm
            let dudeDao:DudeDAO = DudeDAO();
            
            // Create new dude
            let dudeToCreate = Dude()
            
            dudeToCreate.lastname = self.text_lastname.text!
            dudeToCreate.firstname = self.text_firstname.text!
            dudeToCreate.gender = self.gender
            
            if !dude.id.isEmpty {
                dudeToCreate.id = dude.id
                
                dudeDao.updateDude(dude: dudeToCreate)
            } else {
                dudeDao.createDude(dude: dudeToCreate)
            }
            
            // Delegate to ViewController
            delegate?.didSaveDude(sender: self, dude: dudeToCreate)
            
            dismiss(animated: true, completion: nil)

        }
    }
    
    @objc func selectMan(sender:UITapGestureRecognizer){
        gender = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.blocMan.alpha = 1;
            self.blocWoman.alpha = 0.5;
            self.blocRobot.alpha = 0.5;
        }, completion: nil)
    }
    
    @objc func selectWoman(sender:UITapGestureRecognizer){
        gender = 1
        
        UIView.animate(withDuration: 0.3, animations: {
            self.blocMan.alpha = 0.5;
            self.blocWoman.alpha = 1;
            self.blocRobot.alpha = 0.5;
        }, completion: nil)    }
    
    @objc func selectRobot(sender:UITapGestureRecognizer){
        gender = 2
        
        UIView.animate(withDuration: 0.3, animations: {
            self.blocMan.alpha = 0.5;
            self.blocWoman.alpha = 0.5;
            self.blocRobot.alpha = 1;
        }, completion: nil)    }
}

protocol FormDudeViewControllerDelegate: class {
    func didSaveDude(sender: FormDudeViewController, dude: Dude)
}
