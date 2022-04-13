//
//  PhotoPicker.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-13.
//

import Foundation
import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = PHPickerViewController

    // Can be .images, .livePhotos or .videos
    let filter: PHPickerFilter

    // How many photos can be selected. 0 means no limit.
    var limit: Int = 0

    func makeUIViewController(context: Context) -> PHPickerViewController {

        // Create the picker configuration using the properties passed in above.
        var configuration = PHPickerConfiguration()
        configuration.filter = filter
        configuration.selectionLimit = limit

        // Create the view controller.
        let controller = PHPickerViewController(configuration: configuration)

        // Link it to the Coordinator created below.
        controller.delegate = context.coordinator
        return controller
    }

    // This method is blank because it will never be updated.
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: PHPickerViewControllerDelegate {

        // The coordinator needs a reference to the thing it's linked to.
        private let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        // Called when the user finishes picking a photo.
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

            // Dismiss the picker.
            picker.dismiss(animated: true)
        }
    }
}
