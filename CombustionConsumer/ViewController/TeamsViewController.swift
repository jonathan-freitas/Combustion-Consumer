//
//  TeamsViewController.swift
//  CombustionConsumer
//
//  Created by Jonathan Freitas on 04/12/18.
//  Copyright © 2018 Jonathan Freitas. All rights reserved.
//

import UIKit

class TeamsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - Properties
    var times = [Time]()
    internal let rcFable = UIRefreshControl()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        RXPlayground().play()
        super.viewDidLoad()
        self.collectionView.register(UINib.init(nibName: "TeamCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TeamCollectionViewCell")
        setupRefreshControl()
        receiveCollectionViewData()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupRefreshControl() {
        collectionView.refreshControl = rcFable
        rcFable.addTarget(self, action: #selector(refreshCollectionData(_:)), for: .valueChanged)
        rcFable.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        rcFable.attributedTitle = NSAttributedString(string: "Fetching Data ...")
    }
    
    @objc private func refreshCollectionData(_ sender: Any) {
        // Refreshes the Collection View
        self.rcFable.beginRefreshing()
        receiveCollectionViewData()
    }
    
    private func receiveCollectionViewData() {
        CombustionConsumer().receiveDataTimes(url: Constants.baseURL + RouterRoute.teams.name){ callback in
            switch callback {
            case .success(let arrayTime):
                self.times = arrayTime
                self.collectionView.reloadData()
                break
            case .error(let errorMessage):
                print("Error message: \(errorMessage)")
                break
            }
            self.rcFable.endRefreshing()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return times.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCollectionViewCell", for: indexPath) as! TeamCollectionViewCell
        
        // Configure the cell
        cell.configuration(team: times[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let time = times[indexPath.row]
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        newViewController.team = time
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
}

extension TeamsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spaceBetweenCell :CGFloat = 4.0
        let screenWidth = UIScreen.main.bounds.size.width - CGFloat(2 * spaceBetweenCell)
        let totalSpace = spaceBetweenCell * 1.0;
        
        if indexPath.row == (times.count - 1)  {
            if times.count % 2 == 1 {
                return CGSize(width: screenWidth, height: (screenWidth-totalSpace)/2)
            } else {
                return CGSize(width: (self.view.frame.size.width/2) - 15, height: (self.view.frame.size.width/2) - 15)
            }
        } else {
            return CGSize(width: (self.view.frame.size.width/2) - 15, height: (self.view.frame.size.width/2) - 15)
        }
    }
}
