//
//  PuzzleStyle 2.swift
//  LaunchChallenge
//
//  Created by Hajar Mudhi  on 17/05/1448 AH.
//


import SwiftUI

/// The few extra tokens the puzzle page needs. Nothing new is hardcoded:
/// everything comes from `AppTheme` / `CanvasPalette`, or is a neutral tint of white.
enum PuzzleStyle {
    // Board
    static let boardBorder = AppTheme.titleText
    static let boardFill = Color.white.opacity(0.17)

    // Controls and panels
    static let controlFill = Color.white.opacity(0.12)         // sound button
    static let panelFill = Color.white.opacity(0.07)           // instruction label
    static let instructionText = CanvasPalette.colors[7]       // teal 3E6F7C

    // Tab bar
    static let tabBarFill = Color.white.opacity(0.17)
    static let tabInk = Color.white.opacity(0.6)

    // Fonts built from your font names
    static let instructionFont = Font.custom(AppTheme.displayFontName, size: 17)
    static let tabLabelFont = Font.custom(AppTheme.textFontName, size: 12)
}
