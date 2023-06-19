# Tioga Folio

For MVP

## Current Issues (13 June 2023)

- initial folios
- draft of onboarding pages
- SHARING is working but brittle. needs to not delete graph at end of share.
- foliodetail is STILL not updating after edits
- must be able to move an asset to a different folio
- linkage to web-based help docs? (or built into app?)
- the list of folios doesn't seem to appear in share extension without app restart
- Does Sharing actually work?

Bugs

- updating on the FolioDetail page...
- tag adding?

New Features

- simply share a single Folio
- stop Sharing w/o losing data of folios
- deduplicate of tags that get shared.
- pictures of tag subjects
- pictures on folios


## a great idea 

```
    let result = Result(catching: {
      try somethingthat_throws()
    })
    // will auto-wrap an error, if you get one, 
    // otherwise result is .success and has the resultant obj(s)
    completion(result)
```
MVP achieved (28 Nov 2022), but no Sharing (yet)

- BACKUPS
- SHARING
- Tag adding crash
- unify the LifeEvents into the NewFolio view
- some onboarding views
- deleting folios, with some kind of "backup""
- menu additions for
  - scan, photo,
- text note editing
- help pages
- intro (first time start) pages
- file search ? (can spotlight do this? why the hell not?)
- URL scheme inside app,
- scene storage of the selected folio
- calendar view of folios?
- load a folder full of stuff to a folio
- move assets among folios

- Create ops for Notes, OlderBlobs, Previews?

## HalfRoll Readme
#  HalfRoll

a half-a-roll stores document stuff

# SHARING & Share Extension

- https://www.raywenderlich.com/29934862-sharing-core-data-with-cloudkit-in-swiftui

TheString
LifeNotes
LifeLog


phased dev; each phase adds specific caps

- 1 Document/File store as Assets
  - add from Files
  - scan?
  
- 2 Folios added to sort them.
 - prob need a hierarchy?

Might add a help center (backed by a github pages site)
https://github.com/aheze/SupportDocs


## TODOs

- add ShareController
- copy over doc files
- thumbnails on docs and tags?
- Categories...
- Life Events - special empty folios loadable from web template
  - docs/assets 
  - JSON file template


### Categories

Top level Tag classes. 
- Money/Finances
- House/Residence
- Insurance
- Taxes

### Life Event Templates

- Birth of a Child
- New House
- Moving Residense
- ...

```json
    {
        "title": "Last Will and Testament",
        "desc": "",
        "tags": [
            {
            "category": "app",
            "desc": "items that are part of your estate",
            "kind": "legal",
            "title": "Will"
            },
        ]
        "assets": [
            {
            "title": "Last Will and Testament",
            "desc": "file either document or PDF",
            "source": "uri:"
            }
        ]
    },

```

### Digital placeholder

- a Domain reg
- a Github account
  - Repo/Projects
- Music collections
- Ebook collections



## Carolina Readme
#  Carolina

(4 Aug 22) moved all projects from ~/Documents/Projects
stop using iCloud for git repo projects!!


simple personal vault app, and tagging archive app
focus on storage security

## Big Concepts

- tiogaCarolina (codename)
  - storage for personal docs like many personal notes and private vaults
  - backed by a DAT
  - sharable with SOs
  - everything zero-knowledge encrytped
  
- each item 
  - is kept in original binary format (and a PDF mirror alongside)
  - archive date is stored
  - metadata is kept on all assets
- tags can be applied
  - tags for search

## Plan for Folios(June '22)

- the “backend business logic” needs to be isolated, with an API and a iCloud Backend
- business logic in swift;
- Data Model of the storage items
- business LOGIC
  - Import/export
- apps
  - simple storage retreiver
  - pieces of (eventual) real Folios app
  - share extension
  - folio share between two apple IDs
  - email inbox
  - search of items

## Sprints

- tao gitea
- swift enchive (enshive)
- a top level repo for all TD items
- notes on the website, the history, presos etc
- a folder of everything over time copied


### Settings

- PDF style/size for all mirror docs

### ToDo

- MailKit: https://developer.apple.com/documentation/mailkit
- read https://blog.cubbit.io/blog-posts/what-is-zero-knowledge-encryption
- ADD scanning menu like the one I saw!
- a document listing, more like DropBox's or Mail's
- attach tag to a doc
- make tag lists work in docview(?)
- should tags and assets have scoring information attached to them?
- change the data model to save scoring data?
- add DATrust info
- add a text "file" to docs
- see below for Extension

### Bugs

