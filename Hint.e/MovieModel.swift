//
//  StarWarsModel.swift
//  StarWarsEncyclopedia
//
//  Created by Emily Lynam on 9/19/16.
//  Copyright © 2016 Emily Lynam. All rights reserved.
//

import Foundation

class Person {
    let name: String
    let gender: String
    let birthYear: String
    let mass: String
    init(name: String, gender: String, birthYear: String, mass: String) {
        self.name = name
        self.gender = gender
        self.birthYear = birthYear
        self.mass = mass
    }
    static func getPeopleRequest(url: String, outPeople: [Person] = [], completion: @escaping (_ people:[Person]) -> ()){
        // otherwise it will be a let by default:
        var outPeople = outPeople
        
        // Specify the url that we will be sending the GET Request to:
        let url = NSURL(string: url)
        // translate the url into a requet:
        let request = URLRequest(url:url as! URL)
        // Create an NSURLSession to handle the request tasks that we can use to run "tasks" to transfer data over HTTP:
        let session = URLSession.shared
        // Running the "session.dataTaskWithURL" method will request some data from the given URL and then run the completionHandler code block as soon as the data response is received
        let task = session.dataTask(with: request, completionHandler: {
            // asyncronous
            // We get data, response, and error back. Data contains the JSON data, Response contains the headers and other information about the response, and Error contains an error if one occured
            data, response, error in
            // A "Do-Try-Catch" block involves a try statement with some catch block for catching any errors thrown by the try statement.
            do {
                // Try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.):
                // We use the NSJSONSerialization library to attempt to convert the data object into JSON, and then unwrap it using our standard optional unwrapping syntax while typecasting the jsonResult object to an NSDictionary:
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    print(jsonResult["next"])
                    
                    if let results = jsonResult["results"] as? NSArray { // was any object so had to type cast it / downcast it
                        for result in results {
                            let p = Person(name: (result as! NSDictionary)["name"]! as! String, gender: (result as! NSDictionary)["gender"]! as! String, birthYear: (result as! NSDictionary)["birth_year"]! as! String, mass: (result as! NSDictionary)["mass"]! as! String)
                            outPeople.append(p)
                        }
                        // need to have this if statement nested so we can pass along the same outPeople and append the same one instead of overwritting the one for each page
                        if let nextResults = jsonResult["next"] as? String {
                                // recursively calling function for the next page
                            getPeopleRequest(url: nextResults, outPeople: outPeople, completion: completion)
                        } else {
                            completion(outPeople)
                        }
                    }
                }
            } catch {
                print("Something went wrong: \(error)")
            }
        })
        // Actually "execute" the task. This is the line that actually makes the request that we set up above
        task.resume()
    }
}

class Film {
    let title: String
    let releaseDate: String
    let director: String
    let openingCrawl: String
    init(title: String, releaseDate: String, director: String, openingCrawl: String) {
        self.title = title
        self.releaseDate = releaseDate
        self.director = director
        self.openingCrawl = openingCrawl
    }
    static func getFilmRequest(url: String, completion: @escaping (_ films:[Film]) -> ()){
        
        // Specify the url that we will be sending the GET Request to:
        let url = NSURL(string: url)
        // translate the url into a requet:
        let request = URLRequest(url:url as! URL)
        // Create an NSURLSession to handle the request tasks that we can use to run "tasks" to transfer data over HTTP:
        let session = URLSession.shared
        // Running the "session.dataTaskWithURL" method will request some data from the given URL and then run the completionHandler code block as soon as the data response is received
        let task = session.dataTask(with: request, completionHandler: {
            // asyncronous
            // We get data, response, and error back. Data contains the JSON data, Response contains the headers and other information about the response, and Error contains an error if one occured
            data, response, error in
            // A "Do-Try-Catch" block involves a try statement with some catch block for catching any errors thrown by the try statement.
            do {
                // Try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.):
                // We use the NSJSONSerialization library to attempt to convert the data object into JSON, and then unwrap it using our standard optional unwrapping syntax while typecasting the jsonResult object to an NSDictionary:
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    print(jsonResult["next"])
                    var outFilms = [Film]()
                    if let results = jsonResult["results"] as? NSArray { // was any object so had to type cast it / downcast it
                        for result in results {
                            let f = Film(title: (result as! NSDictionary)["title"]! as! String, releaseDate: (result as! NSDictionary)["release_date"]! as! String, director: (result as! NSDictionary)["director"]! as! String, openingCrawl: (result as! NSDictionary)["opening_crawl"]! as! String)
                            outFilms.append(f)
                        }
                    }
                    completion(outFilms)
                }
            } catch {
                print("Something went wrong: \(error)")
            }
        })
        // Actually "execute" the task. This is the line that actually makes the request that we set up above
        task.resume()
    }
}


