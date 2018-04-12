//
//  ViewController.swift
//  Tabatabata
//
//  Created by Jordane HUY on 22/03/2018.
//  Copyright © 2018 Jordane HUY. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, FormDudeViewControllerDelegate {
    @IBOutlet var collection_dude: UICollectionView!
    @IBOutlet var button_newDude: UIButton!
    
    let cellUser:String = "dudeCell"
    var items = [Dude]()
    let colors = [
        UIColor(red: 94.0/255.0, green:188.0/255.0, blue: 113.0/255.0, alpha: 1.0),
        UIColor(red: 77.0/255.0, green:173.0/255.0, blue: 228.0/255.0, alpha: 1.0),
        UIColor(red: 223.0/255.0, green:141.0/255.0, blue: 225.0/255.0, alpha: 1.0),
        UIColor(red: 247.0/255.0, green:209.0/255.0, blue: 68.0/255.0, alpha: 1.0)
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Init custom cell
        collection_dude.register(UINib(nibName: "CollectionViewCell_dude", bundle: nil), forCellWithReuseIdentifier: cellUser)

        beginAnimate()

        // Query Realm
        let dudeDao:DudeDAO = DudeDAO();
        self.items = dudeDao.getDudes()
        
        if items.count >= 4 {
            button_newDude.isHidden = true
        }
        
        //dudeDao.deleteAllDudes()
        
        autoResizeCollectionUsers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFormDude" {
            if let vc = segue.destination as? FormDudeViewController {
                vc.delegate = self
            }
        }
    }
    
    func beginAnimate(){
        collection_dude.isHidden = false
        collection_dude.frame.origin.x -= 50
        
        UIView.animate(withDuration: 0.5, animations: {
            self.collection_dude.alpha = 1;
            self.collection_dude.frame.origin.x += 50
        }, completion: nil)
    }
    
    func autoResizeCollectionUsers(){
        let newWidth = items.count * 150 + (items.count * 20)
        collection_dude.frame.size.width = CGFloat(newWidth)
        collection_dude.frame.origin.x = CGFloat(self.view.frame.width / 2 - self.collection_dude.frame.size.width / 2)
        collection_dude.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell:CollectionViewCell_dude = collectionView.dequeueReusableCell(withReuseIdentifier: cellUser, for: indexPath as IndexPath) as! CollectionViewCell_dude
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        
        let dude = items[indexPath.row]
        
        cell.labelName.text = "\(dude.firstname) \(dude.lastname)"
        cell.labelAA.text = "\(dude.firstname.prefix(1)) \(dude.lastname.prefix(1))"
        cell.setViewColor(color: colors[indexPath.row])
        

        //cell.labelName.text = self.items[indexPath.row]

        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.dude = self.items[indexPath.row]
        
        performSegue(withIdentifier: "segueMain", sender: nil)

    }
    
    // MARK: - FormDudeViewControllerDelegate protocol

    func didSaveDude(sender: FormDudeViewController, dude: Dude) {
        print(dude)
        self.items.append(dude)
        
        if items.count >= 4 {
            button_newDude.isHidden = true
        }
        
        autoResizeCollectionUsers()
    }
}

