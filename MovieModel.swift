//
//  MovieModel.swift
//  Hint.e
//
//  Created by Emily Lynam on 9/21/16.
//  Copyright © 2016 Emily Lynam. All rights reserved.
//

import Foundation

class Movie {
    let title: String
    let poster_path: String?

    init(title: String, poster_path: String) {
        self.title = title
        self.poster_path = poster_path

    }
//"https://api.themoviedb.org/3/movie/109445/similar?language=en-US&api_key=a9f9a3f34caecf352497c069126e23b7"
    
    static func getMovieRequest(url: String, completion: @escaping (_ movies:[Movie]) -> ()){
        
       
        let url = NSURL(string: url)
        let request = URLRequest(url:url as! URL)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {
            data, response, error in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    print(jsonResult["next"])
                    var outMovies = [Movie]()
                    if let results = jsonResult["results"] as? NSArray { // was any object so had to type cast it / downcast it
                        for result in results {
                            let movie = Movie(title: (result as! NSDictionary)["title"]! as! String, poster_path: (result as! NSDictionary)["poster_path"]! as! String)
                            outMovies.append(movie)
                        }
                    }
                    completion(outMovies)
                }
            } catch {
                print("Something went wrong: \(error)")
            }
        })

        task.resume()
    }
}
