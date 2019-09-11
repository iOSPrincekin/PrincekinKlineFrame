//
//  PKKLineFullScreenMiddleView.swift
//  Canonchain
//
//  Created by LEE on 7/19/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

class PKKLineFullScreenMiddleView: UIView {
    public let mainView = PKKLineContainerMainView()
    let rightView = PKKLineFullScreenMiddleRightView()
    convenience init() {
        self.init(frame: .zero)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUPUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUPUI() {
        let margin = 5
        addSubview(rightView)
        rightView.snp.makeConstraints { make in
           make.top.equalToSuperview().offset(margin)
            make.right.equalToSuperview().offset(-margin)
            make.bottom.equalToSuperview().offset(-margin)
            make.width.equalTo(50)
        }
        self.addSubview(self.mainView)
        mainView.snp.makeConstraints { make in
            make.right.equalTo(self.rightView.snp.left).offset(-margin)
            make.left.top.bottom.equalToSuperview()
         
        }
    }
    public func appendData(klineArray: [PKKLine]) {
        mainView.scrollView.klineView.appendData(klineArray: klineArray)
    }
    public func initData(klineArray: [PKKLine]) {
        mainView.reloadData(klineArray: klineArray)
    }

}

//class PKKLineFullScreenMiddleRightView: UIView {
//
//
//}
//"index"的按钮群
class PKKLineFullScreenMiddleRightView: PKOptionButtonsView {
    convenience init() {
        self.init(frame: .zero)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = PKKLineTheme.OptionButtonsViewBgColor
        createSubViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func createSubViews() {
        let mainView = PKIndexMainView()
        mainView.backgroundColor = UIColor.clear
        addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        let divisionLabel = UILabel()
        addSubview(divisionLabel)
        divisionLabel.backgroundColor = PKKLineTheme.BorderColor
        divisionLabel.snp.makeConstraints { make in
            make.top.equalTo(mainView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        let subView = PKIndexSubView()
        subView.backgroundColor = UIColor.clear
        addSubview(subView)
        subView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(divisionLabel.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
    }
    
    
    class PKIndexMainView: PKIndexBottomSUBView {
        init() {
            super.init(frame: .zero)
            type = .Main
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    class PKIndexSubView: PKIndexBottomSUBView {
        init() {
            super.init(frame: .zero)
            type = .Sub
            
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    
}

class PKIndexBottomSUBView: PKIndexSUBView {
   
    

    var heightMultiply : Double = 0
    
    override func createPreLabels() {
        //"Main"标签
        let mainLabel = UILabel()
        mainLabel.font = UIFont.systemFont(ofSize: 12)
        mainLabel.textColor = PKKLineTheme.OptionButtonsViewLabelBgColor
        if type == .Main {
            mainLabel.text = String.localized_b2b_index_main
            heightMultiply = 1 / 4.0
        }else{
            mainLabel.text = String.localized_b2b_index_sub
            heightMultiply = 1 / 6.0
        }
        mainLabel.textAlignment = .center
        addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(heightMultiply)
        }
        pVerticalLine = mainLabel
    }
    override func createButtons() {
        var preBtn : IndexOptionButton?
     //   初始化是否已经有已经选中的按钮
        var hadSelectedButton = false
        
        for i in 0..<titleArray.count {
            let button = IndexOptionButton()
            button.addTarget(self, action: #selector(IndexOptionButtonClick(_:)), for: .touchUpInside)
            let titleString = titleArray[i]
            button.titleString = titleString
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            addSubview(button)
            button.snp.makeConstraints { make in
            
                if i == 0{
                    make.top.equalTo(pVerticalLine!.snp.bottom)
                  
                }else{
                    make.top.equalTo(preBtn!.snp.bottom)
                }
//                if type == .Main{
//
//                    IndexOptionButtonClick(button)
//                }else{
//
//                }
           
                preBtn = button
                make.left.right.equalToSuperview()
                make.height.equalToSuperview().multipliedBy(heightMultiply)
            }
            if button.indexOptionButtonType.rawValue == PKKLineParamters.AccessoryType.rawValue || button.indexOptionButtonType.rawValue == PKKLineParamters.KLineMAType.rawValue {
                IndexOptionButtonClick(button)
                hadSelectedButton = true
            }
        }
        
        let hideButton = IndexHideButton()
        addSubview(hideButton)
        if type == .Main {
            hideButton.indexOptionButtonType = IndexOptionButtonType.enumValue("MainHide")
        }else{
            hideButton.indexOptionButtonType = IndexOptionButtonType.enumValue("SubHide")
            
        }
        if !hadSelectedButton {
        IndexOptionButtonClick(hideButton)
        }
        hideButton.addTarget(self, action: #selector(IndexOptionButtonClick(_:)), for: .touchUpInside)
        hideButton.snp.makeConstraints { make in
            make.top.equalTo(preBtn!.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(heightMultiply)
        }
    }
    override func IndexOptionButtonClick(_ button: IndexOptionBaseButton) {
        super.IndexOptionButtonClick(button)
        NotificationCenter.default.post(name: PKKLineParamters.FullScreenRightViewButtonClickNot, object: button.indexOptionButtonType)
    }
}
