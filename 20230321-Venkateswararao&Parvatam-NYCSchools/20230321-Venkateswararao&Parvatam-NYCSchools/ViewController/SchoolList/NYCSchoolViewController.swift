//
//  NYCSchoolViewController.swift
//  20230321-Venkateswararao&Parvatam-NYCSchools
//
//  Created by Venkat_Sravani on 3/20/23.
//

import Foundation
import UIKit
import MapKit

class NYCSchoolViewController: UIViewController {
    // UI elements for displaying School list
    
    @IBOutlet var reloadBtn: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    
    // Spinner view
    var spinner = UIActivityIndicatorView(style: .large)
    var loadingView: UIView = UIView()
    
    // variables
    let schoolSearchController = UISearchController(searchResultsController: nil)
    var nycSchoolsList: [SchoolInfo]?
    var filteredNycSchoolsList = [SchoolInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Intital views
        displaySearchController()
        self.showActivityIndicator()
        callSchoolInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.setNeedsLayout()
        }
        
    }
    
    // MARK: - serachController
    func displaySearchController(){
        schoolSearchController.searchResultsUpdater = self
        schoolSearchController.obscuresBackgroundDuringPresentation = false
        schoolSearchController.searchBar.placeholder = "Search Schools"
        schoolSearchController.searchBar.tintColor = UIColor.systemBlue
        navigationItem.searchController = schoolSearchController
        definesPresentationContext = true
        
    }
    
    func callSchoolInfo() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchNYCSchoolInformation()
        }

    }
    
    func isFilter() -> Bool {
        return schoolSearchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return schoolSearchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        guard let schoolList = nycSchoolsList else {
            return
        }
        filteredNycSchoolsList = schoolList.filter({( school : SchoolInfo) -> Bool in
            guard let schoolName = school.school_name?.lowercased() else {
                return false
            }
            return schoolName.contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    @IBAction func reloadAction(_ sender: Any) {
        
        self.showActivityIndicator()
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchNYCSchoolInformation()
        }
        
    }
    
    //MARK: - API to Fetch school info and parse
    private func fetchNYCSchoolInformation(){
        guard let schoolsURL = URL(string: Constants.schoolListURL) else {
            return
        }
        let request = URLRequest(url:schoolsURL)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { [weak self] (schoolsData, response, error)  in
            guard schoolsData != nil else {
                return
            }
            do {
                let schoolsObject = try JSONSerialization.jsonObject(with: schoolsData!, options: [])
                self?.nycSchoolsList = Utils.fetchNYCSchoolWithJsonData(schoolsObject)
                self?.fetchSchoolSATSore()
            } catch {
                self?.hideActivityIndicator()
                print("NYC JSON error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    // fetch school sat score info
    private func fetchSchoolSATSore(){
        guard let schoolsSATScoreURL = URL(string: Constants.schoolDetailsWithSATScoreURL) else {
            return
        }
        let requestForSATScore = URLRequest(url:schoolsSATScoreURL)
        let session = URLSession.shared
        let task = session.dataTask(with: requestForSATScore) {[weak self] (schoolsWithSATScoreData, response, error) in
            if schoolsWithSATScoreData != nil{
                do{
                    let satScoreObject = try JSONSerialization.jsonObject(with: schoolsWithSATScoreData!, options: [])
                    self?.addSatScoreToSchoolInfo(satScoreObject)
                    self?.hideActivityIndicator()
                    DispatchQueue.main.async {[weak self] in
                        self?.tableView.reloadData()
                    }
                }catch{
                    self?.hideActivityIndicator()
                    debugPrint("school with sat score json error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    // update school info with sat, mat, write scores
    private func addSatScoreToSchoolInfo(_ satScoreObject: Any){
        guard let schoolsWithSatScoreArr = satScoreObject as? [[String: Any]] else{
            return
        }
        for  schoolsWithSatScore in schoolsWithSatScoreArr{
            if let matchedDBN = schoolsWithSatScore["dbn"] as? String{
                if let row =  self.nycSchoolsList?.firstIndex(where: {$0.dbn == matchedDBN}) {
                    if let satReadingScoreObject =  schoolsWithSatScore["sat_critical_reading_avg_score"] as? String {
                        self.nycSchoolsList?[row].sat_critical_reading_avg_score = satReadingScoreObject

                    }
                    if let satMathScoreObject = schoolsWithSatScore["sat_math_avg_score"] as? String {
                        self.nycSchoolsList?[row].sat_math_avg_score = satMathScoreObject

                    }
                    
                    if let satWritingScoreObject =  schoolsWithSatScore["sat_writing_avg_score"] as? String {
                        self.nycSchoolsList?[row].sat_writing_avg_score = satWritingScoreObject
                    }
                }
            }

        }
        
    }
    // MARK: Call phone
    @objc func callNumber(_ sender: UIButton){
        
        var nycSchoolList: SchoolInfo
        if isFilter() {
            nycSchoolList = filteredNycSchoolsList[sender.tag]
        } else {
            nycSchoolList = self.nycSchoolsList![sender.tag]
        }
        let schoolPhoneNumber = nycSchoolList.school_phone_number
        if let url = URL(string: "tel://\(String(describing: schoolPhoneNumber))"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else{
            let alert = UIAlertController(title: "Error!", message: "Please run on a real device", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func navigateToAddress(_ sender: UIButton){
        
        var nycSchoolList: SchoolInfo
        if isFilter() {
            nycSchoolList = filteredNycSchoolsList[sender.tag]
        } else {
            nycSchoolList = self.nycSchoolsList![sender.tag]
        }
        let schoolAddress = nycSchoolList.school_location
        if let highSchoolCoordinate = Utils.getCoodinateForSelectedSchool(schoolAddress){
            let coordinate = CLLocationCoordinate2DMake(highSchoolCoordinate.latitude, highSchoolCoordinate.longitude)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = "\(nycSchoolList.school_name!)"
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Pass the selected school with sat score to the destinatiion view controller
        if segue.identifier == Constants.schoolDetailsWithSATScoreSegue{
            let schoolDetailsVC = segue.destination as! NYCSchoolDetailViewController
            if let schoolWithSATScore = sender as? SchoolInfo {
                schoolDetailsVC.schoolWithSatScore = schoolWithSATScore
            }
        }
    }
    
    //Function to throw alert.
    func displayAlert(_ error: Error) {
        DispatchQueue.main.async{
            self.dismiss(animated: false) {
                OperationQueue.main.addOperation {
                    print("Error while fetching Schools.")
                    print(error.localizedDescription)
                    let alert = UIAlertController(title: "Error while fetching details.", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                        print("Error while fetching details.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

// MARK: - UISearchResultsUpdating Delegate
extension NYCSchoolViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filterContentForSearchText(text)
    }
}


// MARK: UITableViewDataSource and UITableViewDelegate Extensions
extension NYCSchoolViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilter() {
            return self.filteredNycSchoolsList.count
        }
        return self.nycSchoolsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: NYCSchoolListCell = self.tableView.dequeueReusableCell(withIdentifier: Constants.schoolCellIdentifier, for: indexPath) as? NYCSchoolListCell else {
            return UITableViewCell()
        }
        tableView.rowHeight = 195
        
        var nycSchoolList: SchoolInfo
        if isFilter() {
            nycSchoolList = filteredNycSchoolsList[indexPath.row]
        } else {
            nycSchoolList = self.nycSchoolsList![indexPath.row]
        }
        
        guard let schoolName = nycSchoolList.school_name,
              let schoolAddr = nycSchoolList.school_location,
              let phoneNum = nycSchoolList.school_phone_number,
              let grade = nycSchoolList.finalgrades else {
            return UITableViewCell()
        }
        
        cell.schoolNameLbl.text = schoolName
        
        let address = Utils.getCompleteAddressWithoutCoordinate(schoolAddr)
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
        let boldString = NSMutableAttributedString(string: "Location:", attributes:attrs)
        let attributedString = NSMutableAttributedString(string:" \(address)")
        boldString.append(attributedString)
        cell.schoolAddrLbl.attributedText = boldString
        cell.navigateToAddrBtn.tag = indexPath.row
        cell.navigateToAddrBtn.addTarget(self, action: #selector(self.navigateToAddress(_:)), for: .touchUpInside)
        
        cell.schoolPhoneNumBtn.setTitle("call : \(phoneNum)", for: .normal)
        
        cell.schoolPhoneNumBtn.tag = indexPath.row
        cell.schoolPhoneNumBtn.addTarget(self, action: #selector(self.callNumber(_:)), for: .touchUpInside)
        
        cell.schoolGradeLbl.text = "School grade: " + grade
        return cell
    }
    
    //MARK: - UITable View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var selectedSchoolInfo: SchoolInfo
        
        if isFilter() {
            selectedSchoolInfo = filteredNycSchoolsList[indexPath.row]
        } else {
            selectedSchoolInfo = self.nycSchoolsList![indexPath.row]
        }
        if selectedSchoolInfo.sat_critical_reading_avg_score == nil {
            let alert = UIAlertController(title: "Info", message: "Selected School details are not available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: Constants.schoolDetailsWithSATScoreSegue, sender: selectedSchoolInfo)
        }
    }
}


extension NYCSchoolViewController {
    func showActivityIndicator() {
        DispatchQueue.main.async {
            self.loadingView = UIView()
            self.loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
            self.loadingView.center = self.view.center
            self.loadingView.backgroundColor = .gray
            self.loadingView.alpha = 0.7
            self.loadingView.clipsToBounds = true
            self.loadingView.layer.cornerRadius = 10

            self.spinner = UIActivityIndicatorView(style: .large)
            self.spinner.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
            self.spinner.center = CGPoint(x:self.loadingView.bounds.size.width / 2, y:self.loadingView.bounds.size.height / 2)

            self.loadingView.addSubview(self.spinner)
            self.view.addSubview(self.loadingView)
            self.spinner.startAnimating()
        }
    }

    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.loadingView.removeFromSuperview()
        }
    }
}