- after editing text, the DocView does NOT re-build the PreviewController'd view of the text document.

### Extension: Archive to Folio

- DONE: added a way to archive a blob from a url using async methods.
- link Fetching.swift into the share extension; KISS.
- share extension, Add To Folio an item from the share mechanism
- need a way to pick the folio to attach the item to
- the item needs to be created to BlobAsset, saved into the viewContext
- i found this picker example: https://github.com/scottfister/floop/tree/master/ShareExtension

### Scoring

Scoring is for determining whether a document is important or not.
Scoring should be applied in a black box, producing a short phrase of scores?
Should each term that gets scored be part of that result?
Such as a DocA which returns [['tioga', 0.978], ['kristofer', 0.99], ['folios', 0.91]]
Such a result will carry useful(?) info into the next phase of processing.

- prioritize emails as first document format for extraction and scoring?
- each asset should have a overall score of importance
- assets need to be textract'd and then analyzed
  - tf-idf to determine key words/phrases (?)
  - do tags have relative importance scores _of their own_?
  - what about auto-tagging on import?
  - can tags be used as input to the scanning process?
  - a tag's existance implies importance?
  
### Done

- document import
- attach doc to a folio
- get icloud saving of core data
- add editable tags
- editing the kind in a tag doesn't work
- text editor for Notes in Folios
- added a way to create a Text Note. see settings.

## Notes

- FileDocument protocol could be used to save folio and their items into a Files app on any platforms.
- some magic about how to EDIT pdf files (and perhaps others) in Quick Look
- https://www.raywenderlich.com/10447506-quicklook-previews-for-ios-getting-started
- https://developer.apple.com/videos/play/wwdc2019/719
- a TSA https://gist.github.com/mapehe/061e44c9c7d48ad20725d20c7a53638d
 
 ### Mini Projects
 
 ### AWS email pipeline

- email a message to archive@
- flows thru a AWS email pipeline and placed into a s3 bucket
- is encryted by enshive for at rest
- is decrypted by app when fetched
- secure messaging over apple notifications

Need to document the steps taken for the email pipeline on AWS
there may be notes somewhere from when I built it.

I really need a large THIS IS HOW IT ALL GOES together repo
maybe a gitea on tao.

 #### email_grab
 
 a small python tool which logins into a IMAP mail account and extracts emails and places them in a flatfile db. 
 the key will be the url formed from the mailbox name and the message id within it.
 NEED a Oauth2 login scheme - the damn gmail imap server no longer takes login/pw
 
 As of 1/4/22; there is a small google app that can login into a named gmail account and retireve IMAP based emails.
 Why oh why is there no .email file format??
 
 the namespace identifier should be made from the email address and the mailbox name?
 
 
 ### email_sink
 
 what about using something like Exim to setup an email server, one that answers to "import@tioga.co" where 
 the user's email address is used to direct the email to a specific tioga account.
 Then, a folios instance can login to an API server and retrieve the things the users wishes to import.
 Wht has to happen to control access to this server? Something any email server can do? 
 Maybe it ignores any From address that is not registered? Is that enough?

## Naming

### Possible Names

- TiogaFolios
- TiogaEstate
- LifeFolios
- AtticFolios
- ThatBox
- FolioPapers
- DigitalEstate
- Folios/ACT
- ACT/Folios


### Names that cannot be used

- lockbox
- vault
- keep



## Company Notes (carolina)
#  Tioga Company Notes (June '22)

Tiogadigital.com is one of the many digital properties owned by TDA.

"tioga.digital" is stored at network solutions; I'll figure out a way to point it to t..d...com.
the email on record for that account is kyounger@td...

the current website is a simple static site out of S3, with a hugo-generated subtree
of the historical documents I created for the last Matt/Jon battle.

Some of that can be used now to get the current ideas whipped into shape, along with
documents I've been drafting on RuitOceanoNox.

It probably makes sense to talk to Desa about all of it, and see if she has interest in
helping in some way. 
(as of late June, Desa was read into the project from a conceptual point of view. She was very intrigued.)


Perhaps the best thing to do is to use Ghost 5 and just create a new subscription site for the journey. *Help people manage their decades*.
A digital estate is created over decades. Important documents, digital assets and virtual creations all form the things we need
to manage and track. Things age, are important now, and become more of our past as we live and learn.
We need a way to handle our digital estate; to track important things over many years and even decades.

*who will have the first digital estate which spans a **century**?*

The journey is before us, take a step...

### Ghost 5

https://hub.docker.com/_/ghost/

