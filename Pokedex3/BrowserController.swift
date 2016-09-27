//
//  ViewController.swift
//  Pokedex3
//
//  Created by Aengus Tran on 27/9/16.
//  Copyright © 2016 Aengus Tran. All rights reserved.
//

import UIKit
import AVFoundation

class BrowserController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UISearchBarDelegate {

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

        // SET UP DATA SOURCE AND DELEGATE
        parsePokemonCSV()
        initAudio()
        musicPlayer.pause()
        pokemonCollectionView.dataSource = self
        pokemonCollectionView.delegate = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        pokemonCollectionView.reloadData()

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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        var selectedPokemon: Pokemon!

        if inSearchMode {
            selectedPokemon = searchedPokemonArray[indexPath.row]
        } else{
            selectedPokemon = pokemonArray[indexPath.row]
        }


        if let window = UIApplication.shared.keyWindow {
            window.addSubview(blackView)
            window.addSubview(detailView)
            detailView.configureData()

            blackView.frame = window.frame
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            blackView.alpha = 0

            let height: CGFloat = 400
            let width: CGFloat = 350
            let y = window.frame.height
            let x = (window.frame.width - width)/2
            detailView.frame = CGRect(x: x, y: y, width: width, height: height)


            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.detailView.frame = CGRect(x: x, y: y - height, width: width, height: height)
            }, completion: nil)

        }




    }

    func handleDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                    let height: CGFloat = 400
                    let width: CGFloat = 350
                    let y = window.frame.height
                    let x = (window.frame.width - width)/2
                    self.detailView.frame = CGRect(x: x, y: y, width: width, height: height)
                }
            }, completion: nil)
        blackView.removeFromSuperview()
        detailView.removeFromSuperview()
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

