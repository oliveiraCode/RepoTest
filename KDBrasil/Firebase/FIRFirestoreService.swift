//
//  FIRFirestoreService.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-01-10.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import CoreData
import KRProgressHUD
import CoreLocation

class FIRFirestoreService {
    
    static let shared = FIRFirestoreService()
    
    let db = Firestore.firestore()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var currentCity:String?
    
    //MARK: - saveData
    func saveData(business:Business, imageArray:[UIImage]){
        var photoUrls:[String] = []
        let countImage = imageArray.count
        let businessRef = Firestore.firestore().collection(FIRCollectionReference.business)
        business.id = businessRef.document().collection(businessRef.collectionID).document().documentID
        
        for (index,image) in imageArray.enumerated() {
            
            uploadingPhotoBusiness(business: business, img: image, index: index) { (url) in
                photoUrls.append(url)
                
                if photoUrls.count == countImage {
                    business.photosURL = photoUrls.sorted{ $0 < $1 }
                    self.saveBusinessToFirestore(businessRef: businessRef, business: business)
                }
            }
        }
    }
    
    func uploadingPhotoBusiness(business:Business,img:UIImage, index:Int, completion: @escaping ((String) -> Void)) {
        
        let storeImage = Storage.storage().reference().child(FIRCollectionReference.imageBusiness).child("\(business.id!)\(index)")
        
        if let uploadImageData = (img).jpegData(compressionQuality: 0.75){
            storeImage.putData(uploadImageData, metadata: nil, completion: { (metaData, error) in
                storeImage.downloadURL(completion: { (url, error) in
                    if let urlText = url?.absoluteString {
                        completion(urlText)
                    }
                })
            })
        }
    }
    
    
    //MARK - saveBusinessToFirestore
    private func saveBusinessToFirestore (businessRef:CollectionReference, business:Business){
        
        var contactData: [String: Any] {
            return [
                "email": business.contact!.email!,
                "phone": business.contact!.phone!,
                "whatsapp":business.contact!.whatsapp!,
                "web": business.contact!.web!
            ]
        }
        
        var addressData: [String: Any] {
            return [
                "city": business.address!.city!,
                "postalCode": business.address!.postalCode!,
                "province": business.address!.province!,
                "country": business.address!.country!,
                "number": business.address!.number!,
                "street": business.address!.street!,
                "complement": business.address!.complement!,
                "latitude":business.address!.latitude!,
                "longitude":business.address!.longitude!
            ]
        }
        
        var hoursData: [String: Any] {
            return [:]
        }
        
        var businessData: [String: Any] {
            return [
                "id":business.id!,
                "description": business.description!,
                "name": business.name!,
                "creationDate": business.creationDate!,
                "category": business.category!,
                "user_id": business.user_id!,
                "rating": business.rating!,
                "country": business.country!,
                "address":addressData,
                "hours":[:], //fixed bug when using v 2.0.5
                "contact":contactData,
                "photosURL":business.photosURL!
            ]
        }
        
        
        
        businessRef.document(business.id!).setData(businessData) { (error) in
            if error != nil {
                print("error \(error!.localizedDescription)")
            } else {
                print("data saved business")
            }
        }
        
    }
    
    //MARK - removeMyBusiness
    func updateReviewData(business:Business){
        
        let businessRef = Firestore.firestore().collection(FIRCollectionReference.business)
        
        businessRef.document(business.id!).updateData(
            [
                "reviews": business.reviews!.map({$0.dictionary}),
                "rating": Service.shared.calculateRating(reviews: business.reviews!)
            ]
        ) { (error) in
            if error != nil {
                print("error \(error!.localizedDescription)")
            } else {
                print("data updated business")
            }
        }
        
    }
    
    //MARK - removeMyBusiness
    func removeData(business:Business){
        db.collection(FIRCollectionReference.business).document("\(business.id!)").delete()
    }
    
