//
//  TaggerView.swift
//  Carolina
//
//  Created by Kristofer Younger on 10/13/21.
//
//
//  TaggerView.swift
//
//  Created by Alex Hay on 21/11/2020.
//
// Simple interface for adding tags to an array in SwiftUI
// Example video: https://imgur.com/gallery/CcA1IXp
// alignmentGuide code from Asperi @ https://stackoverflow.com/a/58876712/11685049

import SwiftUI

/// The main  view to add tags to an array
struct TaggerView: View {
    
    @State var newTag = ""
    @State var tags = ["example","hello world"]
    @State var showingError = false
    @State var errorString = "x" // Can't start empty or view will pop as size changes
    
    var body: some View {
        VStack(alignment: .leading) {
            ErrorMessage(showingError: $showingError, errorString: $errorString)
            TagEntry(newTag: $newTag, tags: $tags, showingError: $showingError, errorString: $errorString)
            TagList(tags: $tags)
        }
        .padding()
        .onChange(of: showingError, perform: { value in
            if value {
                // Hide the error message after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    showingError = false
                }
            }
        })
    }
}

/// A subview that displays a message when an error occurs
struct ErrorMessage: View {
    
    @Binding var showingError: Bool
    @Binding var errorString: String
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
            Text(errorString)
                .foregroundColor(.secondary)
                .padding(.leading, -6)
        }
        .font(.caption)
        .opacity(showingError ? 1 : 0)
        // had animation here?
    }
}

/// A subview that contains the text-entry field for entering new tags
struct TagEntry: View {
    
    @Binding var newTag: String
    @Binding var tags: [String]
    @Binding var showingError: Bool
    @Binding var errorString: String
    
    var body: some View {
        HStack {
            TextField("Add Tags", text: $newTag, onCommit: {
                addTag(newTag)
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.none)
            Spacer()
            Image(systemName: "plus.circle")
                .foregroundColor(.blue)
                .onTapGesture {
                    addTag(newTag)
                }
        }
        .onChange(of: newTag, perform: { value in
            if value.contains(",") {
                // Try to add the tag if user types a comma
                newTag = value.replacingOccurrences(of: ",", with: "")
                addTag(newTag)
            }
        })
    }
    
        /// Checks if the entered text is valid as a tag. Sets the error message if it isn't
    private func tagIsValid(_ tag: String) -> Bool {
        // Invalid tags:
        // - empty strings
        // - tags already in the tag array
        let lowerTag = tag.lowercased()
        if lowerTag == "" {
            showError(.Empty)
            return false
        } else if tags.contains(lowerTag) {
            showError(.Duplicate)
            return false
        } else {
            return true
        }
    }
    
    /// If the tag is valid, it is added to an array, otherwise the error message is shown
    private func addTag(_ tag: String) {
        if tagIsValid(tag) {
            tags.append(newTag.lowercased())
            newTag = ""
        }
    }
    
    private func showError(_ code: ErrorCode) {
        errorString = code.rawValue
        showingError = true
    }
    
    enum ErrorCode: String {
        case Empty = "Tag can't be empty"
        case Duplicate = "Tag can't be a duplicate"
    }
}

/// A subview containing a list of all tags that are in the array. Tags flow onto the next line when wider than the view's width
struct TagList: View {
    
    @Binding var tags: [String]
    
    var body: some View {
        GeometryReader { geo in
            generateTags(in: geo)
            .padding(.top)
        }
    }

    /// Adds a tag view for each tag in the array. Populates from left to right and then on to new rows when too wide for the screen
    private func generateTags(in geo: GeometryProxy) -> some View {
        var width: CGFloat = 0
        var height: CGFloat = 0

        return ZStack(alignment: .topLeading) {
            ForEach(tags, id: \.self) { tag in
                TagBody(tag: tag, tags: $tags)
                .alignmentGuide(.leading, computeValue: { tagSize in
                    if (abs(width - tagSize.width) > geo.size.width) {
                        width = 0
                        height -= tagSize.height
                    }
                    let offset = width
                    if tag == tags.last ?? "" {
                        width = 0
                    } else {
                        width -= tagSize.width
                    }
                    return offset
                })
                .alignmentGuide(.top, computeValue: { tagSize in
                    let offset = height
                    if tag == tags.last ?? "" {
                        height = 0
                    }
                    return offset
                })
            }
        }
    }
}

/// A subview of a tag shown in a list. When tapped the tag will be removed from the array
struct TagBody: View {
    
    var tag: String
    @Binding var tags: [String]
    
    var body: some View {
        HStack {
            Text(tag.lowercased())
                .padding(.leading, 2)
            Image(systemName: "tag")//"xmark.circle.fill")
                .opacity(0.4)
                .padding(.leading, -6)
        }
        .foregroundColor(.white)
        .font(.caption2)
        .padding(4)
        .background(Color.blue.cornerRadius(5))
        .padding(4)
//        .onTapGesture {
//            tags = tags.filter({ $0 != tag })
//        }
    }
}

struct TaggerView_Previews: PreviewProvider {
    static var previews: some View {
        TaggerView()
    }
}
