//
//  DrawerViewController.swift
//  parking app
//
//  Created by Farbod Rafezy on 9/12/17.
//  Copyright © 2017 Farbod Rafezy. All rights reserved.
//

import UIKit
import Pulley
import MapKit

class DrawerViewController: UIViewController, UITextFieldDelegate, PulleyDrawerViewControllerDelegate {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var grabber: UIView!

    var matchingItems: [MKMapItem] = [MKMapItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchField.backgroundColor = UIColor.clear.withAlphaComponent(0.08)
        searchField.layer.cornerRadius = 8
        searchField.layer.masksToBounds = true
        searchField.layer.borderWidth = 0
        let searchFieldPaddingView = UIView(
            frame: CGRect(x: 0, y: 0, width: 10, height: self.searchField.frame.height))
        searchField.leftView = searchFieldPaddingView
        searchField.leftViewMode = UITextFieldViewMode.always

        searchField.delegate = self

        grabber.backgroundColor = UIColor.clear.withAlphaComponent(0.22)
        grabber.layer.cornerRadius = 3
        grabber.layer.masksToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        if let mainVC = self.parent as? PulleyViewController {
            mainVC.setDrawerPosition(position: .partiallyRevealed)
        }
    }

    func supportedDrawerPositions() -> [PulleyPosition] {
        return [.open, .partiallyRevealed, .collapsed]
    }

    func partialRevealDrawerHeight() -> CGFloat {
        return 68
    }

    func collapsedDrawerHeight() -> CGFloat {
        return 264
    }

    func drawerPositionDidChange(drawer: PulleyViewController) {
        if drawer.drawerPosition != .open {
            searchField.resignFirstResponder()
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let mainVC = self.parent as? PulleyViewController {
            mainVC.setDrawerPosition(position: .open)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        if let mainVC = self.parent as? PulleyViewController {
            mainVC.setDrawerPosition(position: .collapsed)
        }
        performSearch()
        return true
    }

    func performSearch() {

        let mapVC = self.parent?.childViewControllers[0] as! MapViewController

        matchingItems.removeAll()
        mapVC.mapView.removeAnnotations(mapVC.mapView.annotations)
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchField.text
        request.region = mapVC.mapView.region

        let search = MKLocalSearch(request: request)

        search.start(completionHandler: {(response, error) in

            if error != nil {
                print("Error occured in search: \(error!.localizedDescription)")
            } else if response!.mapItems.count == 0 {
                print("No matches found")
            } else {
                print("Matches found")

                for item in response!.mapItems {
                    print("Name = \(item.name)")
                    print("Phone = \(item.phoneNumber)")

                    self.matchingItems.append(item as MKMapItem)
                    print("Matching items = \(self.matchingItems.count)")

                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    mapVC.mapView.addAnnotation(annotation)
                }
            }
        })
    }
}
