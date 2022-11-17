# Notes on the Data Model.

#### 16 Nov 2023

Using the `HalfRoll` design of the `viewcontext` being part of the Storage, not part of each class/object in coredata.

## Folio

The one and only top-level grouping mech. Like a folder, with advanced metadata. Folios cannot be nested.

- <entity name="Folio" representedClassName="Folio" syncable="YES" codeGenerationType="class">

- <attribute name="desc" optional="YES" attributeType="String" spotlightIndexingEnabled="YES"/>
 Describes the folio
- <attribute name="favorite" optional="YES" attributeType="Boolean" usesScalarValueType="YES"/>
- <attribute name="id" optional="YES" attributeType="UUID" usesScalarValueType="NO"/>
- <attribute name="thumbnail" optional="YES" attributeType="Binary" allowsExternalBinaryDataStorage="YES"/>
  Image of Folio, should be set by user.
- <attribute name="title" optional="YES" attributeType="String" spotlightIndexingEnabled="YES"/>
 Display name of folio.

- <relationship name="assets" optional="YES" toMany="YES" deletionRule="No Action" destinationEntity="Asset" inverseName="folio" inverseEntity="Asset"/>
Folio.attachAsset(Asset); Folio.removeAsset(Asset); 
- <relationship name="tags" optional="YES" toMany="YES" deletionRule="No Action" destinationEntity="Tag" inverseName="folios" inverseEntity="Tag"/>
Folio.attachTag(Tag); Folio.removeTag(Tag); 


- </entity>


## Asset

An item kept in the tool. 
Usually a file, although a Github account can be a Folio, with repos being Assets inside.
Digital assets need extra care in the Asset class.

- <entity name="Asset" representedClassName="Asset" syncable="YES" codeGenerationType="class">

- <attribute name="blob" optional="YES" attributeType="Binary" allowsExternalBinaryDataStorage="YES" spotlightIndexingEnabled="YES"/>
- <attribute name="desc" optional="YES" attributeType="String" spotlightIndexingEnabled="YES"/>
- <attribute name="id" optional="YES" attributeType="UUID" usesScalarValueType="NO"/>
- <attribute name="mimetype" optional="YES" attributeType="String" spotlightIndexingEnabled="YES"/>
- <attribute name="pathname" optional="YES" attributeType="String"/>
 path/file name from source of file. 
- <attribute name="source" optional="YES" attributeType="URI"/>
 This can be a file URL OR a URI from Tioag (or maybe someday a third party).
 
- <attribute name="thumbnail" optional="YES" attributeType="Binary"/>
 Image of Asset (if a document)
- <attribute name="title" optional="YES" attributeType="String" spotlightIndexingEnabled="YES"/>
    Display name of Asset
- <attribute name="uttype" optional="YES" attributeType="String" spotlightIndexingEnabled="YES"/>

- <relationship name="folio" optional="YES" maxCount="1" deletionRule="No Action" destinationEntity="Folio" inverseName="assets" inverseEntity="Folio"/>
- <relationship name="notes" optional="YES" maxCount="1" deletionRule="Nullify" destinationEntity="Note" inverseName="asset" inverseEntity="Note"/>
- <relationship name="olderblobs" optional="YES" maxCount="1" deletionRule="Nullify" destinationEntity="OlderBlob" inverseName="asset" inverseEntity="OlderBlob"/>
- <relationship name="previews" optional="YES" maxCount="1" deletionRule="Nullify" destinationEntity="Preview" inverseName="asset" inverseEntity="Preview"/>
- <relationship name="tags" optional="YES" toMany="YES" deletionRule="No Action" destinationEntity="Tag" inverseName="assets" inverseEntity="Tag"/>
- </entity>

## Tag

Used for categorization of Folios and Assets. Both system created and user created/maintained.

- <entity name="Tag" representedClassName="Tag" syncable="YES" codeGenerationType="class">

- <attribute name="category" optional="YES" attributeType="String" spotlightIndexingEnabled="YES"/>
- <attribute name="kind" optional="YES" attributeType="String" spotlightIndexingEnabled="YES"/>

- <attribute name="desc" optional="YES" attributeType="String" spotlightIndexingEnabled="YES"/>
- <attribute name="favorite" optional="YES" attributeType="Boolean" defaultValueString="NO" usesScalarValueType="YES"/>
- <attribute name="id" optional="YES" attributeType="UUID" usesScalarValueType="NO"/>
- <attribute name="ref" optional="YES" attributeType="URI"/>
     This can be a file URL OR a URI from Tioag (or maybe someday a third party).
- <attribute name="refstring" optional="YES" attributeType="String"/>
    More reference text as needed.
- <attribute name="thumbnail" optional="YES" attributeType="Binary" allowsExternalBinaryDataStorage="YES"/>
- <attribute name="title" optional="YES" attributeType="String" spotlightIndexingEnabled="YES"/>
    Display name

- <relationship name="assets" optional="YES" toMany="YES" deletionRule="No Action" destinationEntity="Asset" inverseName="tags" inverseEntity="Asset"/>
- <relationship name="folios" optional="YES" toMany="YES" deletionRule="No Action" destinationEntity="Folio" inverseName="tags" inverseEntity="Folio"/>
- </entity>

## Extras

### Note

A textual file attached to an Asset. TF should be able to edit Note, create/delete Note.
One Asset to many Notes.

11/17/22 added a mimetype field for tracking text or json or....

- <entity name="Note" representedClassName="Note" syncable="YES" codeGenerationType="class">

- <attribute name="mimetype" attributeType="String" defaultValueString="" spotlightIndexingEnabled="YES"/>
- <attribute name="detailtext" attributeType="String" defaultValueString="" spotlightIndexingEnabled="YES"/>
- <attribute name="id" optional="YES" attributeType="UUID" usesScalarValueType="NO"/>
- <attribute name="title" attributeType="String" defaultValueString="" spotlightIndexingEnabled="YES"/>

- <relationship name="asset" optional="YES" maxCount="1" deletionRule="Nullify" destinationEntity="Asset" inverseName="notes" inverseEntity="Asset"/>
- </entity>

### OlderBlob

As blobs in Asset get superceded, the idea is to copy the old asset blob to an OlderBlob and arrach to Asset.
One Asset to Many OlderBlobs.

- <entity name="OlderBlob" representedClassName="OlderBlob" syncable="YES" codeGenerationType="class">

- <attribute name="blob" optional="YES" attributeType="Binary" allowsExternalBinaryDataStorage="YES"/>
- <attribute name="id" optional="YES" attributeType="UUID" usesScalarValueType="NO"/>

- <relationship name="asset" optional="YES" maxCount="1" deletionRule="No Action" destinationEntity="Asset" inverseName="olderblobs" inverseEntity="Asset"/>
- </entity>

### Preview

a PDF of the current Asset blob. 
If the blob gets superceded, the idea would be to generate a new PDF-preview document.

- <entity name="Preview" representedClassName="Preview" syncable="YES" codeGenerationType="class">

- <attribute name="blob" optional="YES" attributeType="Binary"/>
- <attribute name="id" optional="YES" attributeType="UUID" usesScalarValueType="NO"/>
- <attribute name="mimetype" optional="YES" attributeType="String"/>

- <relationship name="asset" optional="YES" maxCount="1" deletionRule="No Action" destinationEntity="Asset" inverseName="previews" inverseEntity="Asset"/>
- </entity>
    

## Import and Export

`google: xcdatamodel to json`

Needs to take entire CoreData Archive and spool it to a tarfile (EXPORT). 
And, an inverse operation of IMPORT, take a tarfile and load it back up to an archive.
