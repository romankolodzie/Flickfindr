//
//  GCDBlackBox.swift
//  Flickfindr
//
//  Created by Roman Kolodzie on 5/11/16.
//  Copyright © 2016 Roman Kolodzie. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}