    //MARK - removeMyBusinessStorage
    func removeStorage(business:Business) {
        
        //remove each image from store
        for (index,_) in (business.photosURL?.enumerated())!{
            let storeImage = Storage.storage().reference().child(FIRCollectionReference.imageBusiness).child("\(business.id!)\(index)")
            
            storeImage.delete { (error) in
                if error != nil {
                    print("error \(error!.localizedDescription)")
                } else {
                    print("foto anúncio removido do storage")
                }
            }
        }
    }
    
    //MARK - readMyBusinesses
    func readMyBusinesses(completionHandler: @escaping ([Business?], Error?) -> Void) {
        
        guard let userID = appDelegate.userObj.id else {
            completionHandler([nil],nil)
            return}
        
        let businessRef = db.collection(FIRCollectionReference.business).whereField("user_id", isEqualTo: "\(userID)")
        
        var businesses = [Business]()
        
        businessRef.order(by: "creationDate", descending: true).getDocuments(source: .default) { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completionHandler([nil],err)
                
            } else {
                for document in querySnapshot!.documents {
                    
                    let address = document.data()["address"] as! [String:Any]
                    let contact = document.data()["contact"] as! [String:Any]
                    
                    let addressObj = Address(data: address)
                    
                    if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined{
                        addressObj?.distance = 0.0
                    } else {
                        addressObj?.distance = Service.shared.calculateDistanceKm(lat: (addressObj!.latitude)!, long: (addressObj!.longitude)!)
                    }
                    
                    let contactObj = Contact(data: contact)
                    
                    let businessObj = Business(data: document.data(), addressObj: addressObj!, contactObj: contactObj!)
                    
                    
                    businesses.append(businessObj!)
                }
                
                let newArrayOfBusiness =  businesses.sorted { $0.address!.distance! < $1.address!.distance! }
                
                completionHandler(newArrayOfBusiness,nil)
            }
        }
    }
    
    //MARK: - readAllBusiness
    func readAllBusiness(completionHandler: @escaping ([Business?], Error?) -> Void) {
        
        guard let country = appDelegate.currentCountry?.name else {return}
        
        let businessRef = self.db.collection(FIRCollectionReference.business)
        let query = businessRef.whereField("country", isEqualTo: country)
        
        var businesses = [Business]()
        
        query.order(by: "name", descending: true).getDocuments(source: .default) { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completionHandler([nil],err)
                
            } else {
                for document in querySnapshot!.documents {
                    
                    let address = document.data()["address"] as! [String:Any]
                    let contact = document.data()["contact"] as! [String:Any]
                    
                    let addressObj = Address(data: address)
                    
                    if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined{
                        addressObj?.distance = 0.0
                    } else {
                        addressObj?.distance = Service.shared.calculateDistanceKm(lat: (addressObj!.latitude)!, long: (addressObj!.longitude)!)
                    }
                    
                    let contactObj = Contact(data: contact)
                    
                    let businessObj = Business(data: document.data(), addressObj: addressObj!, contactObj: contactObj!)
                    
                    businesses.append(businessObj!)
                }
                let newArrayOfBusiness =  businesses.sorted { $0.address!.distance! < $1.address!.distance! }
                
                completionHandler(newArrayOfBusiness,nil)
            }
        }
    }
    
    
    //MARK: - readAllReviewsFromBusiness
    func readAllReviewsFromBusiness(business:Business,completionHandler: @escaping ([Review]?, Error?) -> Void) {
        
        let businessRef = self.db.collection(FIRCollectionReference.business)
        let query = businessRef.whereField("id", isEqualTo: "\(business.id!)")
        
        query.getDocuments(source: .default) { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
                completionHandler(nil, err)
            } else {
                for document in querySnapshot!.documents {
                    
                    guard let reviews = document["reviews"] as? [Any] else {return}
                    
                    var reviewsArray:[Review] = []
                    for (_, value) in reviews.enumerated(){
                        
                        let dailyHoursObj = value as! [String:Any]
                        reviewsArray.append(Review(data: dailyHoursObj)!)
                    }
                    
                    completionHandler(reviewsArray, nil)
                }
            }
        }
    }
    
    
    
    //MARK: - saveDataUser
    func saveData(completion: @escaping (Error?) -> Void ){
        uploadingPhotoUser { (photoURL) in
            if let url = photoURL {
                self.appDelegate.userObj.photoURL = url
                self.saveUserToFireStore()
                UserHandler.shared.saveCurrentUserToCoreData()
                completion(nil)
            }
        }
    }
    
    
    private func uploadingPhotoUser(completion: @escaping ((String?) -> Void)) {
        let storageRef = Storage.storage().reference().child(FIRCollectionReference.imageUsers).child(appDelegate.userObj.id!)
        
        if let uploadImageData = (appDelegate.userObj.image).jpegData(compressionQuality: 0.75){
            storageRef.putData(uploadImageData, metadata: nil, completion: { (metaData, error) in
                storageRef.downloadURL(completion: { (url, error) in
                    if let urlText = url?.absoluteString {
                        completion(urlText)
                    }
                })
            })
        }
    }
    
    //MARK: - createUser
    func createUser(completionHandler: @escaping (Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: appDelegate.userObj.email, password: appDelegate.userObj.password) { (userResult, error) in
            
            if error != nil{
                completionHandler(error)
            }
            
            if error == nil && userResult != nil {
                self.appDelegate.userObj.id = Auth.auth().currentUser?.uid //get id from current user
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = "\(self.appDelegate.userObj.firstName!)"
                changeRequest?.commitChanges(completion: { (error) in
                    if error == nil {
                        self.saveData(completion: { (error) in
                            
                        })
                        completionHandler(nil)
                    } else {
                        completionHandler(error)
                    }
                })
            }
        }
    }
    
    
    //MARK: - saveUserToFireStore
    func saveUserToFireStore() {
        
        let userRef = db.collection(FIRCollectionReference.users)
        
        var userData: [String: Any] {
            return [
                "id":appDelegate.userObj.id,
                "firstName": appDelegate.userObj.firstName,
                "lastName": appDelegate.userObj.lastName ?? "",
                "email": appDelegate.userObj.email,
                "phone": appDelegate.userObj.phone ?? "",
                "whatsapp": appDelegate.userObj.whatsapp ?? "",
                "favoritesIds": appDelegate.userObj.favoritesIds ?? "",
                "creationDate": appDelegate.userObj.creationDate!,
                "authenticationType": appDelegate.userObj.authenticationType?.rawValue ?? "",
                "userType": appDelegate.userObj.userType?.rawValue ?? "",
                "photoURL": appDelegate.userObj.photoURL ?? ""
            ]
        }
        
        
        userRef.document(appDelegate.userObj.id).setData(userData) { (error) in
            if error != nil {
                print("error \(error!.localizedDescription)")
            } else {
                print("data saved user")
            }
        }
        
    }
    
    
    //MARK - createCategory
    func createCategory(category:Category){
        
        var categoryData: [String: Any] {
            return [
                "name": category.name
            ]
        }
        
        
        let categoryRef = db.collection(FIRCollectionReference.category)
        
        categoryRef.addDocument(data: categoryData) { (error) in
            if error != nil {
                print("error \(error!.localizedDescription)")
            } else {
                print("data saved")
            }
        }
        
    }
    
    //MARK - readCategory
    func readCategory(completionHandler: @escaping ([Category?], Error?) -> Void) {
        
        db.collection("category").getDocuments { documentSnapshot, error in
            
            if error == nil {
                guard let snapshot = documentSnapshot else {
                    print("Error fetching documents results: \(error!)")
                    return
                }
                
                for document in snapshot.documents {
                    let result = document.data()["categories"] as! [String]
                    var arrayCategory:[Category] = []
                    for value in result.enumerated(){
                        let objCategory = Category(name: value.element)
                        arrayCategory.append(objCategory)
                    }
                    
                    let newCategory = arrayCategory.sorted{ $0.name < $1.name }
                    
                    completionHandler(newCategory, nil)
                }
            } else {
                completionHandler([nil], error)
            }
        }
        
    }
    
    func checkIfUserExists(email:String,completionHandler: @escaping (Bool) -> Void){
        let userRef = db.collection(FIRCollectionReference.users).whereField("email", isEqualTo:email)
        
        userRef.getDocuments { (querySnapshot, err) in
            if querySnapshot?.count == 0 {
                completionHandler(false)
            } else {
                completionHandler(true)
            }
        }
        
    }
    
    //MARK - getDataFromCurrentUser
    func getDataFromCurrentUser(completionHandler: @escaping (Error?) -> Void) {
        
        let userRef = db.collection(FIRCollectionReference.users).whereField("id", isEqualTo: (Auth.auth().currentUser?.uid)!)
        
        userRef.getDocuments(source: .default) { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
                completionHandler(err)
            } else {
                for document in querySnapshot!.documents {
                    
                    let user = User(data: document.data())
  
                    if let url = user.photoURL{
                        self.getPhotoURL(url: url, completion: { (image) in
                            user.image = image
                            
                            //set the global variable with current user
                            self.appDelegate.userObj = user
                            UserHandler.shared.saveCurrentUserToCoreData()
                            UserHandler.shared.readCurrentUserFromCoreData()
                            completionHandler(nil)
                        })
                    }
                }
            }
        }
    }
    
    
    private func getPhotoURL(url:String, completion: @escaping (_ image:UIImage?)-> Void){
        
        guard let url = URL(string: url) else {
            completion(UIImage(named: "user"))
            return
        }
        do {
            let data = try Data(contentsOf: url)
            completion(UIImage(data: data))
        }
        catch {
            completion(UIImage(named: "user"))
        }
        
    }
    
    //MARK - getDataFromUserBusiness
    func getDataFromUserBusiness(idUser:String,completionHandler: @escaping (User?,Error?) -> Void) {
        
        let userRef = db.collection(FIRCollectionReference.users).whereField("id", isEqualTo: idUser)
        
        userRef.getDocuments(source: .default) { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
                completionHandler(nil,err)
            } else {
                for document in querySnapshot!.documents {
                    
                    let user = User()
                    user.creationDate = document["creationDate"] as? String
                    user.firstName = document["firstName"] as? String
                    
                    let imageRef = Storage.storage().reference().child(FIRCollectionReference.imageUsers).child(idUser)
                    imageRef.downloadURL { (url, error) in
                        
                        do {
                            let data = try Data(contentsOf: url!)
                            user.image = UIImage(data: data as Data)
                            
                            completionHandler(user,nil)
                        } catch {
                            completionHandler(nil,error)
                        }
                    }
                }
            }
        }
        
    }

    
    func deleteAccount() {
        
        ////Remove all businneses from user
        let businessRef = db.collection(FIRCollectionReference.business)
        let query = businessRef.whereField("user_id", isEqualTo: appDelegate.userObj.id)
        
        query.getDocuments(source: .default) { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    businessRef.document(document["id"] as! String).delete()
                }
            }
            print("anúncios deletados com sucesso")
        }
        
        
        
        
        //Remove user from Firebase Account
        Auth.auth().currentUser?.delete(completion: { (error) in
            if error == nil {
                print("usuário deletado com sucesso")
            }
        })
        
        
        //Remove user from Storage
        let imageRef = Storage.storage().reference().child(FIRCollectionReference.imageUsers).child(appDelegate.userObj.id)
        imageRef.delete { (error) in
            if error != nil {
                print("error \(error!.localizedDescription)")
            } else {
                print("foto usuario removido storage")
            }
        }
        
        //Remove user from Firestore Collection
        let userRef = db.collection(FIRCollectionReference.users)
        userRef.document(appDelegate.userObj.id).delete { (error) in
            if error != nil {
                print("error \(error!.localizedDescription)")
            } else {
                print("usuário removido firebase")
            }
        }
        
        //Remove user from CoreData
        UserHandler.shared.resetAllRecordsOnCoreData()
        
        //Remove user from AppDelegate
        UserHandler.shared.resetValuesOfUserAccount()
    }

    
}

