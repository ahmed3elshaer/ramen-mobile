//
//  Images.swift
//  BricksUI
//
//  Copyright © 2020 by a cool group. All rights reserved.
//

import SwiftUI

extension Image {
    
    //MARK: Avatars
    
    ///Turn image into a circular avatar
    func avatarCircle() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            .padding(.all, 16)
        
    }
    
    ///Turn image into a rectangular avatar
    func avatarSquare() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .clipShape(Rectangle())
            .padding(.all, 16)
        
    }
    ///Turn image into a rounded rectangle avatar
    func avatarRounded() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .padding(.all, 16)
        
    }
    
    //MARK: Styled Images
    
    ///Modify image to fit a circular format
    func circle(width: CGFloat) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: width)
            .clipShape(Circle())
    }
    
    ///Modify image to fit a square format
    func square(width: CGFloat) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: width)
    }
    
    ///Modify image to fit a rounded corners square format
    func rounded(width: CGFloat) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: width)
            .clipShape(RoundedRectangle(cornerRadius: width/10.0))
    }
    ///Modify image to have upper rounded corners in a square format
    func topRounded(width: CGFloat) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: width)
            .clipShape(RoundedCorner(radius: width/10.0, corners: [.topLeft, .topRight]))
    }
    
    ///Modify image to have lower rounded corners in a square format
    func bottomRounded(width: CGFloat) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: width)
            .clipShape(RoundedCorner(radius: width/10.0, corners: [.bottomLeft, .bottomRight]))
    }
    
    ///Modify image to have left-side rounded corners in a square format
    func leftRounded(width: CGFloat) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: width)
            .clipShape(RoundedCorner(radius: width/10.0, corners: [.bottomLeft, .topLeft]))
        
            
    }
    
    ///Modify image to have right-side rounded corners in a square format
    func rightRounded(width: CGFloat) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: width)
            .clipShape(RoundedCorner(radius: width/10.0, corners: [.bottomRight, .topRight]))
    }
    
    
}


struct Images_Previews_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                Image("bricks_logo")
                    .avatarCircle()
                Image("bricks_logo")
                    .avatarSquare()
                Image("bricks_logo")
                    .avatarRounded()
                
            }.padding()
            
            HStack(spacing: 20) {
                Image("bricks_logo")
                    .circle(width: 90)
                Image("bricks_logo")
                    .square(width: 90)
                Image("bricks_logo")
                    .rounded(width: 90)
            }.padding()
            
            HStack(spacing: 20) {
                Image("bricks_logo")
                    .topRounded(width: 120)
                Image("bricks_logo")
                    .bottomRounded(width: 120)
            }.padding()
            
            HStack(spacing: 20) {
                Image("bricks_logo")
                    .leftRounded(width: 120)
                Image("bricks_logo")
                    .rightRounded(width: 120)
            }.padding()
        }
    }
}


@available(iOS 15.0, *)
extension AsyncImage {
    
    //MARK: Avatars
    
    ///Turn image into a circular avatar
    func avatarCircle() -> some View {
        self
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            .padding(.all, 16)
        
    }
    
    ///Turn image into a rectangular avatar
    func avatarSquare() -> some View {
        self
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .clipShape(Rectangle())
            .padding(.all, 16)
        
    }
    ///Turn image into a rounded rectangle avatar
    func avatarRounded() -> some View {
        self
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .padding(.all, 16)
        
    }
    
    //MARK: Styled Images
    
    ///Modify image to fit a circular format
    func circle(width: CGFloat) -> some View {
        self
            .aspectRatio( contentMode: .fit)
            .frame(width: width, height: width)
            .clipShape(Circle())
    }
    
    ///Modify image to fit a square format
    func square(width: CGFloat) -> some View {
        self
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: width)
    }
    
    ///Modify image to fit a rounded corners square format
    func rounded(width: CGFloat) -> some View {
        self
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: width)
            .clipShape(RoundedRectangle(cornerRadius: 25 ,style: .continuous))
    }
    ///Modify image to have upper rounded corners in a square format
    func topRounded(width: CGFloat) -> some View {
        self
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: width)
            .clipShape(RoundedCorner(radius: width/10.0, corners: [.topLeft, .topRight]))
    }
    
    ///Modify image to have lower rounded corners in a square format
    func bottomRounded(width: CGFloat) -> some View {
        self
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: width)
            .clipShape(RoundedCorner(radius: width/10.0, corners: [.bottomLeft, .bottomRight]))
    }
    
    ///Modify image to have left-side rounded corners in a square format
    func leftRounded(width: CGFloat) -> some View {
        self
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: width)
            .clipShape(RoundedCorner(radius: width/10.0, corners: [.bottomLeft, .topLeft]))
        
            
    }
    
    ///Modify image to have right-side rounded corners in a square format
    func rightRounded(width: CGFloat) -> some View {
        self
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: width)
            .clipShape(RoundedCorner(radius: width/10.0, corners: [.bottomRight, .topRight]))
    }
    
    
}


import Foundation
import SwiftUI
import UIKit
import Combine

struct UrlImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder
    private let image: (UIImage) -> Image
    
    init(
        url: URL,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)
    ) {
        self.placeholder = placeholder()
        self.image = image
        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue))
    }
    
    var body: some View {
        content
            .onAppear(perform: loader.load)
    }
    
    private var content: some View {
        Group {
            if loader.image != nil {
                image(loader.image!)
            } else {
                placeholder
            }
        }
    }
}

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

struct TemporaryImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()
    
    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set { newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL) }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private(set) var isLoading = false
    
    private let url: URL
    private var cache: ImageCache?
    private var cancellable: AnyCancellable?
    
    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")
    
    init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }
    
    deinit {
        cancel()
    }
    
    func load() {
        guard !isLoading else { return }

        if let image = cache?[url] {
            self.image = image
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data)
            }
            .replaceError(with: nil)
            .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                          receiveOutput: { [weak self] in self?.cache($0) },
                          receiveCompletion: { [weak self] _ in self?.onFinish() },
                          receiveCancel: { [weak self] in self?.onFinish() })
            .subscribe(on: Self.imageProcessingQueue)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func onStart() {
        isLoading = true
    }
    
    private func onFinish() {
        isLoading = false
    }
    
    private func cache(_ image: UIImage?) {
        image.map { cache?[url] = $0 }
    }
}

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}

