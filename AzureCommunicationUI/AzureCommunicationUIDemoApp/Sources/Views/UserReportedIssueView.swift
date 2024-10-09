//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AzureCommunicationUICalling
import Foundation
import UIKit

func showUserReportAlert(
  from viewController: UIViewController, issue: CallCompositeUserReportedIssue
) {
  DispatchQueue.main.async {
    let alert = UIAlertController(
      title: "Issue Reported", message: issue.userMessage, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    viewController.present(alert, animated: true)
  }
}
