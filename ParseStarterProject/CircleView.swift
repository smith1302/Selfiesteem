import UIKit

class CircleView: UIView {
    
    let circleLayer: CAShapeLayer!
    
    init(frame: CGRect, percent:CGFloat, color:UIColor) {
        // Use UIBezierPath as an easy way to create the CGPath for the layer.
        // The path should be the entire circle.
        let orientation = -CGFloat(M_PI/2)
        let startAngle = 0.0 + orientation
        let endAngle = CGFloat(M_PI*2)*percent + orientation
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = color.CGColor
        circleLayer.lineWidth = 3.0;
        
        // Don't draw the circle initially
        circleLayer.strokeEnd = 1.0
        
        super.init(frame: frame)
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(circleLayer)
        self.backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}