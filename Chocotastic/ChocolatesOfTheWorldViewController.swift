/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import RxSwift
import RxCocoa

class ChocolatesOfTheWorldViewController: UIViewController {
  
  @IBOutlet private var cartButton: UIBarButtonItem!
  @IBOutlet private var tableView: UITableView!
  // let europeanChocolates = Observable.just(Chocolate.ofEurope)
  //let europeanChocolates = Chocolate.ofEurope
  let europeanChocolates = Observable.just(Chocolate.ofEurope)
  let disposeBag = DisposeBag()
  
  //MARK: View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Chocolate!!!"
    
    setupCartObserver()
    setupCellConfiguration()
    setupCellTapHandling()
    
    //    tableView.dataSource = self
    //    tableView.delegate = self
  }
  
  
  //MARK: Rx Setup
  

  private func setupCellTapHandling() {
    tableView
      .rx
      .modelSelected(Chocolate.self) // 1
      .subscribe(onNext: {
        chocolate in
        ShoppingCart.sharedCart.chocolates.value.append(chocolate)
        
        if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
          self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
        }
      })
      .addDisposableTo(disposeBag)
  }
  
  
  private func setupCellConfiguration() {
    europeanChocolates
      .bindTo(tableView
        .rx
        .items(cellIdentifier: ChocolateCell.Identifier,
               cellType: ChocolateCell.self)) {
                row, chocolate, cell in
                cell.configureWithChocolate(chocolate: chocolate)
      }
      .addDisposableTo(disposeBag)
    
  }
  
  private func setupCartObserver() {
    ShoppingCart.sharedCart.chocolates.asObservable()
      .subscribe(onNext: {
        chocolates in
        self.cartButton.title = "\(chocolates.count) \u{1f36b}"
      })
      .addDisposableTo(disposeBag)
  }
  
  
  
  //MARK: Imperative methods
  
  
}

// MARK: - Table view data source
//extension ChocolatesOfTheWorldViewController: UITableViewDataSource {
//
//  func numberOfSections(in tableView: UITableView) -> Int {
//    return 1
//  }
//
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return europeanChocolates.count
//  }
//
//  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//    return false
//  }
//
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    guard let cell = tableView.dequeueReusableCell(withIdentifier: ChocolateCell.Identifier, for: indexPath) as? ChocolateCell else {
//      //Something went wrong with the identifier.
//      return UITableViewCell()
//    }
//
//    let chocolate = europeanChocolates[indexPath.row]
//    cell.configureWithChocolate(chocolate: chocolate)
//
//    return cell
//  }
//}

// MARK: - Table view delegate
//extension ChocolatesOfTheWorldViewController: UITableViewDelegate {
//
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    tableView.deselectRow(at: indexPath, animated: true)
//
//    let chocolate = europeanChocolates[indexPath.row]
//    ShoppingCart.sharedCart.chocolates.value.append(chocolate)
//  }
//}

// MARK: - SegueHandler
extension ChocolatesOfTheWorldViewController: SegueHandler {
  
  enum SegueIdentifier: String {
    case
    GoToCart
  }
}
