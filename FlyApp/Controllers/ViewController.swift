//
//  ViewController.swift
//  BWWalkthroughExample
//
//  Created by Yari D'areglia on 17/09/14.

import UIKit
import BWWalkthrough
import GDPerformanceView_Swift
import HGPlaceholders

class ViewController: UIViewController {
    
    var trips = [Trip]()
    
    @IBOutlet var itinerary: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.getData), name:NSNotification.Name(rawValue: "grabData"), object: nil)
        GDPerformanceMonitor.sharedInstance.startMonitoring()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     //   itinerary.showDefault()

        let userDefaults = UserDefaults.standard
        
        if !userDefaults.bool(forKey: "walkthroughPresented") {
            
            showWalkthrough()
            userDefaults.set(true, forKey: "walkthroughPresented")
            userDefaults.synchronize()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showWalkthrough(){
        
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        let walkthrough = stb.instantiateViewController(withIdentifier: "walk") as! BWWalkthroughViewController
        
        let page_one = stb.instantiateViewController(withIdentifier: "walk1")
        let page_two = stb.instantiateViewController(withIdentifier: "walk2")
        let page_three = stb.instantiateViewController(withIdentifier: "walk3")
        let page_four = stb.instantiateViewController(withIdentifier: "walk4")

        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.add(viewController:page_one)
        walkthrough.add(viewController:page_two)
        walkthrough.add(viewController:page_three)
        walkthrough.add(viewController:page_four)
        walkthrough.scrollview.isScrollEnabled = false
        self.present(walkthrough, animated: true, completion: nil)
    }
    func getData(){
        
        let tableData = Trip()
        tableData.createTrip()
        trips.append(tableData)
        
        //itinerary.showLoadingPlaceholder()

        delay(8){
            //self.itinerary.showDefault()
            print("Reloading data...")
            self.itinerary.reloadData()
        }
    }
    func getSections() -> Int{
        return trips.isEmpty ? 0 : trips[0].day.count
    }
    func getRowsInSection(inSection section: Int) -> Int{
        
        return trips.isEmpty ? 0 : trips[0].day[section].allVenues.count
    }
}
extension ViewController: BWWalkthroughViewControllerDelegate{
    
    // MARK: - Walkthrough delegate -
    
    func walkthroughPageDidChange(_ pageNumber: Int) {
        print("Current Page \(pageNumber)")
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

}
extension ViewController: UITableViewDelegate{
    
}
extension ViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return getSections()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return getRowsInSection(inSection: section)
    }
   /* func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return trips.isEmpty ? "Section \(section)" : trips[0].day[section].instanceDate.description(with: .current)
    }*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    //    let cell = StandardTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StandardTableViewCell

        if trips.isEmpty{
            cell.textLabel?.text = "No trip created."
        }
        else{
            let trip = trips[0]
            print("Index path section: \(indexPath.section), index path row: \(indexPath.row), index path: \(indexPath)")
            
            print("Number of days: \(trip.day.count)")
            print("Number of venues in first day: \(trip.day[0].allVenues.count)")
            let name = trip.day[indexPath.section].allVenues[indexPath.row].name
            let address = trip.day[indexPath.section].allVenues[indexPath.row].address.displayAddress.string!
            print("Name, address: \(name, address)")
            cell.venueNameLabel?.text = trip.day[indexPath.section].allVenues[indexPath.row].name
            cell.venueAddressLabel?.text = trip.day[indexPath.section].allVenues[indexPath.row].address.displayAddress.string!
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = .black
        
        let headerLabel = UILabel(frame: CGRect(x: 20, y: 0, width: tableView.bounds.size.width, height: 30))
        headerLabel.textColor = .white
        if(trips.isEmpty){
            headerLabel.text = ""
        }
        else{
            headerLabel.text = trips[0].day[section].instanceDate.displayDate
        }
        headerView.addSubview(headerLabel)
        return headerView
    }


}
