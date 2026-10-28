import SwiftUI

enum AppTheme {
    
    //background color
    static let background = Color("AppBackground")
    
    //tab bar selected color
    static let tabSelected = Color("TabYellow")
    
    //Font style and size 
    static let Title = Font.custom("thmanyahserifdisplay-Bold", size: 22)
    static let MainTitle = Font.custom("thmanyahserifdisplay-Bold", size: 28)
    static let body = Font.custom("thmanyahseriftext-Regular", size: 16)
    static let Mainbody = Font.custom("thmanyahseriftext-Regular", size: 24)
    static let displayFontName = "thmanyahserifdisplay-Bold"
    static let textFontName = "thmanyahseriftext-Regular"

    //Font Colors
    static let titleText = Color("PrimaryYellow")
    static let bodyText = Color("ButterYellow")
    static let titleHighlight = Color("TitleHighlight")
    
    
    //Map Colors
    static let patternBase = Color ("PrimaryYellow")
    static let patternInk = Color("Patternink")
    static let regionStroke = Color("ButterYellow")
    
    
    //Bag Colors
    static let cellFill      = Color.white.opacity(0.06)
    static let containerFill = Color.white.opacity(0.04)
    static let cellBorder    = AppTheme.regionStroke.opacity(0.35)
    static let divider       = AppTheme.bodyText.opacity(0.25)
    static let track         = Color.white.opacity(0.15)
    static let progressFill  = AppTheme.titleText
    static let chipIdle      = Color.white.opacity(0.12)
    static let onChip        = AppTheme.background

}
