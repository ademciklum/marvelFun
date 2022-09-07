//
//  RetryAlertViewModifier.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 07.09.2022.
//

import Foundation
import SwiftUI

struct RetryAlertViewModifier: ViewModifier {

    @Binding var error: RequestError?
    var action: () -> Void
    
    func body(content: Content) -> some View {
        content.alert(error?.userFriendlyMessage ?? "Error",
                      isPresented: .constant(error != nil), actions: {
            Button("Retry", action: action)
            Button("Cancel", role: .cancel) { error = nil }
        }, message: {
            Text(error?.localizedDescription ?? "")
        })
    }
}
