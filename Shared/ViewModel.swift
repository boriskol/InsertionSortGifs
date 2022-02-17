//
//  ViewModel.swift
//  InsertionSortGifs
//
//  Created by Borna Libertines on 16/02/22.
//
/*
 ///This is exactly what Swift's built-in sort() function does.
 
 ///You are given an array of numbers and need to put them in the right order. The insertion sort algorithm works as follows:
 
 Put the numbers on a pile. This pile is unsorted.
 Pick a number from the pile. It doesn't really matter which one you pick, but it's easiest to pick from the top of the pile.
 Insert this number into a new array.
 Pick the next number from the unsorted pile and also insert that into the new array. It either goes before or after the first number you picked, so that now these two numbers are sorted.
 Again, pick the next number from the pile and insert it into the array in the proper sorted position.
 Keep doing this until there are no more numbers on the pile. You end up with an empty pile and an array that is sorted.
 
 //That's why this is called an "insertion" sort, because you take a number from the pile and insert it in the array in its proper sorted position.
 */
import Foundation
/*
 func insertionSort<T>(_ array: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
   var sortedArray = array
   for index in 1..<sortedArray.count {
      var currentIndex = index
      let temp = sortedArray[currentIndex]
      while y > 0 && isOrderedBefore() {
         sortedArray[currentIndex] = sortedArray[currentIndex - 1]                // 1
         currentIndex -= 1
      }
      sortedArray[currentIndex] = temp                      // 2
   }
      return sortedArray
 }
 */
class ViewModel: ObservableObject {
   
   @Published var gifs = [GifCollectionViewCellViewModel]()
   // MARK:  Initializer Dependency injestion
   let appiCall: ApiLoader?
   
   init(appiCall: ApiLoader = ApiLoader()){
      self.appiCall = appiCall
   }
   
   func insertionSort<T>(_ array: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
      var a = array
      for x in 1..<a.count {
         var y = x
         let temp = a[y]
         while y > 0 && isOrderedBefore(temp, a[y - 1]) {
            a[y] = a[y - 1]
            y -= 1
         }
         a[y] = temp
      }
      return a
   }
   
   public func sortArrayA(){
     self.gifs = insertionSort(gifs, <) //{$0.title < $0.title}
   }
   public func sortArrayD(){
      self.gifs = insertionSort(self.gifs, >)
   }
   
   @MainActor func loadGift() async {
      Task(priority: .userInitiated, operation: {
         let fp: APIListResponse? = try? await appiCall?.fetchAPI(urlParams: [Constants.rating: Constants.rating, Constants.limit: Constants.limitNum], gifacces: Constants.trending)
         let d = fp?.data.map({ return GifCollectionViewCellViewModel(id: $0.id!, title: $0.title!, rating: $0.rating, Image: $0.images?.fixed_height?.url, url: $0.url)
         })
         self.gifs = d!
      })
   }
   
   
   deinit{
      debugPrint("ViewModel deinit")
   }
}
