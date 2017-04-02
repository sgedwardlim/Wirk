//
//  ReferalComposer.swift
//  ReferalPlus
//
//  Created by Edward on 1/8/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit

class ReferalComposer: NSObject {
    
    let pathToReferalHTMLTemplate = Bundle.main.path(forResource: "referal", ofType: "html")
    let pathToSingleJobHTMLTemplate = Bundle.main.path(forResource: "single_job", ofType: "html")
    
    var company_name: String!
    
    var pdfFilename: String!
    
    override init() {
        super.init()
    }
    
    func renderReferal(company_name: String, default_email_description: String, jobs: [Job]) -> String! {
        // Store the company_name for future use.
        self.company_name = company_name
        
        do {
            // Load the invoice HTML template code into a String variable.
            var HTMLContent = try String(contentsOfFile: pathToReferalHTMLTemplate!)
            
            // Replace all the placeholders with real values except for the items.
            // The company name.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#COMPANY_NAME#", with: company_name)
            // The default email description.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#DEFAULT_EMAIL_DESCRIPTION#", with: default_email_description)
            
            // The jobs will be added by using a loop.
            var allJobs = ""
            
            // For all the items except for the last one we'll use the "single_item.html" template.
            // For the last one we'll use the "last_item.html" template.
            for job in jobs {
                var jobHTMLContent: String!
                // Load single job html template
                jobHTMLContent = try String(contentsOfFile: pathToSingleJobHTMLTemplate!)
                
                // load all the customer values for the selected job
                if let customer = job.customer {
                    if customer.privacy == false {
                        //Only show the customers name and city
                        // sets the style tag to only hide the phone and email fields
                        jobHTMLContent = jobHTMLContent.replacingOccurrences(of: "#HIDDEN_VALUE#", with: "display:none;")
                        jobHTMLContent = jobHTMLContent.replacingOccurrences(of: "#CUSTOMER_NAME#",
                                                                             with: "\(customer.first!) \(customer.last!)")
                        jobHTMLContent = jobHTMLContent.replacingOccurrences(of: "#CUSTOMER_LOCATION#", with: customer.location!)
                        
                    } else {
                        // Show all values of customer
                        // Replace the description and price placeholders with the actual values.
                        jobHTMLContent = jobHTMLContent.replacingOccurrences(of: "#CUSTOMER_NAME#",
                                                                             with: "\(customer.first!) \(customer.last!)")
                        jobHTMLContent = jobHTMLContent.replacingOccurrences(of: "#CUSTOMER_LOCATION#", with: customer.location!)
                        jobHTMLContent = jobHTMLContent.replacingOccurrences(of: "#CUSTOMER_PHONE#", with: customer.phone!)
                        jobHTMLContent = jobHTMLContent.replacingOccurrences(of: "#CUSTOMER_EMAIL#", with: customer.email!)
                    }
                }
                
                // Replace the description and price placeholders with the actual values.
                jobHTMLContent = jobHTMLContent.replacingOccurrences(of: "#JOB_TYPE#", with: job.jobType!)
                jobHTMLContent = jobHTMLContent.replacingOccurrences(of: "#JOB_DESCRIPTION#", with: job.jobDescription!)
                jobHTMLContent = jobHTMLContent.replacingOccurrences(of: "#BEFORE_IMAGE_URL#", with: job.beforeImageUrl!)
                jobHTMLContent = jobHTMLContent.replacingOccurrences(of: "#AFTER_IMAGE_URL#", with: job.afterImageUrl!)
                
                // Add the jobs HTML code to the general items string.
                allJobs += jobHTMLContent
            }
            
            // Set the items.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#JOBS#", with: allJobs)
            
            // The HTML code is ready.
            return HTMLContent
        } catch {
            print("Unable to open and use HTML template files.")
        }
        return nil
    }
    
    func exportHTMLContentToPDF(printFormatter: UIViewPrintFormatter) {
        
        let printPageRenderer = CustomPrintPageRenderer()
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
    
        // 4. Create PDF context and draw
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)
        
        for i in 1 ... printPageRenderer.numberOfPages {
            
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            printPageRenderer.drawPage(at: i - 1, in: bounds)
        }
        
        UIGraphicsEndPDFContext();
        
        // 5. Save PDF file
        pdfFilename = "\(AppDelegate.getAppDelegate().getDocDir())/Referal.pdf"
        pdfData.write(toFile: pdfFilename, atomically: true)
        print(pdfFilename)
        
        
    }
    
    func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData! {
        let data = NSMutableData()
        UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
        UIGraphicsBeginPDFPage()
        printPageRenderer.drawPage(at: 0, in: UIGraphicsGetPDFContextBounds())
        UIGraphicsEndPDFContext()
        
        return data
    }
    
}
