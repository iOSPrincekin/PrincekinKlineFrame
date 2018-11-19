//
//  PKKLineFullScreenBottomView.swift
//  Canonchain
//
//  Created by LEE on 7/19/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit
/// PKKLineTopButton 风格设置选项
fileprivate enum PKBottomButtonType: String {
    case Line = "Line", fifteenM = "15min", thirtyM = "30min", oneH = "1hour", twoH = "2hour", fourH = "4hour",oneD = "1day",oneW = "1week",More = "More"
    public static func enumValue(_ rawValue: String) -> PKBottomButtonType {
        return PKBottomButtonType.init(rawValue: rawValue)!
    }
}
/// MoreOptionButtonType 风格设置选项 "More" 按钮
fileprivate enum MoreOptionButtonType: String {
    case oneM = "1min", fiveM = "5min",sixH = "6hour",twelveH = "12hour"
    public static func enumValue(_ rawValue: String) -> MoreOptionButtonType {
        return MoreOptionButtonType.init(rawValue: rawValue)!
    }
}
//class PKKLineFullScreenBottomView: UIView {
//
//
//
//}


public class PKKLineFullScreenBottomView: UIView {
    var selectedBottomButton : PKBaseBottomButton?
    //"More"按钮对应的view
    var pMoreBtnView : PKBottomMoreOptionButtonsView?
    var pMoreTopButton : PKBottomOptionButton!
    //初始化点击的按钮
    var beginButton : PKBaseBottomButton!
 //   var addToSuperViewBlock : PKKLineAddToSuperViewBlock!
  //  let buttonsTitleArray = ["Line","15min","30min","1hour","2hour","4hour","1day","1week","More"]
     let buttonsTitleArray = [String.localized_b2b_time_division,String.localized_b2b_time_15m,String.localized_b2b_time_30m,String.localized_b2b_time_1h,String.localized_b2b_time_2h,String.localized_b2b_time_4h,String.localized_b2b_time_1d,String.localized_b2b_time_1w,String.localized_more]
    convenience init() {
        self.init(frame: .zero)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        createOptionButtonsViews()
        createButtons()
//        addToSuperViewBlock = {
//            self.bottomButtonClick(button: self.beginButton)
//        }
        
    }
    func createButtons() {
        var preBtn : PKBaseBottomButton?
        for i in 0..<buttonsTitleArray.count {
            var bottomButton : PKBaseBottomButton
            if i < 8{
                bottomButton = PKTimeBottomButton()
            }else{
                bottomButton = PKBottomOptionButton()
            }
            bottomButton.addTarget(self, action: #selector(bottomButtonClick(button:)), for: .touchUpInside)
            let titleString = buttonsTitleArray[i]
            bottomButton.bottomButtonType = PKBottomButtonType.enumValue(translateChineseToEnglish(titleString))
            bottomButton.titleString = titleString
            addSubview(bottomButton)
   
            bottomButton.snp.makeConstraints {  make in
                if i == 0{
                    make.left.equalToSuperview()
                    //    topButtonClick(button: topButton)
                }else{
                    make.left.equalTo(preBtn!.snp.right)
                }
                preBtn = bottomButton
                make.top.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(1.0 / Double(buttonsTitleArray.count))
                make.height.equalTo(PKKLineConfig.fullScreenBottomViewHeight)
            }
            if bottomButton.bottomButtonType == .More{
                pMoreTopButton = bottomButton as! PKBottomOptionButton
                pMoreTopButton.buttonsView = pMoreBtnView
                pMoreBtnView?.moreBtn = pMoreTopButton
                if let moreButton = pMoreBtnView!.moreButtonsDictionary[PKKLineParamters.KLineType.rawValue]{
                   pMoreBtnView?.moreOptionButtonClick(moreOptionButton: moreButton)
                }
            }
            if bottomButton.bottomButtonType.rawValue == PKKLineParamters.KLineType.rawValue {
                bottomButton.isSelected = true
                selectedBottomButton = bottomButton
            }
        }
    }
    
    
    func createOptionButtonsViews() {
        let moreBtnView = PKBottomMoreOptionButtonsView()
        addSubview(moreBtnView)
        moreBtnView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.snp.top)
            make.height.equalTo(40)
        }
        pMoreBtnView = moreBtnView
    }
    @objc func bottomButtonClick(button : PKBaseBottomButton) {
        if selectedBottomButton == button && button.isKind(of: PKBottomOptionButton.self){
            selectedBottomButton?.isSelected = !selectedBottomButton!.isSelected
        }else{
          pMoreTopButton.setTitleColor(PKKLineTheme.BtnNormalColor, for: .normal)
            selectedBottomButton?.isSelected = false
            button.isSelected = true
            selectedBottomButton = button
           pMoreTopButton.titleString = String.localized_b2b_more
//             pMoreTopButton?.setTitle(String.localized_b2b_more, for: .normal)
//            pMoreTopButton?.setTitle(String.localized_b2b_more, for: .selected)
        }
        if !button.isKind(of: PKBottomOptionButton.self){
        NotificationCenter.default.post(name: PKKLineParamters.FullScreenButtonClickNot, object: button.titleString)
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
       
    }
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
   
        if view != nil{
            return view
        }
        var targetView : UIView? = self
        var searchView : UIView? = searchReponseView(targetView!, point)
        targetView = nil
        while searchView !=  nil {
            targetView = searchView
            searchView = searchReponseView(targetView!, point)
            if targetView!.isKind(of: UIButton.self){
                return targetView
            }
        }
        return targetView
    }
    func searchReponseView(_ superView : UIView, _ point : CGPoint) ->UIView? {
        for subView in superView.subviews {
            let myPoint = subView.convert(point, from: self)
            if  subView.bounds.contains(myPoint) && subView.isHidden == false{
                return subView
            }
        }
        return nil
    }
}
class PKBaseBottomButton : PKBaseTopButton {
    fileprivate var bottomButtonType : PKBottomButtonType!
}
class PKTimeBottomButton: PKBaseBottomButton {
    let underLine = UILabel()
    override var isSelected: Bool{
        didSet{
            underLine.isHidden = !isSelected
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(PKKLineTheme.BtnNormalColor, for: .normal)
        setTitleColor(PKKLineTheme.BtnSelectedColor, for: .selected)
        addSubview(underLine)
        underLine.isHidden = true
        underLine.backgroundColor = PKKLineTheme.BtnSelectedColor
        underLine.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
            make.left.equalToSuperview().offset(6)
            make.right.equalToSuperview().offset(-6)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PKBottomOptionButton: PKBaseBottomButton {
    var optionBackgroundColor : UIColor!
    var buttonsView : PKOptionButtonsView?
    
    override var isSelected: Bool{
        didSet{
            optionBackgroundColor = isSelected ? PKKLineTheme.BtnSelectedColor : PKKLineTheme.BtnNormalColor
            buttonsView?.isHidden = !isSelected
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(PKKLineTheme.BtnNormalColor, for: .normal)
        setTitleColor(PKKLineTheme.BtnSelectedColor, for: .selected)
        titleLabel?.textAlignment = .left
        isSelected = false
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        let color = isSelected ? PKKLineTheme.OptionButtonsViewBgColor : PKKLineTheme.KLineChartBgColor
        color.setFill()
        UIRectFill(self.bounds)
        
        //拿到当前视图准备好的画板
        let context : CGContext = UIGraphicsGetCurrentContext()!
        //利用path进行绘制三角形
        context.beginPath();//标记
        context.move(to: CGPoint(x:frame.width - 6, y: 10 ))
        context.addLine(to: CGPoint(x: frame.width - 6, y:  18))
        context.addLine(to: CGPoint(x: frame.width - 14, y: 10))
        context.closePath();//路径结束标志，不写默认封闭
        optionBackgroundColor.setFill()
        UIColor.clear.setStroke()
        context.drawPath(using: .fillStroke)
    }
}

class PKBottomMoreOptionButtonsView: PKOptionButtonsView {
   // let titleArray = ["1min","5min","6hour","12hour"]
     let titleArray = [String.localized_b2b_time_1m,String.localized_b2b_time_5m,String.localized_b2b_time_6h,String.localized_b2b_time_12h]
    var moreButtonsDictionary = [String : MoreOptionButton]()
    
    weak var moreBtn : PKBottomOptionButton!{
        didSet{
            if titleArray.contains(PKKLineParamters.KLineType.rawValue) {
                moreBtn.setTitleColor(PKKLineTheme.BtnSelectedColor, for: .normal)
                moreBtn.titleString = PKKLineParamters.KLineType.rawValue
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        createButtons()
    }
    func createButtons() {
        var preBtn : MoreOptionButton?
        
        for i in 0..<titleArray.count {
            let button = MoreOptionButton()
            let titleString = titleArray[i]
           
            button.titleString = titleString
            moreButtonsDictionary[button.moreOptionButtonTypeValueStr] = button
            button.addTarget(self, action: #selector(moreOptionButtonClick(moreOptionButton :)), for: .touchUpInside)
            addSubview(button)
            button.snp.makeConstraints { make in
                if i == 0{
                    make.left.equalToSuperview()
                }else{
                    make.left.equalTo(preBtn!.snp.right)
                }
                preBtn = button
                make.top.bottom.equalToSuperview()
                make.width.equalTo(60)
            }
          
        }
        
    }
    @objc func moreOptionButtonClick(moreOptionButton : MoreOptionButton) {
      //  PKKLineParamters.KLineType = PKKLineType.enumValue(string: moreOptionButton.titleString!)
        moreBtn.titleString = moreOptionButton.titleString
        moreBtn.setTitleColor(PKKLineTheme.BtnSelectedColor, for: .normal)
        let bottomView : PKKLineFullScreenBottomView = superview as! PKKLineFullScreenBottomView
        bottomView.selectedBottomButton = moreBtn
        bottomView.bottomButtonClick(button: moreBtn)
        NotificationCenter.default.post(name: PKKLineParamters.FullScreenButtonClickNot, object: moreOptionButton.titleString)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
