import SwiftUI

extension Image {

    func teamLogoModifier(frame: CGFloat? = nil) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: frame, height: frame)
    }
}
