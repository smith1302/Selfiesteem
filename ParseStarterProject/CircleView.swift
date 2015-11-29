import UIKit

class CircleView: UIView {
    
    let circleLayer: CAShapeLayer!
    
    init(center:CGPoint, radius:CGFloat, percent:CGFloat, color:UIColor, width:CGFloat) {
        // Use UIBezierPath as an easy way to create the CGPath for the layer.
        // The path should be the entire circle.
        
        let frame = CGRectMake(center.x-radius, center.y-radius, radius*2, radius*2)
        
        let orientation = -CGFloat(M_PI/2)
        let startAngle = 0.0 + orientation
        let endAngle = CGFloat(M_PI*2)*percent + orientation
        let circlePath = UIBezierPath(arcCenter: CGPointMake(frame.size.width/2, frame.size.height/2), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = color.CGColor
        circleLayer.lineWidth = width;
        
        // Don't draw the circle initially
        circleLayer.strokeEnd = 1.0
        
        super.init(frame: CGRectMake(center.x-radius, center.y-radius, radius*2, radius*2))
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(circleLayer)
        self.backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}