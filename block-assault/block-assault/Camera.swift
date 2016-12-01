
//
//  Camera.swift
//  block-assault
//
//  Created by Edward McIntosh on 2016-11-27.
//  Copyright © 2016 Edward McIntosh. All rights reserved.
//

import Foundation


//
//  Display.swift
//  block-assault
//
//  Created by Edward McIntosh on 2016-11-10.
//  Copyright © 2016 Edward McIntosh. All rights reserved.
//

import Foundation
import SpriteKit


class Camera :SKCameraNode{
    
    
    
    override init()
    {
        
        super.init();
    }
    
    func moveTo(position:CGPoint)
    {
        let moveAction = SKAction.move(to: position, duration: 0.4);
        self.run(moveAction);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