to run it in docker.

Setup blog.tiogadigital.com
also found and corrected the DNS on `tioga.digital` refers to main website now.
main website runs on Github ghpages service.



from App Idea (carolina)
##  App Idea

## a personal doc lockbox "Tioga Estate"

- docs are kept behind a second layer of auth
- docs attached to Access Control Trust
- can be shared with SOs
- org'd into Folios
- docs receipt'd to Tioga's blockchain (like chronicle was)
  - proves Earliest Date
  - each doc in trust is Governed
  - trust has real world connections

- federated identity-trust needed?
- but just use Login With Apple (since icloud is one of the stores)

MVP is pretty simple, with just import
share extension and email submission TBD

Maybe the blockchain is really nothing more than a way to use a TSA for tracking items and events.
https://gist.github.com/mapehe/061e44c9c7d48ad20725d20c7a53638d

## August Ideas 2022

How to "Edit slider" on all items which can be changed (simple SwiftUI view)
Enchive in swift. To save off the assets into iCloud.

## July Ideas 2022

Tags, separate Folios from others, make it a tabbed interface?
SHARE! need to look into how to share folios with trusted others.
Settings should be more than a single page.

## 17 May Sprint

- thank god, https://github.com/krzyzanowskim/CryptoSwift is still out there.
- enshive is the idea of enchive in swift
  - a CLI that does the enchive method
  - a library that can do in an app too
  - secrets are the same as enchive
- cryptoswift does or doesn't have a curve25519 impl http://cr.yp.to/ecdh.html
  - it is a diffie-helman function
  - but there is a ref to https://github.com/pebble8888/ed25519swift
  - huh, lookee here: RFC8032 Edward-Curve Digital Signature Algorithm (EdDSA) (!)
  - which looks like a simple impl of it
- gitea on tao?
- move gitea from tioga.co?

## Tags

tags should be used to form structure in the document/folio soup.
they may need to be "hierarchical" or at least able to be AND'd.
they do have a UUID; which can be used when the archival exports are made.
folios are still the only "special" tag.
""



See: https://medium.com/@adammillers/cksharing-step-by-step-33800c8950d2

01. Public database: this is where you’d store things you want everyone to be able to access. There are no custom zones in Public databases, everything exists in the default zone.
02. Private database: This is where you store records that you don’t want the public to see. The private database has a default zone, and users can create custom zones. Important: put anything you want to share in custom zones in your private database.
03. Shared database: This database holds the “windows into objects” that you have been given access to. The records you see in the shared database exist on other people’s private databases. You just have a window into that object. Another way of saying it is that you are a “contributor” to the items in your shared database, not the owner.
04. Don’t let the term “shared zone” trip you up. There’s no such thing as a CKRecordZone that you put records in where it’s just automatically shared with another user. The shared zone is just a zone created for you to access and add shared records, but it by itself does not cause the objects to be shared, more on this later.
05. The CKShare ObjectCKShare is a CKRecord that acts like a portal from you private database to another user’s shared database. The CKShare is attached to a CKRecord by the server, all you do is create the CKShare and indicate which record you want to attach it to. You add it just like any other CKRecord, through a CKModifyRecordsOperation. When you add a CKShare object, it will create a record type in your dashboard, which you can inspect. It even tells you through drop downs who the various users are and if they’ve accepted the invitation or not!
06. There are two ways to identify who you want to share something with. One is a “Custom” route, and the other way is the UICloudSharingController route.

A. Custom: I’m not going to go too much into the custom route, but it involves getting permission for userDiscoverability using:

CKContainer.default().requestApplicationPermission(...)

You’ll need to include that you’re requesting .userDiscoverability, and set a completionHandler. This method will get let other users see that you have used this app and allows you to be discovered. This will allows users to find and manipulate CKUserIdentity objects, which let them set up sharing. You can make some pretty easy to use experiences doing this, but its a lot more development work. There’s an easier way…

B. UICloudSharingController: As you can tell from the “UI” part, this is a view that you present to the user that lets them select who they’d like to share with. In creating this view, you also have to indicate the object you’re going to share, as well as creating the CKShare object.

