//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI

enum LocalVideoViewType {
  case preview
  case localVideoPip
  case localVideofull

  var cameraSwitchButtonAlignment: Alignment {
    switch self {
    case .localVideoPip:
      return .topTrailing
    case .localVideofull:
      return .bottomTrailing
    case .preview:
      return .trailing
    }
  }

  var avatarSize: MSFAvatarSize {
    switch self {
    case .localVideofull,
      .preview:
      return .size72
    case .localVideoPip:
      return .size40
    }
  }

  var showDisplayNameTitleView: Bool {
    switch self {
    case .localVideoPip,
      .preview:
      return false
    case .localVideofull:
      return true
    }
  }

  var hasGradient: Bool {
    switch self {
    case .localVideoPip,
      .localVideofull:
      return false
    case .preview:
      return true
    }
  }

}

struct LocalVideoView: View {
  @ObservedObject var viewModel: LocalVideoViewModel
  let viewManager: VideoViewManager
  let viewType: LocalVideoViewType
  let avatarManager: AvatarViewManagerProtocol
  @Environment(\.screenSizeClass) var screenSizeClass: ScreenSizeClassType

  @State private var avatarImage: UIImage?
  @State private var localVideoStreamId: String?
  @State private var transforms: [CameraTransforms<Any>]?

  var body: some View {
    Group {
      GeometryReader { geometry in
        if viewModel.cameraOperationalStatus == .on,
          let streamId = localVideoStreamId,
          let rendererView = viewManager.getLocalVideoRendererView(streamId)
        {
          ZStack(alignment: viewType.cameraSwitchButtonAlignment) {
            if let transforms = transforms {
              applyTransforms(to: rendererView, with: transforms)
            }
            VideoRendererView(rendererView: rendererView)
              .frame(
                width: geometry.size.width,
                height: geometry.size.height
              )
            if viewType.hasGradient {
              GradientView()
            }
            if !viewModel.isInPip {
              cameraSwitchButton
            }
          }
        } else {
          VStack(alignment: .center, spacing: 5) {
            CompositeAvatar(
              displayName: $viewModel.displayName,
              avatarImage: Binding.constant(
                avatarManager
                  .localParticipantViewData?
                  .avatarImage),
              isSpeaking: false,
              avatarSize: viewType.avatarSize)

            if viewType.showDisplayNameTitleView {
              Spacer().frame(height: 10)
              ParticipantTitleView(
                displayName: $viewModel.displayName,
                isMuted: $viewModel.isMuted,
                isHold: .constant(false),
                titleFont: Fonts.caption1.font,
                mutedIconSize: 16)
            } else if screenSizeClass == .iphonePortraitScreenSize {
              Spacer()
                .frame(height: 20)
            }
          }
          .frame(
            width: geometry.size.width,
            height: geometry.size.height
          )
          .accessibilityElement(children: .combine)
        }
      }
    }.onReceive(viewModel.$localVideoStreamId) {
      viewManager.updateDisplayedLocalVideoStream($0)
      if localVideoStreamId != $0 {
        localVideoStreamId = $0
      }
    }.onReceive(viewModel.$transforms) { newTransforms in
      transforms = newTransforms
    }.accessibilityIgnoresInvertColors(true)
  }

  var cameraSwitchButton: some View {
    let cameraSwitchButtonPaddingPip: CGFloat = -4
    let cameraSwitchButtonPaddingFull: CGFloat = 4
    return Group {
      switch viewType {
      case .localVideoPip:
        IconButton(viewModel: viewModel.cameraSwitchButtonPipViewModel)
          .padding(cameraSwitchButtonPaddingPip)
      case .localVideofull:
        IconButton(viewModel: viewModel.cameraSwitchButtonFullViewModel)
          .padding(cameraSwitchButtonPaddingFull)
      default:
        EmptyView()
      }
    }
  }

  func applyTransforms(to rendererView: UIView, with transforms: [CameraTransforms<Any>]) {
    let sortedTransforms = transforms.sorted { $0.order < $1.order }

    sortedTransforms.forEach { transform in
      switch transform.type {
      case .rotate:
        if let rotateArgs = transform.args as? TransformTransformsRotateArgs {
          rendererView.transform = rendererView.transform.rotated(
            by: CGFloat(rotateArgs.angle * .pi / 180.0))
        }
      case .flip:
        if let flipArgs = transform.args as? TransformTransformsFlipArgs {
          switch flipArgs.axis {
          case .horizontal:
            rendererView.transform = rendererView.transform.scaledBy(x: -1, y: 1)
          case .vertical:
            rendererView.transform = rendererView.transform.scaledBy(x: 1, y: -1)
          default:
            break
          }
        }
      }
    }
  }
}
