//
//  TemplateSources.swift
//  HalfRoll
//
//  Created by Kristofer Younger on 8/26/22.
//

import Foundation


// let templateData = Data(templateSources.utf8)

let templateSources = """
{ "data":
[
    {
        "title": "Estate Documents",
        "desc": "Will and other items to track with it",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "legal",
                "title": "Will"
            }
        ],
        "assets": [
            {
                "title": "Last Will & Testament Document",
                "desc": "a digital copy of your will",
                "mimetype": "plain/empty"
            },
            {
                "title": "Notes About The Will",
                "desc": "tracking the laywer, or source of your will and information about the will",
                "mimetype": "plain/empty"
            },
            {
                "title": "Healthcare Advance Directive (Living Will)",
                "desc": "document in which you can specify the medical treatments you wish to receive if you become incapacitated and can’t communicate",
                "mimetype": "plain/empty"
            },
            {
                "title": "Medical Power of Attorney",
                "desc": "This is a document that appoints someone to make medical decisions on your behalf. This person becomes known as your health care agent or proxy",
                "mimetype": "plain/empty"
            },
            {
                "title": "Durable Power of Attorney",
                "desc": "document that allows one person to appoint another person to act on their behalf concerning finance, real estate, business, and more",
                "mimetype": "plain/empty"
            }


        ]
    },
    {
        "title": "Buy a Vehicle",
        "desc": "information about a car purchase, collect and attach all the documents you received during the transaction",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "car",
                "title": "Buy a Vehicle"
            },
            {
                "category": "app",
                "desc": "",
                "kind": "money",
                "title": "money"
            },
            {
                "category": "app",
                "desc": "",
                "kind": "thing",
                "title": "Vehicle"
            }

        ],
        "assets": [
            {
                "title": "Notes on the Purchase",
                "desc": "information about the purchasing of ...",
                "mimetype": "plain/empty"
            },
            {
                "title": "Various Documents",
                "desc": "attach all the documents you received during the transaction",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Lease a Vehicle",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "car",
                "title": "Lease a Vehicle"
            },
            {
                "category": "app",
                "desc": "",
                "kind": "money",
                "title": "money"
            },
            {
                "category": "app",
                "desc": "",
                "kind": "thing",
                "title": "Vehicle"
            }
        ],
        "assets": [
            {
                "title": "Notes on the Lease",
                "desc": "information about the purchasing of ...",
                "mimetype": "plain/empty"
            },
            {
                "title": "Various Lease Documents",
                "desc": "attach all the documents you received during the transaction",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "401k/IRA/Pension",
        "desc": "details on a retirement account",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "money",
                "title": "401k/IRA/Pension"
            },
            {
                "category": "app",
                "desc": "",
                "kind": "money",
                "title": "money"
            }

        ],
        "assets": [
            {
                "title": "Retirement Account Notes",
                "desc": "track info on account",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Major Home Repair Incident",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "home",
                "title": "Major Home Repair Incident"
            }
        ],
        "assets": [
            {
                "title": "Notes on Repair",
                "desc": "write down the notes you're keeping from the repair.",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Home Improvement Project",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "home",
                "title": "Home Improvement Project"
            }
        ],
        "assets": [
            {
                "title": "Cost Estimate",
                "desc": "notes on the cost of project",
                "mimetype": "plain/empty"
            },
            {
                "title": "Notes",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Personal Project",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "person",
                "title": "Personal Project"
            }
        ],
        "assets": [
            {
                "title": "Notes",
                "desc": "Notes on Project",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Accident Claim",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "insurance",
                "title": "Accident Claim"
            }
        ],
        "assets": [
            {
                "title": "Information on Claim",
                "desc": "Notes on claim number, etc.",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Robbery/Burglary Claim",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "insurance",
                "title": "Robbery/Burglary Claim"
            }
        ],
        "assets": [
            {
                "title": "Information on Claim",
                "desc": "Notes on claim number, etc.",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Fire Claim",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "insurance",
                "title": "Fire Claim"
            }
        ],
        "assets": [
            {
                "title": "Information on Claim",
                "desc": "Notes on claim number, etc.",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Flood Claim",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "insurance",
                "title": "Flood Claim"
            }
        ],
        "assets": [
            {
                "title": "Information on Claim",
                "desc": "Notes on claim number, etc.",
                "mimetype": "plain/empty"
            },
            {
                "title": "Insurance information",
                "desc": "flood insurance docs",
                "mimetype": "plain/empty"
            }

        ]
    },
    {
        "title": "Fortune Event",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "money",
                "title": "Fortune Event"
            }
        ],
        "assets": [
            {
                "title": "Notes",
                "desc": "information on the bequest, inheritance, etc.",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "New Job",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "track all the data around a new job",
                "kind": "occupation",
                "title": "New Job"
            }
        ],
        "assets": [
            {
                "title": "Offer Letter",
                "desc": "",
                "mimetype": "plain/empty"
            },
            {
                "title": "Details on Offer",
                "desc": "insurance, bank details, ",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Leave Job",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "Resignation and COBRA info on insurance, etc.",
                "kind": "occupation",
                "title": "Leave Job"
            }
        ],
        "assets": [
            {
                "title": "Resignation Letter",
                "desc": "",
                "mimetype": "plain/empty"
            },
            {
                "title": "Insurance details",
                "desc": "",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "School Graduation",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "education",
                "title": "School Graduation"
            }
        ],
        "assets": [
            {
                "title": "Notes",
                "desc": "anything related to finished at a school for a person",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Military to Civilian Transition",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "occupation",
                "title": "Military to Civilian Transition"
            }
        ],
        "assets": [
            {
                "title": "Notes & Details of Transition",
                "desc": "Discharge info, Insurance, Pension details",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Wedding Plans",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "plain",
                "title": "Wedding Plans"
            }
        ],
        "assets": [
            {
                "title": "Ceremony Notes",
                "desc": "things about the ceremony",
                "mimetype": "plain/empty"
            },
            {
                "title": "Reception/Party Notes",
                "desc": "things about the reception",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Marriage Documents",
        "desc": "docs related to your marriage",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "plain",
                "title": "Marriage Documents"
            }
        ],
        "assets": [
            {
                "title": "Marriage License",
                "desc": "scan or import of license doc",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Jewelry",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "thing",
                "title": "Jewelry"
            }
        ],
        "assets": [
            {
                "title": "Appraisal",
                "desc": "docs about the value of the jewelry",
                "mimetype": "plain/empty"
            },
            {
                "title": "Insurance",
                "desc": "docs regarding the insurance of the items",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Collectables",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "thing",
                "title": "Collectables"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Retirement Account",
        "desc": "any docs related to your retirement money",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "money",
                "title": "Retirement Account"
            }
        ],
        "assets": [
            {
                "title": "Notes on Your Retirement Money",
                "desc": "",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Retirement Details",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "money",
                "title": "Retirement Details"
            }
        ],
        "assets": [
            {
                "title": "Retirement Notes",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Pension Plan",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "money",
                "title": "Pension Plan"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Pension Contacts and Details",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "money",
                "title": "Pension Contacts and Details"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Divorce Decree",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "plain",
                "title": "Divorce Decree"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Divorce Legal Records",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "plain",
                "title": "Divorce Legal Records"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Acquired Vacation/Rental Property",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "money",
                "title": "Acquired Vacation/Rental Property"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Sold Real Estate",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "home",
                "title": "Sold Real Estate"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Manage Student Loan",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "education",
                "title": "Manage Student Loan"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Study Abroad",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "education",
                "title": "Study Abroad"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "College Applications",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "education",
                "title": "College Applications"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "College Finances",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "money",
                "title": "College Finances"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Motorcycle",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "thing",
                "title": "Motorcycle"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Watercraft",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "thing",
                "title": "Watercraft"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "RV",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "thing",
                "title": "RV"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Personal Watercraft",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "thing",
                "title": "Personal Watercraft"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "4-wheeler",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "thing",
                "title": "4-wheeler"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Electric",
        "desc": "electric service account details",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "home",
                "title": "Electric"
            }
        ],
        "assets": [
            {
                "title": "Account Details and Notes",
                "desc": "information about the account",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Water/Sewer",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "home",
                "title": "Water/Sewer"
            }
        ],
        "assets": [
            {
                "title": "Account Details and Notes",
                "desc": "information about the account",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Landline Phone",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "home",
                "title": "Landline Phone"
            }
        ],
        "assets": [
            {
                "title": "Account Details and Notes",
                "desc": "information about the account",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Cable/Satellite TV",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "home",
                "title": "Cable/Satellite TV"
            }
        ],
        "assets": [
            {
                "title": "Account Details and Notes",
                "desc": "information about the account",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Trash",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "home",
                "title": "Trash"
            }
        ],
        "assets": [
            {
                "title": "Account Details and Notes",
                "desc": "information about the account",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Wireless or Internet",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "home",
                "title": "Wireless Internet"
            }
        ],
        "assets": [
            {
                "title": "Account Details and Notes",
                "desc": "information about the account",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Yard/Pool Service",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "home",
                "title": "Yard/Pool Service"
            }
        ],
        "assets": [
            {
                "title": "Account Details and Notes",
                "desc": "information about the account",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Electrician Repair",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "home",
                "title": "Electrician Repair"
            }
        ],
        "assets": [
            {
                "title": "Repair Details and Notes",
                "desc": "information about the account",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Plumber Repair",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "home",
                "title": "Plumber Repair"
            }
        ],
        "assets": [
            {
                "title": "Repair Details and Notes",
                "desc": "information about the account",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Contractor Repair",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "home",
                "title": "Contractor Repair"
            }
        ],
        "assets": [
            {
                "title": "Repair Details and Notes",
                "desc": "information about the account",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Purchase Residence",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "home",
                "title": "Purchase Residence"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Lease/Rent residence",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "home",
                "title": "Lease/Rent residence"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Sold a Residence",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "home",
                "title": "Sold a Residence"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Leave Old Residence",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "home",
                "title": "Leave Old Residence"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Move into New Residence",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "home",
                "title": "Move into New Residence"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Checking",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "money",
                "title": "Checking"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Savings",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "money",
                "title": "Savings"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Credit Card",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "money",
                "title": "Credit Card"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Brokerage Account",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "money",
                "title": "Brokerage Account"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Tax Return",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "tax",
                "title": "Tax Return"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Tax Prep Documents",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "tax",
                "title": "Tax Prep Documents"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Property Tax",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "tax",
                "title": "Property Tax"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "School Tax",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "tax",
                "title": "School Tax"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "State Tax",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "tax",
                "title": "State Tax"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Other Tax",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "tax",
                "title": "Other Tax"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Personal Loan",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "money",
                "title": "Personal Loan"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Normal Car Maintenance",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "car",
                "title": "Normal Car Maintenance"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Major Repair (Car)",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "car",
                "title": "Major Repair (Car)"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Buy a Vehicle",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "car",
                "title": "Buy a Vehicle"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Lease a Vehicle",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "car",
                "title": "Lease a Vehicle"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Sold a Vehicle",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "car",
                "title": "Sold a Vehicle"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Doctor Visit",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "medical",
                "title": "Doctor Visit"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Doctor Physical",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "medical",
                "title": "Doctor Physical"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Emergency Room Visit",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "medical",
                "title": "Emergency Room Visit"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Out-patient event",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "medical",
                "title": "Out-patient event"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Hospitalization",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "medical",
                "title": "Hospitalization"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Medical Equipment",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "medical",
                "title": "Medical Equipment"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Procedure",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "medical",
                "title": "Procedure"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Major Illness",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "medical",
                "title": "Major Illness"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Accident",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "medical",
                "title": "Accident"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Chronic Condition",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "medical",
                "title": "Chronic Condition"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Allergies",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "medical",
                "title": "Allergies"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Prescriptions",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "medical",
                "title": "Prescriptions"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Emergency POC",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "medical",
                "title": "Emergency POC"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Family History Notes",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "medical",
                "title": "Family History Notes"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Immunizations",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "medical",
                "title": "Immunizations"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Living Will/Advanced Directive",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "legal",
                "title": "Living Will/Advanced Directive"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Durable power of Attorney (Health)",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "legal",
                "title": "Durable power of Attorney (Health)"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Notes on Health",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "legal",
                "title": "Notes on Health"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Trust",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "legal",
                "title": "Trust"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    },
    {
        "title": "Personal Project",
        "desc": "",
        "tags": [
            {
                "category": "app",
                "desc": "",
                "kind": "plain",
                "title": "Personal Project"
            }
        ],
        "assets": [
            {
                "title": "placeholder",
                "desc": "desc_placeholder",
                "mimetype": "plain/empty"
            }
        ]
    }
]
}
"""

let globalTemplateData = Data(templateSources.utf8)

