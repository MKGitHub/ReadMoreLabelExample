//
//  ReadMoreLabelExample.playground
//  Copyright © 2017 Mohsan Khan. All rights reserved.
//

//
//  https://github.com/MKGitHub/ReadMoreLabelExample
//  http://www.xybernic.com
//

//
//  Copyright 2017 Mohsan Khan
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit
import PlaygroundSupport


//let myFont:UIFont = UIFont(name:"Menlo-Regular", size:17)!
let myFont:UIFont = UIFont.systemFont(ofSize:17)


extension UILabel
{
    ///
    /// Call/Is needed `self.layoutIfNeeded()` before if your label is using auto layout.
    ///
    func countLabelLines() -> Int
    {
        let myText:NSString = self.text! as NSString
        let attributes:[NSAttributedStringKey:Any] = [NSAttributedStringKey.font:self.font]

        let labelRect:CGRect = myText.boundingRect(with:CGSize(width:self.bounds.width,
                                                               height:CGFloat.greatestFiniteMagnitude),
                                                   options:NSStringDrawingOptions.usesLineFragmentOrigin,
                                                   attributes:attributes,
                                                   context:nil)
        // debug
        //self.font.lineHeight
        //labelRect.height

        return Int(ceil(CGFloat(labelRect.height) / self.font.lineHeight))
    }


    func isTruncated() -> Bool
    {
        // dynamically height labels, then we really don't need this solution
        guard (self.numberOfLines > 0) else { fatalError("Number of lines is set to 0 which means that the label will grow dynamically!") }

        return (self.countLabelLines() > self.numberOfLines)
    }
}


///
/// You should create this image only once and reuse it for sake of performance.
///
func CreateGradientImage(w:CGFloat, h:CGFloat) -> UIImage
{
    let renderer:UIGraphicsImageRenderer = UIGraphicsImageRenderer(size:CGSize(width:w, height:h))

    return renderer.image
    {
        rendererContext in

        let gradient:CGGradient = CGGradient(colorsSpace:nil, colors:[#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0).cgColor, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor] as CFArray, locations:[0, 1])!

        rendererContext.cgContext.drawLinearGradient(gradient, start:CGPoint(x:0, y:0), end:CGPoint(x:w, y:0), options:[])
    }
}


///
/// Example
///
final class LabelViewController:UIViewController
{
    override func loadView()
    {
        // UI
        let view:UIView = UIView(frame:CGRect(x:0, y:0, width:414, height:736))
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)


        // main label
        let mainLabel:UILabel = UILabel()
        mainLabel.textColor = UIColor.black
        mainLabel.backgroundColor = UIColor.white
        mainLabel.numberOfLines = 4
        mainLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        mainLabel.font = myFont
        mainLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris vel sodales purus. Aenean sed velit non quam feugiat pulvinar ac sit amet felis. Donec euismod diam eget leo accumsan, a lobortis erat semper. Suspendisse nibh lacus, fermentum sed dui ac, bibendum aliquam lorem."

            view.addSubview(mainLabel)

            mainLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                mainLabel.topAnchor.constraint(equalTo:view.topAnchor, constant:20),
                mainLabel.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant:20),
                mainLabel.trailingAnchor.constraint(equalTo:view.trailingAnchor, constant:-20)
            ])
            mainLabel.layoutIfNeeded()

        // read more label
        let rml:UILabel = UILabel()
        rml.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        rml.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        rml.numberOfLines = 1
        rml.lineBreakMode = NSLineBreakMode.byTruncatingTail
        rml.font = mainLabel.font
        rml.text = "… read more"
        rml.textAlignment = NSTextAlignment.center
        rml.isHidden = true

            view.addSubview(rml)

            rml.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                rml.bottomAnchor.constraint(equalTo:mainLabel.bottomAnchor, constant:0),
                rml.leadingAnchor.constraint(equalTo:mainLabel.trailingAnchor, constant:-110),
                rml.trailingAnchor.constraint(equalTo:mainLabel.trailingAnchor, constant:0)
            ])
            rml.layoutIfNeeded()

        let imageGradientWidth:CGFloat = 100

        // image view
        let im:UIImageView = UIImageView(image:CreateGradientImage(w:imageGradientWidth, h:1))
        im.contentMode = .scaleToFill
        //im.backgroundColor = .green    // debug
        im.isHidden = true

            view.addSubview(im)

            im.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                im.bottomAnchor.constraint(equalTo:mainLabel.bottomAnchor, constant:0),
                im.trailingAnchor.constraint(equalTo:mainLabel.trailingAnchor, constant:-110),
                im.widthAnchor.constraint(equalToConstant:imageGradientWidth),
                im.heightAnchor.constraint(equalToConstant:rml.font.lineHeight)
            ])
            im.layoutIfNeeded()

        /*
            Above layout should be done in IB or with code.

            Below is done in code.
        */

        if (mainLabel.isTruncated())
        {
            im.isHidden = false
            rml.isHidden = false
        }


        // display
        self.view = view
    }
}


PlaygroundPage.current.liveView = LabelViewController()


