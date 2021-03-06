//
//  CompositeStatusViewType.swift
//  PlatformUIKit
//
//  Created by Daniel Huri on 03/06/2020.
//  Copyright © 2020 Blockchain Luxembourg S.A. All rights reserved.
//

public enum CompositeStatusViewType {
    
    public struct Composite {
        public enum BaseViewType {
            case image(String)
            case text(String)
        }
        
        public struct SideViewAttributes {
            public enum ViewType {
                case image(String)
                case loader
                case none
            }
            
            public enum Position {
                case radiusDistanceFromCenter
                case rightCorner
            }
            
            static var none: SideViewAttributes {
                return .init(type: .none, position: .radiusDistanceFromCenter)
            }
            
            let type: ViewType
            let position: Position
            
            public init(type: ViewType, position: Position) {
                self.type = type
                self.position = position
            }
        }
        
        let baseViewType: BaseViewType
        let sideViewAttributes: SideViewAttributes
        let backgroundColor: Color
        let cornerRadiusRatio: CGFloat
        
        public init(baseViewType: BaseViewType,
                    sideViewAttributes: SideViewAttributes,
                    backgroundColor: Color = .clear,
                    cornerRadiusRatio: CGFloat = 0) {
            self.baseViewType = baseViewType
            self.sideViewAttributes = sideViewAttributes
            self.cornerRadiusRatio = cornerRadiusRatio
            self.backgroundColor = backgroundColor
        }
    }
        
    case loader
    case image(String)
    case composite(Composite)
    case none
    
    var cornerRadiusRatio: CGFloat {
        switch self {
        case .composite(let composite):
            return composite.cornerRadiusRatio
        case .loader, .image, .none:
            return 0
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .composite(let composite):
            return composite.backgroundColor
        case .loader, .image, .none:
            return .clear
        }
    }
}

