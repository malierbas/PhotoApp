//
//  Template.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

public let canvasOriginalWidth: CGFloat = 1080
public let canvasOriginalHeight: CGFloat = 1920
public let canvasRatio: CGFloat = 0.5625

class Template {
    var templateCoverImage: UIImage?
    var background: Background?
    var canvasImages: [CanvasImage]?
    var canvasTexts: [CanvasText]?
    var isFree: Bool? = false
    var canBeAssignedFullBackground: Bool = true
    var stickers: [Sticker] = []

    init(isFree: Bool? = false,
         canBeAssignedFullBackground: Bool = true,
         templateCoverImage: UIImage? = nil,
         background: Background? = nil,
         canvasImages: [CanvasImage]? = nil,
         canvasTexts: [CanvasText]? = nil) {
        self.templateCoverImage = templateCoverImage
        self.background = background
        self.canvasImages = canvasImages
        self.isFree = isFree
        self.canvasTexts = canvasTexts
        self.canBeAssignedFullBackground = canBeAssignedFullBackground
    }

    class CanvasImage {
        let frame1080x1920: CGRect?
        var defaultImage: UIImage?
        var isPicker: Bool = false
        var cornerRadius: CGFloat = 0
        var userPickedImage: UIImage? = nil
        var scrollContentOffset: CGPoint? = nil
        var scrollZoomScale: CGFloat? = nil

        init(isPicker: Bool = false, frame1080x1920: CGRect, defaultImage: UIImage? = nil, cornerRadius: CGFloat = 0) {
            self.frame1080x1920 = frame1080x1920
            self.defaultImage = defaultImage
            self.isPicker = isPicker
            self.cornerRadius = cornerRadius
        }
    }

    class CanvasText {
        let frame1080x1920: CGRect?
        var text: String?
        var font: UIFont?
        var textColor: UIColor?
        var textBackgroundColor: UIColor? = .clear
        var characterSpacing: CGFloat = 1
        var lineSpacing: CGFloat = 1
        var textAlpha: CGFloat = 1
        var latestCenter: CGPoint = .zero
        var textAlignment: NSTextAlignment?

        init(frame1080x1920: CGRect,
             text: String?,
             font: UIFont?,
             textColor: UIColor? = nil,
             textBackgrondColor: UIColor = .clear,
             textAlpha: CGFloat = 1,
             characterSpacing: CGFloat = 1,
             textAlignment: NSTextAlignment? = nil) {
            self.frame1080x1920 = frame1080x1920
            self.text = text
            self.font = font
            self.textColor = textColor
            self.textBackgroundColor = textBackgrondColor
            self.characterSpacing = characterSpacing
            self.textAlignment = textAlignment
        }
    }

