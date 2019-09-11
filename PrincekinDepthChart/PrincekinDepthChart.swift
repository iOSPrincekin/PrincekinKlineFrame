//
//  PrincekinDepthChart.swift
//  PrincekinKlineFrame
//
//  Created by LEE on 9/12/19.
//  Copyright © 2019 LEE. All rights reserved.
//

import Foundation

public class PrincekinDepthChart: UIView {
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public convenience init() {
		self.init(frame: CGRect.zero)
	}
	
	private override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
}