// Note: employeeRecord is the CKRecord I need to sharelet share = CKShare(rootRecord: employeeRecord)share[CKShareTitleKey] = "Some title" as CKRecordValue?share[CKShareTypeKey] = "Some type" as CKRecordValue?let sharingController = UICloudSharingController    (preparationHandler: {(UICloudSharingController, handler:       @escaping (CKShare?, CKContainer?, Error?) -> Void) in    let modifyOp = CKModifyRecordsOperation(recordsToSave:         [employeeRecord, share], recordIDsToDelete: nil)    modifyOp.modifyRecordsCompletionBlock = { (record, recordID,         error) in        handler(share, CKContainer.default(), error)    }    CKContainer.default().privateCloudDatabase.add(modifyOp)})sharingController.availablePermissions = [.allowReadWrite,        .allowPrivate]sharingController.delegate = selfself.present(sharingController, animated:true, completion:nil)


First we create a CKShare object using the root record we’d like to share. In our instance, we’re going to share an Employee record (more on why this is in a bit)
Then we set title and type keys. These show up in your dashboard, I wish i could tell you what these do, but I haven’t figured out exactly what their purpose is yet :-)
Then we create our UICloudSharingController, which takes a preparationHandler as an argument. In the preparationHandler you need to add both the share and the Employee record to the private database at the same time, so they’re available to be shared.
Then we set permissions, like if we want anyone to be able to access this Employee, or just people we invite. Then we set the delegate to ourselves, and present the sharingController.
Voila!

The name in the middle of the screen is the title of the object that I’m trying to share. In this case I’m sharing an “Employee” record so I’m using Alice’s name, but if you’re sharing a document it would be the document name, etc… The email address below is your iCloud email address. You set the image in the middle of the screen and the title through delegate methods.
func cloudSharingController(_ controller: UICloudSharingController, failedToSaveShareWithError error: Error) {    // Failed to save, handle the error better than I did :-)    // Also, this method is required!    print(error)}func itemThumbnailData(for: UICloudSharingController) -> Data? {    // This sets the image in the middle, nil is the default           document image you see, this method is not required    return nil}func itemTitle(for: UICloudSharingController) -> String? {    // Set the title here, this method is required!    // returning nil or failing to implement delegate methods        results in "Untitled"    return "Alice Campbell"}// There are additional delegate methods, see the docs.
This whole interface is intended to help you send a link to another user. The link is a URL that when opened, will open the app on the other user’s device and call a method in the App Delegate called userDidAcceptCloudKitShare… You need to implement this method in your app delegate, or else the user will not be able to accept a share.
func application(_ application: UIApplication,     userDidAcceptCloudKitShareWith cloudKitShareMetadata:     CKShareMetadata) {        let acceptShareOperation: CKAcceptSharesOperation =         CKAcceptSharesOperation(shareMetadatas:         [cloudKitShareMetadata])        acceptShareOperation.qualityOfService = .userInteractive    acceptShareOperation.perShareCompletionBlock = {meta, share,         error in        print("share was accepted")    }    acceptShareOperation.acceptSharesCompletionBlock = {        error in        /// Send your user to where they need to go in your app    }    CKContainer(identifier:        cloudKitShareMetadata.containerIdentifier).add        (acceptShareOperation)}
TL;DR, we’re accepting the share here, and we have an opportunity to put the user in the correct place in our UI to indicate success.
Employee with, access this new record I’m creating.

That’s basically it.
A. Create your records in your private database in custom zones
B. Share those records using a CKShare record once you know who you’re sharing it with.
C. Access records shared with you from the shared database, but remember this is just a window into someone else’s private database.
D. Share additional records by adding the originally shared record under the Parent property of your new records•Subscriptions work from their respective databases, ie. creators subscribe through their private database, and contributors subscribe through the shared database.



## Zones and Records Oh My

'''
func addRecordToCustomZone() {       
    let ckRecordZoneID = CKRecordZone(zoneName: "CustomZoneName")
    let ckRecordID = CKRecord.ID(zoneID: ckRecordZoneID.zoneID)
    // let ckRecordID = CKRecord.ID(recordName: "SomeUniqueName", zoneID: ckRecordZoneID.zoneID)
    let aRecord = CKRecord(recordType: "Cars", recordID: ckRecordID)// Cars is the data Type

    aRecord["carMake"] = "Porche" // carMake is a field in the Cars Type.
    aRecord["carModel"] = "Carrera" // carModel is a field in the Cars Type.
    
    privateDatabase.save(aRecord, completionHandler: { (record, error) -> Void in
        if let error = error {
            print(error)
        }
        else {
            print("record saved successfully")
        }
    })
}
'''

Please note that you also have the option of adding your own record name if you like by specifying it in the `CKRecord.ID` as follow.

'''
'let ckRecordID = CKRecord.ID(recordName: "SomeUniqueName", zoneID: ckRecordZoneID.zoneID)
'''