    static func generateMinimalModels() -> [Template] {
        return [

            Template(isFree: true,
                     canBeAssignedFullBackground: true,
                     templateCoverImage: UIImage(named: "mobilePreview"),
                     canvasImages: [
                        Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "mobileEditorBg")),
                        Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 198, y: 348, width: 685, height: 959), defaultImage: UIImage(named: "mobileCanvasImage")),
            ], canvasTexts: [
                CanvasText(frame1080x1920: CGRect(x: 120, y: 1600, width: 800, height: 150),
                           text: "“Chasing the dreams…”",
                           font: UIFont(name: "Baskerville", size: 20),
                           textColor: UIColor(hexString: "#4A4A4A"),
                           textAlignment: .center)
                ]
            ),
            Template(canBeAssignedFullBackground: false,
                     templateCoverImage: UIImage(named: "begum43"),
                     canvasImages: [
                        Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "begum43-1")),
                        Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 185, y: 306, width: 857, height: 1251), defaultImage: UIImage(named: "begum43-2")),
                        Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 233, y: 367, width: 762, height: 975), defaultImage: UIImage(named: "begum43-3"))
            ]),
            Template(canBeAssignedFullBackground: false,
                     templateCoverImage: UIImage(named: "begum42"),
                     canvasImages: [
                        Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "begum42-1")),
                        Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 198, y: 348, width: 685, height: 959), defaultImage: UIImage(named: "begum42-2")),
                        Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 230, y: 1262, width: 643, height: 100), defaultImage: UIImage(named: "begum42-3")),
                        Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 34, y: 244, width: 276, height: 319), defaultImage: UIImage(named: "begum42-4")),
            ], canvasTexts: [
                CanvasText(frame1080x1920: CGRect(x: 334, y: 1497, width: 667, height: 117),
                           text: "Happy Birthday!",
                           font: UIFont(name: "Georgia", size: 20),
                           textColor: UIColor(hexString: "#654A2F"),
                           textAlignment: .center)
                ]),
            Template(canBeAssignedFullBackground: false,
                     templateCoverImage: UIImage(named: "begum39"),
                     canvasImages: [
                        Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "begum39-1")),
                        Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 348, y: 864, width: 707, height: 866), defaultImage: UIImage(named: "begum39-2")),
                        Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 257, y: 696, width: 729, height: 962), defaultImage: UIImage(named: "begum39-3")),

            ], canvasTexts: [
                CanvasText(frame1080x1920: CGRect(x: 58, y: 154, width: 963, height: 120),
                           text: "CHEERS ON YOUR BIRTHDAY",
                           font: UIFont(name: "Georgia-Bold", size: 15),
                           textColor: UIColor(hexString: "#FFFFFF"),
                           textAlignment: .center),
                CanvasText(frame1080x1920: CGRect(x: 438, y: 245, width: 203, height: 120),
                    text: "BABY!",
                    font: UIFont(name: "Georgia-Bold", size: 15),
                    textColor: UIColor(hexString: "#FFFFFF"),
                    textAlignment: .center)
            ]),
            Template(canBeAssignedFullBackground: false,
                templateCoverImage: UIImage(named: "begum40"),
                        canvasImages: [
                           Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "begum40-1")),
                           Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 80, y: 502, width: 921, height: 842), defaultImage: UIImage(named: "begum40-2")),
                           Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 196, y: 115, width: 688, height: 319), defaultImage: UIImage(named: "begum40-3")),

               ], canvasTexts: [
                   CanvasText(frame1080x1920: CGRect(x: 210, y: 210, width: 661, height: 133),
                              text: "HAPPY BIRTHDAY",
                          font: UIFont(name: "Georgia-Bold", size: 16),
                          textColor: UIColor(hexString: "#8C978F"),
                          textAlignment: .center)
             ]),

            Template(canBeAssignedFullBackground: false,
                       templateCoverImage: UIImage(named: "begum41"),
                       canvasImages: [
                          Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "begum41-1")),
                          Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 155, width: 1080, height: 726), defaultImage: UIImage(named: "begum41-2")),
                          Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 92, y: 965, width: 918, height: 84), defaultImage: UIImage(named: "begum41-3")),

              ], canvasTexts: [
                  CanvasText(frame1080x1920: CGRect(x: 70, y: 939, width: 940, height: 119),
                             text: "Happy Birthday Sweety!",
                             font: UIFont(name: "Georgia-Bold", size: 20),
                             textColor: UIColor(hexString: "#FFFFFF"),
                             textAlignment: .center)
            ]),




            Template(canBeAssignedFullBackground: true,
                     templateCoverImage: UIImage(named: "begum24"),
                     canvasImages: [
                        Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 232, y: 0, width: 848, height: 1920), defaultImage: UIImage(named: "begum24-1")),
                        Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 706, width: 624, height: 1009), defaultImage: UIImage(named: "begum24-2"))
            ]),
            Template(canBeAssignedFullBackground: false,
                     templateCoverImage: UIImage(named: "begum25"),
                     canvasImages: [
                        Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "begum25-1")),
                        Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 32, y: 58, width: 1016, height: 269), defaultImage: UIImage(named: "begum25-2"))
            ], canvasTexts: [
                CanvasText(frame1080x1920: CGRect(x: 214, y: 142, width: 672, height: 120),
                           text: "Be wild but stay soft",
                           font: UIFont(name: "DancingScript-Regular", size: 24),
                           textColor: UIColor(hexString: "#9B9B9B"),
                           textAlignment: .center)
                ]
            ),
            Template(isFree: true,
                     canBeAssignedFullBackground: true,
                     templateCoverImage: UIImage(named: "begum26"),
                     canvasImages: [
                        Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 139, y: 108, width: 802, height: 1242), defaultImage: UIImage(named: "begum26-1"))
            ], canvasTexts: [
                CanvasText(frame1080x1920: CGRect(x: 120, y: 1499, width: 800, height: 150),
                           text: "“Chasing the dreams…”",
                           font: UIFont(name: "Baskerville", size: 20),
                           textColor: UIColor(hexString: "#4A4A4A"),
                           textAlignment: .center)
                ]
            ),

            Template(isFree: false,
                     canBeAssignedFullBackground: true,
                     templateCoverImage: UIImage(named: "begum28"),
                     canvasImages: [
                        Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "begum28-1")),
                        Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 411, y: 828, width: 666, height: 967), defaultImage: UIImage(named: "begum28-2")),
                        Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 139, y: 108, width: 802, height: 1242), defaultImage: UIImage(named: "begum28-3")),
                        Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 0, y: 255, width: 584, height: 257), defaultImage: UIImage(named: "begum28-4")),
            ], canvasTexts: [
                CanvasText(frame1080x1920: CGRect(x: 0, y: 315, width: 584, height: 138),
                           text: "My quik weekend gateway...",
                           font: UIFont(name: "Baskerville", size: 20),
                           textColor: UIColor.white,
                           textAlignment: .center)
                ]
            ),

            Template(canBeAssignedFullBackground: true,
                     templateCoverImage: UIImage(named: "begum29"),
                     canvasImages: [
                        Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "begum29-1")),
                        Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 127, y: 1395, width: 826, height: 368), defaultImage: UIImage(named: "begum29-2")),
                        Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 225, y: 378, width: 631, height: 1317), defaultImage: UIImage(named: "begum29-3"))
            ], canvasTexts: [
                CanvasText(frame1080x1920: CGRect(x: 127, y: 203, width: 827, height: 232),
                           text: "Mindfulness",
                           font: UIFont(name: "Zapfino", size: 24),
                           textColor: UIColor.white,
                           textAlignment: .center)
                ]
            ),
