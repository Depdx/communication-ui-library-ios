//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

public struct CallDiagnosticsState: Equatable, Codable {

    var networkDiagnostic: NetworkDiagnosticModel?
    var networkQualityDiagnostic: NetworkQualityDiagnosticModel?
    var mediaDiagnostic: MediaDiagnosticModel?

    init(networkDiagnostic: NetworkDiagnosticModel? = nil,
         networkQualityDiagnostic: NetworkQualityDiagnosticModel? = nil,
         mediaDiagnostic: MediaDiagnosticModel? = nil) {
        self.networkDiagnostic = networkDiagnostic
        self.networkQualityDiagnostic = networkQualityDiagnostic
        self.mediaDiagnostic = mediaDiagnostic
    }
}
