//
//  FaceSaveViewModel.swift
//  FaceDetection
//
//  Created by Hesham Ali on 11/20/19.
//  Copyright © 2019 Hesham Ali. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
struct FaceSaveViewModel {
    private let allTagsSubject:BehaviorSubject<[Tag]> = BehaviorSubject(value: [])
    private let pictureTagsSubject:BehaviorSubject<[Tag]> = BehaviorSubject(value: [])
    var observableAllTags: Observable<[Tag]>{
        return self.allTagsSubject.asObservable()
    }
    var observablePictureTags: Observable<[Tag]>{
        return self.pictureTagsSubject.asObservable()
    }
    fileprivate func saveNewFace(_ savedPictures: inout Pictures, _ mainImage: UIImage, _ personFace: UIImage, _ personName: String, _ faceRegion: CGRect) {
        var tags = savedPictures.tagsDictionary[mainImage.pngData()!] ?? []
        let newTag = Tag(personFace: personFace, personName: personName, faceRegion: faceRegion, includingPicture: mainImage)
        tags.append(newTag)
        savedPictures.tagsDictionary[mainImage.pngData()!] = tags
        savePicture(savedPictures)
    }
    
    func savePictureInfo(personFace:UIImage,personName:String,mainImage:UIImage,faceRegion:CGRect){
        var savedPictures = getPicturesFromUserDefaults()
        if isOldFaceExist(personFace: personFace, mainImage: mainImage, pictures: savedPictures){
            replaceOldNames(mainImage, personFace, personName, pictures: &savedPictures)
        }
        else{
            saveNewFace(&savedPictures, mainImage, personFace, personName, faceRegion)
        }
    }
    
    private func isOldFaceExist(personFace:UIImage,mainImage:UIImage,pictures:Pictures)->Bool{
        if let tags = pictures.tagsDictionary[mainImage.pngData()!]{
            return tags.contains(where: {$0.personFace?.pngData()==personFace.pngData()})
        }
        return false
    }
    
    private func replaceOldNames(_ mainImage: UIImage, _ personFace: UIImage, _ personName: String,pictures:inout Pictures) {
        if var tags = pictures.tagsDictionary[mainImage.pngData()!]{
            for i in 0..<tags.count{
                if tags[i].personFace?.pngData() == personFace.pngData(){
                    tags[i].personName = personName
                }
            }
            pictures.tagsDictionary[mainImage.pngData()!] = tags
        }
        savePicture(pictures)
    }
    
    
    
    func getPicturesFromUserDefaults()->Pictures{
        if let oldPicturesData = UserDefaults.standard.object(forKey: UserDefaultsKeys.pictures) as? Data {
            let decoder = JSONDecoder()
            if let loadedPicture = try? decoder.decode(Pictures.self, from: oldPicturesData) {
                emitTags(loadedPicture)
                return loadedPicture
            }
        }
        let newPictures = Pictures()
        self.allTagsSubject.onNext([])
        return newPictures
    }
    
    private func savePicture(_ pictures: Pictures) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(pictures) {
            UserDefaults.standard.set(encoded, forKey: UserDefaultsKeys.pictures)
            UserDefaults.standard.synchronize()
        }
        emitTags(pictures)
    }
    
    private func emitTags(_ loadedPicture: Pictures) {
        var tagsList:[Tag] = []
        loadedPicture.tagsDictionary.forEach { (_, tags) in
            tagsList.append(contentsOf: tags)
        }
        self.allTagsSubject.onNext(tagsList)
    }
    
    func getPictureForFace(atIndex index:Int){
        if let tagsList = try? self.allTagsSubject.value(){
            let savedPictures = getPicturesFromUserDefaults()
            if let mainImage = tagsList[index].includingPicture{
                if let pictureTags = savedPictures.tagsDictionary[mainImage.pngData()!]{
                    self.pictureTagsSubject.onNext(pictureTags)
                }
            }
        }
    }
    
    func getPersonNameFromImage(faceImage:UIImage)->String{
        let pictureTags = try? self.pictureTagsSubject.value()
        if let personName = pictureTags?.first(where: {return $0.personFace?.pngData() == faceImage.pngData()})?.personName{
            return personName
        }
        return ""
    }
    
}