//            Template(isFree: true, canBeAssignedFullBackground: false, templateCoverImage: UIImage(named: "begum17"), canvasImages: [
//                Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "begum17-1")),
//                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 60, y: 481, width: 961, height: 957), defaultImage: UIImage(named: "begum17-2"), cornerRadius: 480)
//            ]),
            Template(isFree: true, canBeAssignedFullBackground: false, templateCoverImage: UIImage(named: "begum18"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "begum18-1")),
                Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 0, y: 397, width: 1089, height: 601), defaultImage: UIImage(named: "begum18-2"))
                ], canvasTexts: [
                    CanvasText(frame1080x1920: CGRect(x: 315, y: 628, width: 700, height: 154),
                               text: "Dream home...",
                               font: UIFont(name: "Tangerine-Regular", size: 40),
                               textColor: UIColor(hexString: "#725454"),
                               textAlignment: .left)
                ]
            ),
//            Template(isFree: true, canBeAssignedFullBackground: false, templateCoverImage: UIImage(named: "begum19"), canvasImages: [
//                Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "begum19-1")),
//                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 143, y: 846, width: 979, height: 979), defaultImage: UIImage(named: "begum19-2"))
//                ], canvasTexts: [
//                    CanvasText(frame1080x1920: CGRect(x: 315, y: 628, width: 700, height: 154),
//                               text: "Loving you...",
//                               font: UIFont(name: "Tangerine-Regular", size: 40),
//                               textColor: UIColor.white)
//                    ]
//                ),

            // 30

            // 33
            
            Template(isFree: true, canBeAssignedFullBackground: true, templateCoverImage: UIImage(named: "begum20"), canvasImages: [
                Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "begum20-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 117, y: 357, width: 846, height: 1206), defaultImage: UIImage(named: "begum20-2"), cornerRadius: 50),
                Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 48, y: 300, width: 139, height: 114), defaultImage: UIImage(named: "begum20-3")),
                Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 894, y: 1506, width: 138, height: 114), defaultImage: UIImage(named: "begum20-4"))
            ]),
            Template(isFree: false, canBeAssignedFullBackground: false, templateCoverImage: UIImage(named: "begum21"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 914), defaultImage: UIImage(named: "begum21-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 960, width: 1080, height: 960), defaultImage: UIImage(named: "begum21-2")),
                Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "begum21-3")),
                ], canvasTexts: [
                    CanvasText(frame1080x1920: CGRect(x: 380, y: 880, width: 700, height: 154),
                               text: "Friendship",
                               font: UIFont(name: "DancingScript-Bold", size: 32),
                               textColor: UIColor(hexString: "#8B572A"),
                               textAlignment: .left)
                ]
            ),
            Template(isFree: false, canBeAssignedFullBackground: false, templateCoverImage: UIImage(named: "begum22"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "begum22-1")),
                Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "begum22-2"))
                ], canvasTexts: [
                    CanvasText(frame1080x1920: CGRect(x: 342, y: 1180, width: 700, height: 154),
                        text: "Summer vibes",
                        font: UIFont(name: "DancingScript-Bold", size: 30),
                        textColor: UIColor(hexString: "#8B572A"),
                        textAlignment: .left)
                ]
            ),
            Template(isFree: true, templateCoverImage: UIImage(named: "begum23"), canvasImages: [
                Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 88, y: 292, width: 910, height: 1337), defaultImage: UIImage(named: "begum23-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 231, y: 441, width: 624, height: 1038), defaultImage: UIImage(named: "begum23-2"))
            ]),
            Template(isFree: true, templateCoverImage: UIImage(named: "begum9"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "begum9-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 94, y: 128, width: 892, height: 1665), defaultImage: UIImage(named: "begum9-2"))
            ]),
            Template(isFree: true, canBeAssignedFullBackground: false, templateCoverImage: UIImage(named: "begum15"), canvasImages: [
                Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "begum15-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 22, y: 28, width: 902, height: 1864), defaultImage: UIImage(named: "begum15-2"))
            ]),
            Template(isFree: false, templateCoverImage: UIImage(named: "begum16"), canvasImages: [
                    Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "begum16-1")),
                    Template.CanvasImage(isPicker: false, frame1080x1920: CGRect(x: 51, y: 189, width: 979, height: 1541), defaultImage: UIImage(named: "begum16-2")),
                    Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 101, y: 243, width: 880, height: 1250), defaultImage: UIImage(named: "begum16-3"))
                ], canvasTexts: [
                    CanvasText(frame1080x1920: CGRect(x: 100, y: 1520, width: 880, height: 152),
                               text: "Tell your story",
                               font: UIFont(name: "Tangerine-Regular", size: 40),
                               textColor: UIColor.white,
                               textAlignment: .left)
                    ]
            ),
            Template(isFree: true, templateCoverImage: UIImage(named: "begum5"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 356, width: 540, height: 797), defaultImage: UIImage(named: "begum5-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 540, y: 767, width: 540, height: 797), defaultImage: UIImage(named: "begum5-2"))
            ]),
            Template(isFree: false, templateCoverImage: UIImage(named: "begum6"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 1294, width: 525, height: 627), defaultImage: UIImage(named: "begum6-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 555, y: 647, width: 536, height: 627), defaultImage: UIImage(named: "begum6-2")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 647, width: 525, height: 627), defaultImage: UIImage(named: "begum6-3")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 555, y: 0, width: 525, height: 627), defaultImage: UIImage(named: "begum6-4")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 555, y: 1294, width: 525, height: 627), defaultImage: UIImage(named: "begum6-5")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 0, width: 525, height: 627), defaultImage: UIImage(named: "begum6-6")),
            ]),
            Template(isFree: true, templateCoverImage: UIImage(named: "begum1"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 638), defaultImage: UIImage(named: "begum1-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 160, y: 750, width: 760, height: 988), defaultImage: UIImage(named: "begum1-2"))
            ]),
            Template(isFree: false, templateCoverImage: UIImage(named: "begum4"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 1300, width: 1080, height: 620), defaultImage: UIImage(named: "begum4-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 649, width: 1080, height: 619), defaultImage: UIImage(named: "begum4-2")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 617), defaultImage: UIImage(named: "begum4-3"))
            ]),
            Template(isFree: true, templateCoverImage: UIImage(named: "begum3"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "begum3-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 77, y: 659, width: 918, height: 619), defaultImage: UIImage(named: "begum3-2"))
            ]),
            Template(isFree: true, templateCoverImage: UIImage(named: "begum2"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "begum2-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 154, y: 782, width: 772, height: 1026), defaultImage: UIImage(named: "begum2-2"))
            ]),
            Template(isFree: true, templateCoverImage: UIImage(named: "template6"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 84, y: 303, width: 912, height: 608), defaultImage: UIImage(named: "template6-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 84, y: 1010, width: 912, height: 608), defaultImage: UIImage(named: "template6-2"))
            ]),
            Template(isFree: true, templateCoverImage: UIImage(named: "template5"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 53, y: 81, width: 975, height: 538), defaultImage: UIImage(named: "template5-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 53, y: 650, width: 473, height: 620), defaultImage: UIImage(named: "template5-2")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 555, y: 650, width: 473, height: 620), defaultImage: UIImage(named: "template5-3")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 53, y: 1301, width: 975, height: 538), defaultImage: UIImage(named: "template5-4"))
            ]),
            Template(isFree: true, templateCoverImage: UIImage(named: "template1"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 84, y: 80, width: 912, height: 1125), defaultImage: UIImage(named: "fashion-girl-black-face-2703463")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 84, y: 1235, width: 912, height: 605), defaultImage: UIImage(named: "abstract-photo-african-afro-art-exhibition-2703464"))
            ]),
            Template(isFree: true, templateCoverImage: UIImage(named: "begum8"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 841), defaultImage: UIImage(named: "begum8-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 42, y: 883, width: 484, height: 484), defaultImage: UIImage(named: "begum8-2")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 554, y: 883, width: 484, height: 484), defaultImage: UIImage(named: "begum8-3")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 42, y: 1397, width: 484, height: 484), defaultImage: UIImage(named: "begum8-4")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 555, y: 1397, width: 484, height: 484), defaultImage: UIImage(named: "begum8-5"))
            ]),
            Template(isFree: false, templateCoverImage: UIImage(named: "template8"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 281, y: 72, width: 519, height: 566), defaultImage: UIImage(named: "template8-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 281, y: 677, width: 519, height: 566), defaultImage: UIImage(named: "template8-2")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 281, y: 1282, width: 519, height: 566), defaultImage: UIImage(named: "template8-3"))
            ]),
            Template(isFree: true, templateCoverImage: UIImage(named: "template9"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 40, y: 52, width: 486, height: 899), defaultImage: UIImage(named: "template9-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 553, y: 52, width: 486, height: 899), defaultImage: UIImage(named: "template9-2")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 40, y: 969, width: 486, height: 899), defaultImage: UIImage(named: "template9-3")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 553, y: 969, width: 486, height: 899), defaultImage: UIImage(named: "template9-4"))
            ]),
            Template(isFree: true, templateCoverImage: UIImage(named: "template2"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 46, y: 319, width: 482, height: 832), defaultImage: UIImage(named: "cat1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 552, y: 734, width: 482, height: 832), defaultImage: UIImage(named: "cat2"))
            ]),
            Template(isFree: true, templateCoverImage: UIImage(named: "template3"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 242, y: 261, width: 796, height: 1191), defaultImage: UIImage(named: "woman-yellow"))
            ]),
            Template(isFree: true, templateCoverImage: UIImage(named: "template10"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 102, width: 782, height: 550), defaultImage: UIImage(named: "template10-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 166, y: 685, width: 782, height: 550), defaultImage: UIImage(named: "template10-2")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 298, y: 1268, width: 782, height: 550), defaultImage: UIImage(named: "template10-3"))
            ]),
            Template(isFree: true, canBeAssignedFullBackground: false, templateCoverImage: UIImage(named: "template11"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1219), defaultImage: UIImage(named: "template11-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 1227, width: 1080, height: 697), defaultImage: UIImage(named: "template11-2"))
            ])
        ]
    }

    static func generateFrameModels() -> [Template] {
        return [
            Template(isFree: true, canBeAssignedFullBackground: false, templateCoverImage: UIImage(named: "template4"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "women-real-yellow")),
                Template.CanvasImage(frame1080x1920: CGRect(x: 71, y: 119, width: 939, height: 1683), defaultImage: UIImage(named: "template4-1"))
            ]),
            Template(isFree: true, templateCoverImage: UIImage(named: "frame2"), canvasImages: [
                Template.CanvasImage(frame1080x1920: CGRect(x: 10, y: 319, width: 939, height: 600), defaultImage: UIImage(named: "frame2-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 30, y: 339, width: 899, height: 559), defaultImage: UIImage(named: "frame2-2")),
                Template.CanvasImage(frame1080x1920: CGRect(x: 131, y: 1002, width: 939, height: 600), defaultImage: UIImage(named: "frame2-3")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 151, y: 1023, width: 899, height: 559), defaultImage: UIImage(named: "frame2-4"))
            ]),
            Template(isFree: true, templateCoverImage: UIImage(named: "frame3"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 130, y: 201, width: 950, height: 1719), defaultImage: UIImage(named: "frame3-1")),
                Template.CanvasImage(frame1080x1920: CGRect(x: 60, y: 131, width: 850, height: 1760), defaultImage: UIImage(named: "frame3-2"))
            ]),
            Template(isFree: true, templateCoverImage: UIImage(named: "frame4"), canvasImages: [
                Template.CanvasImage(frame1080x1920: CGRect(x: 316, y: 517, width: 441, height: 857), defaultImage: UIImage(named: "frame4-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 46, y: 140, width: 541, height: 749), defaultImage: UIImage(named: "frame4-2")),
                Template.CanvasImage(frame1080x1920: CGRect(x: 86, y: 85, width: 556, height: 766), defaultImage: UIImage(named: "frame4-3")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 494, y: 1086, width: 541, height: 749), defaultImage: UIImage(named: "frame4-4")),
                Template.CanvasImage(frame1080x1920: CGRect(x: 439, y: 1031, width:  556, height: 766), defaultImage: UIImage(named: "frame4-5"))
            ]),
            Template(isFree: true, templateCoverImage: UIImage(named: "frame5"), canvasImages: [
                Template.CanvasImage(frame1080x1920: CGRect(x: 115, y: 155, width: 859, height: 1610), defaultImage: UIImage(named: "frame5-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 45, y: 265, width: 480, height: 1391), defaultImage: UIImage(named: "frame5-2")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 555, y: 265, width: 480, height: 1391), defaultImage: UIImage(named: "frame5-3"))
            ]),
            Template(isFree: true, templateCoverImage: UIImage(named: "frame6"), canvasImages: [
                Template.CanvasImage(frame1080x1920: CGRect(x: 115, y: 357, width: 850, height: 1206), defaultImage: UIImage(named: "frame6-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 180, y: 202, width: 720, height: 1296), defaultImage: UIImage(named: "frame6-2")),
            ]),
            Template(isFree: true, canBeAssignedFullBackground: false, templateCoverImage: UIImage(named: "frame7"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "frame7-1")),
                Template.CanvasImage(frame1080x1920: CGRect(x: 78, y: 95, width: 925, height: 1731), defaultImage: UIImage(named: "frame7-2")),
            ]),
            Template(isFree: true, canBeAssignedFullBackground: false, templateCoverImage: UIImage(named: "frame8"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "frame8-1")),
                Template.CanvasImage(frame1080x1920: CGRect(x: 78, y: 95, width: 925, height: 1731), defaultImage: UIImage(named: "frame8-2")),
            ]),
            Template(isFree: true, templateCoverImage: UIImage(named: "frame9"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "frame9-1")),
                Template.CanvasImage(frame1080x1920: CGRect(x: 87, y: 162, width: 906, height: 1597), defaultImage: UIImage(named: "frame9-2")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 103, y: 178, width: 874, height: 1565), defaultImage: UIImage(named: "frame9-3"))
            ]),
            Template(isFree: true, canBeAssignedFullBackground: false, templateCoverImage: UIImage(named: "frame10"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "frame10-1")),
                Template.CanvasImage(frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "frame10-2")),
            ]),
            Template(isFree: true, templateCoverImage: UIImage(named: "frame11"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 87, y: 275, width: 906, height: 1371), defaultImage: UIImage(named: "frame11-1")),
                Template.CanvasImage(frame1080x1920: CGRect(x: 81, y: 272, width: 918, height: 1376), defaultImage: UIImage(named: "frame11-2")),
            ]),
            Template(isFree: true, templateCoverImage: UIImage(named: "frame12"), canvasImages: [
                Template.CanvasImage(frame1080x1920: CGRect(x: 67, y: 638, width: 947, height: 644), defaultImage: UIImage(named: "frame12-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 80, y: 649, width: 921, height: 624), defaultImage: UIImage(named: "frame12-2")),
            ]),
            Template(isFree: true, canBeAssignedFullBackground: false, templateCoverImage: UIImage(named: "frame13"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "frame13-1")),
                Template.CanvasImage(frame1080x1920: CGRect(x: 130, y: 340, width: 820, height: 820), defaultImage: UIImage(named: "frame13-2")),
            ]),
            Template(isFree: true, templateCoverImage: UIImage(named: "frame14"), canvasImages: [
                Template.CanvasImage(frame1080x1920: CGRect(x: 95, y: 354, width: 891, height: 596), defaultImage: UIImage(named: "frame14-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 99, y: 358, width: 883, height: 588), defaultImage: UIImage(named: "frame14-2")),
                Template.CanvasImage(frame1080x1920: CGRect(x: 95, y: 970, width: 891, height: 596), defaultImage: UIImage(named: "frame14-3")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 99, y: 974, width: 883, height: 588), defaultImage: UIImage(named: "frame14-4"))
            ])

        ]
    }

    static func generateVintageModels() -> [Template] {
        return [
            Template(isFree: true, templateCoverImage: UIImage(named: "vintage1"), canvasImages: [
                Template.CanvasImage(frame1080x1920: CGRect(x: 165, y: 351, width: 750, height: 1094), defaultImage: UIImage(named: "vintage1-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 208, y: 394, width: 664, height: 867), defaultImage: UIImage(named: "vintage1-2")),
                Template.CanvasImage(frame1080x1920: CGRect(x: 208, y: 394, width: 664, height: 867), defaultImage: UIImage(named: "vintage1-3"))
            ]),
            Template(isFree: true, templateCoverImage: UIImage(named: "vintage2"), canvasImages: [
                Template.CanvasImage(frame1080x1920: CGRect(x: 90, y: 437, width: 900, height: 1046), defaultImage: UIImage(named: "vintage2-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 141, y: 508, width: 796, height: 796), defaultImage: UIImage(named: "vintage2-2")),
                Template.CanvasImage(frame1080x1920: CGRect(x: 141, y: 508, width: 796, height: 796), defaultImage: UIImage(named: "vintage2-3"))
            ]),
            Template(isFree: true, templateCoverImage: UIImage(named: "vintage3"), canvasImages: [
                Template.CanvasImage(frame1080x1920: CGRect(x: 290, y: 116, width: 750, height: 1094), defaultImage: UIImage(named: "vintage3-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 333, y: 159, width: 664, height: 867), defaultImage: UIImage(named: "vintage3-2")),
                Template.CanvasImage(frame1080x1920: CGRect(x: 333, y: 159, width: 664, height: 867), defaultImage: UIImage(named: "vintage3-3")),
                Template.CanvasImage(frame1080x1920: CGRect(x: 40, y: 710, width: 750, height: 1094), defaultImage: UIImage(named: "vintage3-4")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 83, y: 753, width: 664, height: 867), defaultImage: UIImage(named: "vintage3-5")),
                Template.CanvasImage(frame1080x1920: CGRect(x: 83, y: 753, width: 664, height: 867), defaultImage: UIImage(named: "vintage3-6")),
            ]),
            Template(isFree: true, templateCoverImage: UIImage(named: "vintage4"), canvasImages: [
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "vintage4-1")),
                Template.CanvasImage(frame1080x1920: CGRect(x: 112, y: 513, width: 857, height: 1251), defaultImage: UIImage(named: "vintage4-2")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 161, y: 562, width: 759, height: 992), defaultImage: UIImage(named: "vintage4-3")),
                Template.CanvasImage(frame1080x1920: CGRect(x: 161, y: 562, width: 759, height: 992), defaultImage: UIImage(named: "vintage4-4"))
            ]),
            Template(isFree: true, templateCoverImage: UIImage(named: "vintage6"), canvasImages: [
                Template.CanvasImage(frame1080x1920: CGRect(x: 44, y: 318, width: 647, height: 752), defaultImage: UIImage(named: "vintage6-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 80, y: 369, width: 573, height: 572), defaultImage: UIImage(named: "vintage6-2")),
                Template.CanvasImage(frame1080x1920: CGRect(x: 81, y: 370, width: 573, height: 572), defaultImage: UIImage(named: "vintage6-3")),
                Template.CanvasImage(frame1080x1920: CGRect(x: 389, y: 850, width: 647, height: 752), defaultImage: UIImage(named: "vintage6-4")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 425, y: 901, width: 573, height: 572), defaultImage: UIImage(named: "vintage6-5")),
                Template.CanvasImage(frame1080x1920: CGRect(x: 426, y: 902, width: 573, height: 572), defaultImage: UIImage(named: "vintage6-6")),
            ]),
            Template(isFree: true, canBeAssignedFullBackground: false, templateCoverImage: UIImage(named: "vintage7"), canvasImages: [
                Template.CanvasImage(frame1080x1920: CGRect(x: 0, y: 0, width: 1080, height: 1920), defaultImage: UIImage(named: "vintage7-1")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 235, y: 152, width: 580, height: 580), defaultImage: UIImage(named: "vintage7-2")),
                Template.CanvasImage(isPicker: true, frame1080x1920: CGRect(x: 232, y: 1012, width: 580, height: 580), defaultImage: UIImage(named: "vintage7-3"))
            ]),
            
        ]
    }
}

