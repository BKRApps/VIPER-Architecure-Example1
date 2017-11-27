//
//  ListViewController.swift
//  MindGame
//
//  Created by Kumar Birapuram on 05/06/17.
//  Copyright © 2017 KRiOSApps. All rights reserved.
//

import UIKit
import SDWebImage

let MindGameCellIdentifier="mindGameCell"
let MaxImages=9
let GameTimeInterval:TimeInterval=15

class ListViewController: UIViewController,ListViewInterface {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var randomImage: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!

    var eventHandler:ListModuleInterface?
    var models:[MindGameModel]=[MindGameModel]()
    var randomModel:MindGameModel?
    var downloadedImages:Int=0
    var gameTimer:Timer?
    var remainingTimeInteraval:TimeInterval=0.0
    var noOfAttempts:Int=0
    
    var countableQueue=DispatchQueue(label: "com.myntra.downloadImageCount")
    override func viewDidLoad() {
        super.viewDidLoad()
        progressLabel.text="downloading the images..."
        eventHandler?.getImages(maxImages: MaxImages)
    }
}

extension ListViewController{
    func postMindGameModels(models: [MindGameModel]?, error: MTAppError?) {
        if let mdls=models{
            self.models=mdls
            DispatchQueue.main.async {[weak self] ()->() in
                self?.collectionView.reloadData()
            }
        }else if let e=error{
            print("unable to download the images \(e.getErrorMessage())")
            eventHandler?.getImages(maxImages: 9)
        }
    }
    
    func postRandomNumber(randomNumber: Int) {
        DispatchQueue.main.async {
            if let url=URL(string:self.models[randomNumber].imageUrl){
                self.randomImage.sd_setImage(with: url){ [weak self] (image,error,cacheType,url) -> () in
                    if let e=error{
                        print(e.localizedDescription)
                    }else{
                        self?.randomModel=self?.models[randomNumber]
                    }
                }
            }
        }
    }
    
    func validatedSelection(isValidated: Bool,isGameOver:Bool) {
        DispatchQueue.main.async {
            self.noOfAttempts=self.noOfAttempts+1
            if isValidated {
                self.collectionView.reloadData()
                if isGameOver{
                    self.progressLabel.text="game over. total attempts \(self.noOfAttempts)"
                    self.randomImage.isHidden=true
                    self.randomModel=nil
                }else{
                    self.eventHandler?.getRandomNumber(models: self.models, limit: MaxImages-1)
                }
            }else{
                print("wrong answer. please choose proper one")
            }
        }
    }
}

extension ListViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: MindGameCellIdentifier, for: indexPath) as! MindGameCell
        let model=models[indexPath.row]
        if model.showImage,let url=URL(string:model.imageUrl) {
            cell.imgView.setShowActivityIndicator(true)
            cell.imgView.setIndicatorStyle(.gray)
            cell.imgView.sd_setImage(with: url){[weak self](image,error,cacheType,url)->() in
                if let e=error{
                    print("unable to download the image with error \(e.localizedDescription)")
                }else{
                    self?.countableQueue.sync {()->() in
                        self?.downloadedImages=(self?.downloadedImages)!+1
                        if (self?.downloadedImages)!==MaxImages{
                            self?.startTimer()
                        }
                    }
                }
            }
        }else{
            cell.imgView.image=UIImage(named: model.quizImage)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedModel=models[indexPath.row]
        if let rModel=randomModel{
            eventHandler?.validateSelection(randomModel: rModel, against: selectedModel,models: models)
        }
    }
}

extension ListViewController{
    override func viewWillLayoutSubviews() {
        if self.models.count > 1 {
            collectionViewHeight.constant=collectionView.contentSize.height
            view.layoutIfNeeded()
        }
    }
}

extension ListViewController{
    func startTimer(){
        gameTimer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update(timer:)), userInfo: nil, repeats: true)
    }
    
    func update(timer:Timer){
        if remainingTimeInteraval==GameTimeInterval, let gTimer=gameTimer{
            progressLabel.text="game is in progress..."
            gTimer.invalidate()
            for model in models{
                model.showImage=false
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.eventHandler?.getRandomNumber(models: self.models, limit: MaxImages-1)
            }
        }else{
            progressLabel.text="game starts in \(GameTimeInterval-remainingTimeInteraval) seconds"
            remainingTimeInteraval=remainingTimeInteraval+1
        }
    }
}
