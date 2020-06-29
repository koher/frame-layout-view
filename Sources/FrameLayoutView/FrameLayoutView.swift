import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct FrameLayoutView: View {
    private let size: CGSize
    private let items: [Item]
    
    public init(size: CGSize, items: [Item]) {
        self.size = size
        self.items = items
    }
    
    public var body: some View {
        ZStack() {
            ForEach(items.indices) { i in
                self.items[i]
                    .frame(width: self.size.width, height: self.size.height, alignment: .topLeading)
            }
        }
        .frame(width: size.width, height: size.height)
    }
    
    public struct Item: View {
        private let content: AnyView
        private let frame: CGRect
        private let additionalModifications: ((AnyView) -> AnyView)?
        
        public init<Content: View, Output: View>(_ content: Content, frame: CGRect, additionalModifications: ((AnyView) -> Output)? = nil) {
            self.content = AnyView(content)
            self.frame = frame
            if let additionalModifications = additionalModifications {
                self.additionalModifications = { input in
                    AnyView(additionalModifications(input))
                }
            } else {
                self.additionalModifications = nil
            }
        }
        
        @ViewBuilder
        public var body: some View {
            // FIXME: when optional binding is supported
            if additionalModifications != nil {
                additionalModifications!(AnyView(
                    content
                        .frame(width: frame.size.width, height: frame.size.height)
                ))
                .padding(EdgeInsets(top: frame.origin.y, leading: frame.origin.x, bottom: 0, trailing: 0))
            } else {
                content
                    .frame(width: frame.size.width, height: frame.size.height)
                    .padding(EdgeInsets(top: frame.origin.y, leading: frame.origin.x, bottom: 0, trailing: 0))
            }
        }
    }
}
