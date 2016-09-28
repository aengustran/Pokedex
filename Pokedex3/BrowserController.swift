//
//  ViewController.swift
//  Pokedex3
//
//  Created by Aengus Tran on 27/9/16.
//  Copyright © 2016 Aengus Tran. All rights reserved.
//

import UIKit
import AVFoundation

class BrowserController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UISearchBarDelegate, UIScrollViewDelegate {

    @IBOutlet var detailView: DetailView!
    @IBOutlet var blackView: UIView!

    
    @IBOutlet weak var pokemonCollectionView: UICollectionView!
    @IBOutlet weak var musicBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!

    var pokemonArray = [Pokemon]()
    var searchedPokemonArray = [Pokemon]()
    var inSearchMode: Bool = false
    var musicPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        PokemonAPIParser(pokemonIdentifier: 1) { 
            print("sucess")
        }

        // SET UP DATA SOURCE AND DELEGATE
        parsePokemonCSV()
        initAudio()
        musicPlayer.pause()
        pokemonCollectionView.dataSource = self
        pokemonCollectionView.delegate = self
        searchBar.delegate = self
        scrollView.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        pokemonCollectionView.reloadData()

    }


    // PARSING THE POKEMON>CSV FILE INTO THE POKEMON ARRAY
    func parsePokemonCSV() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows

            for eachRow in rows {
                let pokemonID = Int(eachRow["id"]!)!
                let name = eachRow["identifier"]!
                pokemonArray.append(Pokemon(name: name, pokedexID: pokemonID))
            }

        }catch{

        }
    }


    // SETTING UP THE CELL
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {


        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCellViewIdentifier", for: indexPath) as? PokemonCellView {

            if inSearchMode {
                cell.configureCell(searchedPokemonArray[indexPath.row])
            } else {
                cell.configureCell(pokemonArray[indexPath.row])
            }

            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    

    // EXECUTE WHEN A COLLECTION CELL IS SELECTED
    let scrollView = UIScrollView()
    let height: CGFloat = 500
    let width: CGFloat = 350
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        var selectedPokemon: Pokemon!

        if inSearchMode {
            selectedPokemon = searchedPokemonArray[indexPath.row]
        } else{
            selectedPokemon = pokemonArray[indexPath.row]
        }

        detailView.updateImage(ID: selectedPokemon.pokedexID)
        
        // ANIMATE THE DETAIL VIEW AND BLACK VIEW
        if let window = UIApplication.shared.keyWindow {
            view.endEditing(true)
            window.addSubview(blackView)
            blackView.frame = window.frame
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            blackView.alpha = 0

            let y = window.frame.height
            let x = (window.frame.width - width)/2

            window.addSubview(scrollView)
            scrollView.frame = CGRect(x: x, y: y - height, width: width, height: height)
            scrollView.bounces = true
            scrollView.isScrollEnabled = true
            scrollView.isPagingEnabled = true
            scrollView.showsVerticalScrollIndicator = false
            scrollView.contentSize = CGSize(width: width, height: height * 2)

            scrollView.addSubview(detailView)
            let dragBar = UIView()
            dragBar.backgroundColor = UIColor(white: 0, alpha: 0.1)
            dragBar.layer.cornerRadius = 3
            detailView.addSubview(dragBar)
            dragBar.frame = CGRect(x: detailView.frame.midX - 25, y: 10, width: 50, height: 8)

            detailView.layer.cornerRadius = 10
            detailView.frame = CGRect(x: 0, y: height, width: scrollView.frame.width, height: scrollView.frame.height)
            self.scrollView.scrollRectToVisible(CGRect(x: 0, y: self.height, width: self.scrollView.frame.width, height: self.scrollView.frame.height), animated: true)

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
            }, completion: nil)

        }




    }

    // DISMISS DETAIL VIEW AND BLACK VIEW
    func handleDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: { 
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.scrollView.frame = CGRect(x: (window.frame.width - self.width)/2 , y: window.frame.height, width: self.width, height: self.height)
            }
            
            }) { (complete) in
            self.blackView.removeFromSuperview()
            self.scrollView.removeFromSuperview()
        }
    }

    // DETECT THE POSITION OF THE SCROLLVIEW DISMISS IF AT BOTTOM
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        blackView.alpha = (scrollView.contentOffset.y / scrollView.frame.height)
        if scrollView.contentOffset.y == 0 {
            self.handleDismiss()
        }
    }

    // SET UP THE NUMBER OFS SECTION IN COLLECTION
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    // SET UP THE NUMBER OF ITEMS IN SECTION
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return searchedPokemonArray.count
        }
        return pokemonArray.count
    }

    // SET UP THE SIZE OF EACH CELL
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 105, height: 105)
    }


    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }

    // UPDATE THE SEARCH RESULT EVERYTIME TEXT CHANGE
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {

            inSearchMode = false
            pokemonCollectionView.reloadData()
            view.endEditing(true)

        } else {

            let lowerCase = searchBar.text!.lowercased()
            searchedPokemonArray = pokemonArray.filter({$0.name.range(of: lowerCase) != nil})
            pokemonCollectionView.reloadData()

            inSearchMode = true
        }
    }

    // START PLAYING POKEMON THEME MUSIC
    func initAudio() {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")

        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path!)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch let err as NSError {
            print(err)
        }
    }

    // MUSIC PLAYER BUTTON SPRESSED
    @IBAction func musicBtnPressed(_ sender: AnyObject) {

        if musicPlayer.isPlaying {
            musicPlayer.pause()
            musicBtn.alpha = 0.2
        } else {
            musicPlayer.play()
            musicBtn.alpha = 1
        }

    }



}

