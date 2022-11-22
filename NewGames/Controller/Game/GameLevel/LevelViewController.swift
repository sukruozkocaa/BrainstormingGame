//
//  LevelViewController.swift
//  Games
//
//  Created by Şükrü Özkoca on 8.11.2022.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseFirestore
import FirebaseDatabase

class LevelViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    private let levelUpView: UIView = {
        let view = UIView(frame: CGRect(x: 40, y: 800, width: 348, height: 0))
        view.isHidden = true
        view.layer.cornerRadius = 10
        view.backgroundColor = .red
        return view
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 24, y: 100, width: 300, height: 50))
        button.backgroundColor = .yellow
        button.setTitle("Next Level", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 30)
        button.addTarget(self, action: #selector(didTapButton), for: .allEvents)
        return button
    }()
    
    let levelArray = [GameLevelModel().level1,GameLevelModel().level2,GameLevelModel().level3,GameLevelModel().level4]
    
    var highScore = 0
    var ref: DatabaseReference!
    var db: Firestore!
    var imagesData : [String] = []
    var lastIndexActive: IndexPath = [1,0]
    var selectedIndex = 0
    var selectedImages: [String] = []
    var timer = Timer()
    var timerCount = 0
    var indexPath,backIndexPath : IndexPath?
    var audioPlayer: AVAudioPlayer?
    var succesCount = 0
    var levelCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        self.imagesData = levelArray[levelCount]
        view.addSubview(levelUpView)
        levelUpView.addSubview(nextButton)
        collectionView.register(UINib(nibName: "PointsCell", bundle: nil), forCellWithReuseIdentifier: "PointsCell")
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(scoreTimer), userInfo: nil, repeats: true)
    }
    
    @objc func didTapButton() {
        
        if timer.isValid == false {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(scoreTimer), userInfo: nil, repeats: true)
        }
        else {
            print("timer actif")
        }
        
        UIView.animate(withDuration: 1) {
            self.levelUpView.frame = CGRect(x: 40, y: 800, width: 348, height: 0)
            self.nextButton.frame = CGRect(x: 100, y: 200, width: 150, height: 0)
            self.nextButton.layer.opacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.levelUpView.isHidden = true
        }
        
        self.imagesData = levelArray[levelCount]
        
        collectionView.isHidden = false
        collectionView.isUserInteractionEnabled = true
        
        selectedIndex = 0
        succesCount = 0
        backIndexPath = [0,0]
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension LevelViewController: UICollectionViewDataSource, UICollectionViewDelegate  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PointsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PointsCell", for: indexPath) as! PointsCell
        cell.gameImage.image = UIImage(named: imagesData[indexPath.row])
        cell.configure(lockHidden: false, gameHidden: true)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! PointsCell
        
        collectionView.isUserInteractionEnabled = true
        
        if self.lastIndexActive != indexPath {
            
            if selectedIndex == 0 {
 
                cell.configure(lockHidden: true, gameHidden: false)
                cell.borderConfigure(isColor: true)
                selectedImages.append(imagesData[indexPath.row])
                selectedIndex += 1
                self.backIndexPath = indexPath
            }
            else if selectedIndex == 1 {
                cell.configure(lockHidden: true, gameHidden: false)
                collectionView.isUserInteractionEnabled = false
                
                if selectedImages[0] == imagesData[indexPath.row] {
                    cell.borderConfigure(isColor: true)
                    cell.isUserInteractionEnabled = false
                    positiveSound()
                    selectedIndex = 0
                    selectedImages = []
                    succesCount += 1
                    if succesCount == (imagesData.count)/2 {
                        if levelCount == levelArray.count-1 {
                            finishUserScoreAlert()
                        }
                        else {
                            levelUpView.isHidden = false
                            levelCount += 1
                             animateLevelView()
                            cell.configure(lockHidden: false, gameHidden: true)
                            collectionView.isHidden = true
                        }
                        scoreLabel.text = "Score: \(timerCount)"
                        timer.invalidate()
                    }
                    collectionView.isUserInteractionEnabled = true
                }
                else {
                    let cell2 = collectionView.cellForItem(at: backIndexPath!) as! PointsCell
                    
                    selectedImages = []
                    selectedIndex = 0
                    negativeSound()
                    
                    cell.borderConfigure(isColor: false)
                    
                    self.indexPath = indexPath
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        cell.configure(lockHidden: false, gameHidden: true)
                        cell2.configure(lockHidden: false, gameHidden: true)
                        self.collectionView.isUserInteractionEnabled = true
                    }
                }
            }
            self.lastIndexActive = indexPath
        }
    }
    
    @objc func scoreTimer() {
        timerCount += 1
        timeLabel.text = "TIME: \(timerCount)"
    }
    
    func getHighScore() {
        db.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser?.email).getDocuments { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            }
            else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        self.db.collection("UserInfo").addSnapshotListener { snapshot, error in
                            if let highscore = document.get("highScore") as? Int {
                                self.highScore = highscore
                                self.sendData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func sendData() {
        if timerCount < highScore || highScore == 0{
            db.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapshot, error in
                if error != nil {
                    print(error!.localizedDescription)
                }
                else {
                    if snapshot?.isEmpty != true && snapshot != nil {
                        for document in snapshot!.documents {
                            let documentID = document.documentID
                            self.db.collection("UserInfo").document(documentID).setData(["highScore": self.timerCount],merge: true) { error in
                                if error != nil {
                                    print(error!.localizedDescription)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func animateLevelView() {
        UIView.animate(withDuration: 0.5) {
            self.levelUpView.frame = CGRect(x: 40, y: 500, width: 348, height: 200)
            self.nextButton.frame = CGRect(x: 24, y: 100, width: 300, height: 50)
            self.nextButton.layer.opacity = 1
        }
    }
    
    func positiveSound() {
        let pathToSound = Bundle.main.path(forResource: "positive", ofType: "mp3")
        let url = URL(fileURLWithPath: pathToSound!)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func negativeSound() {
        let pathToSound = Bundle.main.path(forResource: "negative", ofType: "mp3")
        let url = URL(fileURLWithPath: pathToSound!)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print(error.localizedDescription)
        }
    }

    func finishUserScoreAlert() {
        
        let alert = UIAlertController(title: "Oyun Bitti :)", message: "Skorunuz : \(timerCount)", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
            self.getHighScore()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigationController?.popViewController(animated: true)
            }
        }
        let retryButton = UIAlertAction(title: "Retry", style: .default) { UIAlertAction in
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(okButton)
        alert.addAction(retryButton)
        self.present(alert, animated: true)
         
    }
}
