//
//  PKKLineTopButtonsView.swift
//  PrincekinKlineFrame
//
//  Created by LEE on 7/11/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit
import SnapKit
//tag占用情况      100~  button

/// PKKLineTopButton 风格设置选项
fileprivate enum PKTopButtonType: String {
    case Line = "Line", fifteenM = "15min" , oneH = "1hour", fourH = "4hour",oneD = "1day",More = "More",Index = "Index"
    public static func enumValue(_ rawValue: String) -> PKTopButtonType {
        return PKTopButtonType.init(rawValue: rawValue)!
    }
}
/// MoreOptionButtonType 风格设置选项 "More" 按钮
fileprivate enum MoreOptionButtonType: String {
    case oneM = "1min", fiveM = "5min", thirtyM = "30min",twoH = "2hour",sixH = "6hour",twelveH = "12hour", oneW = "1week"
    public static func enumValue(_ rawValue: String) -> MoreOptionButtonType {
        return MoreOptionButtonType.init(rawValue: rawValue)!
    }
}

/// MoreIndexButtonType 风格设置选项 "More" 按钮
enum IndexOptionButtonType: String {
    case MA = "MA", BOLL = "BOLL", MainHide = "MainHide", MACD = "MACD", KDJ = "KDJ", RSI = "RSI", WR = "WR" , SubHide = "SubHide"
    public static func enumValue(_ rawValue: String) -> IndexOptionButtonType {
        return IndexOptionButtonType.init(rawValue: rawValue)!
    }
}


//添加到父视图的Block回调,系统的方法不好用
public typealias PKKLineTopButtonsViewButtonClickBlock = (String) -> Void
let ChineseEnglishDictionary = ["分时":"Line","15分钟":"15min","1小时":"1hour","4小时":"4hour","1天":"1day","更多":"More","指标":"Index","1分钟":"1min","5分钟":"5min","30分钟":"30min","2小时":"2hour","6小时":"6hour","12小时":"12hour","1周":"1week"]
//中英文转换
func translateChineseToEnglish(_ Chinese : String) -> String {
    //是否含有中文字符
   if VerificationEnumManager.containChineseCharacters(Chinese).isRight{
    return ChineseEnglishDictionary[Chinese]!
   }else{
    return Chinese
    }
}

public class PKKLineTopButtonsView: UIView {
    //时间的
    var selectedTimeTopButton : PKBaseTopButton?
    //"More","Index"类型当前选择的button
    var selectedOptionTopButton : PKOptionButton?
    //"More"按钮对应的view
    weak var pMoreBtnView : PKMoreOptionButtonsView?
    //"Index"按钮对应的view
    weak var pIndexBtnView : PKIndexOptionButtonsView?
    weak var pMoreTopButton : PKOptionButton!
    weak var pIndexTopButton : PKOptionButton!
    //初始化点击的按钮
    var beginButton : PKBaseTopButton!
    var buttonClickBlock : PKKLineTopButtonsViewButtonClickBlock!
    var indexButtonBeClickedBlock : ((String) -> Void)?
    
  //  let buttonsTitleArray = ["Line","15min","1hour","4hour","1day","More","Index"]
       let buttonsTitleArray = [String.localized_b2b_time_division,String.localized_b2b_time_15m,String.localized_b2b_time_1h,String.localized_b2b_time_4h,String.localized_b2b_time_1d,String.localized_more,String.localized_b2b_index]
    var buttonsDictionary = [String : PKBaseTopButton]()
    
    convenience init() {
        self.init(frame: .zero)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = PKKLineTheme.KLineChartBgColor
        createOptionButtonsViews()
        createButtons()
        //通过代码主动点击按钮
        weak var weakSelf = self
        buttonClickBlock = { title in
            if weakSelf!.buttonsTitleArray.contains(title){
            weakSelf!.topButtonClick(button: weakSelf!.buttonsDictionary[title]!)
            }else{
            weakSelf!.pMoreBtnView!.buttonClickBlock(title)
            }
        }
        
    }
    func createButtons() {
        var preBtn : PKBaseTopButton?
        for i in 0..<buttonsTitleArray.count {
            var topButton : PKBaseTopButton
            if i < 5{
                topButton = PKTimeTopButton()
                buttonsDictionary[buttonsTitleArray[i]] = topButton
            }else{
                topButton = PKOptionButton()
            }
            topButton.addTarget(self, action: #selector(topButtonClick(button:)), for: .touchUpInside)
            let titleString = buttonsTitleArray[i]
            topButton.topButtonType = PKTopButtonType.enumValue(translateChineseToEnglish(titleString))
            topButton.titleString = titleString
            addSubview(topButton)
            //15min默认点击
            if titleString == String.localized_b2b_time_15m{
               // topButtonClick(button: topButton)
                beginButton = topButton
            }
            topButton.snp.makeConstraints {  make in
                if i == 0{
                    make.left.equalToSuperview()
                    //    topButtonClick(button: topButton)
                }else{
                    make.left.equalTo(preBtn!.snp.right)
                }
                preBtn = topButton
                make.top.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(1.0 / Double(buttonsTitleArray.count))
                make.height.equalTo(30)
            }
            if topButton.topButtonType == .More{
                pMoreTopButton = topButton as! PKOptionButton
                pMoreTopButton.buttonsView = pMoreBtnView
                pMoreBtnView?.moreBtn = pMoreTopButton
            }else if topButton.topButtonType == .Index{
                pIndexTopButton = topButton as! PKOptionButton
                pIndexTopButton.buttonsView = pIndexBtnView
                pIndexBtnView?.indexBtn = pIndexTopButton
            }
        }
    }
    
    
    func createOptionButtonsViews() {
        let moreBtnView = PKMoreOptionButtonsView()
        addSubview(moreBtnView)
        moreBtnView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.snp.bottom)
            make.height.equalTo(40)
        }
        pMoreBtnView = moreBtnView
        let indexBtnView = PKIndexOptionButtonsView()
        indexButtonBeClickedBlock = indexBtnView.buttonBeClickedBlock
        addSubview(indexBtnView)
        indexBtnView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.snp.bottom)
            make.height.equalTo(100)
        }
        pIndexBtnView = indexBtnView
        
    }
    @objc func topButtonClick(button : PKBaseTopButton) {
        
        if button.isKind(of: PKOptionButton.self) {    //分为“option”和“base”  button类型去处理
            if selectedOptionTopButton == button{
                selectedOptionTopButton!.isSelected = !selectedOptionTopButton!.isSelected
            }else{
                selectedOptionTopButton?.isSelected = false
                button.isSelected = true
                selectedOptionTopButton = button as? PKOptionButton
            }
            if button == pMoreTopButton && button.titleString != String.localized_more{
                selectedTimeTopButton?.isSelected = false
            }
        }else{
            PKKLineParamters.KLineType = PKKLineType.enumValue(string: button.topButtonType.rawValue)
            pMoreTopButton?.setTitle(String.localized_more, for: .normal)
            pMoreTopButton?.setTitle(String.localized_more, for: .selected)
            pMoreTopButton.setTitleColor(PKKLineTheme.BtnNormalColor, for: .normal)
            selectedOptionTopButton?.isSelected = false
            selectedTimeTopButton?.isSelected = false
            button.isSelected = true
            selectedTimeTopButton = button
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
    deinit {
 
    }
}
class PKBaseTopButton: UIButton {
    
    var titleString : String?{
        didSet{
            setTitle(titleString, for: .normal)
            setTitle(titleString, for: .selected)
        }
    }
    override var isSelected: Bool{
        didSet{
        }
    }
    convenience init() {
        self.init(frame: .zero)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    }
    fileprivate var topButtonType : PKTopButtonType!
}
class PKTimeTopButton: PKBaseTopButton {
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
class PKOptionButton: PKBaseTopButton {
    var optionBackgroundColor : UIColor!
   weak var buttonsView : PKOptionButtonsView?
    
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
        super.draw(rect)
        let color = isSelected ? PKKLineTheme.OptionButtonsViewBgColor : PKKLineTheme.KLineChartBgColor
        color.setFill()
        UIRectFill(self.bounds)
        
        //拿到当前视图准备好的画板
        let context : CGContext = UIGraphicsGetCurrentContext()!
        //利用path进行绘制三角形
        context.beginPath();//标记
        context.move(to: CGPoint(x:frame.width - 6, y: titleLabel!.frame.maxY ))
        context.addLine(to: CGPoint(x: frame.width - 6, y: titleLabel!.frame.maxY - 8))
        context.addLine(to: CGPoint(x: frame.width - 14, y: titleLabel!.frame.maxY))
        context.closePath();//路径结束标志，不写默认封闭
        optionBackgroundColor.setFill()
        UIColor.clear.setStroke()
        context.drawPath(using: .fillStroke)
    }
}
class PKMoreOptionButton: PKOptionButton {
    override var isSelected: Bool{
        didSet{
            if titleString != String.localized_more{
                titleLabel?.textColor = UIColor.white
            }
        }
    }
}
class PKIndexOptionButton: PKOptionButton {
    override var isSelected: Bool{
        didSet{
        }
    }
}
class PKOptionButtonsView: UIView{
    var snpHeight : Double = 0
    convenience init() {
        self.init(frame: .zero)
        backgroundColor = PKKLineTheme.OptionButtonsViewBgColor
        isHidden = true
    }
}
class PKMoreOptionButtonsView: PKOptionButtonsView {
    var buttonClickBlock : PKKLineTopButtonsViewButtonClickBlock!
   // let titleArray = ["1min","5min","30min","2hour","6hour","12hour","1week"]
    var titleArray  : [String]!
    var buttonsDictionary = [String : MoreOptionButton]()
    weak var moreBtn : PKOptionButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleArray = [String.localized_b2b_time_1m,String.localized_b2b_time_5m,String.localized_b2b_time_30m,String.localized_b2b_time_2h,String.localized_b2b_time_6h,String.localized_b2b_time_12h,String.localized_b2b_time_1w]
        createButtons()
        weak var weakSelf = self
        buttonClickBlock = { title in
            weakSelf!.moreOptionButtonClick(moreOptionButton: weakSelf!.buttonsDictionary[title]!)
        }
    }
    func createButtons() {
        var preBtn : MoreOptionButton?
        let btnWidth = PKKLineConfig.WIDTH / CGFloat(titleArray.count)
        
        for i in 0..<titleArray.count {
            let button = MoreOptionButton()
            let titleString = titleArray[i]
            button.titleString = titleString
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
                make.width.equalTo(btnWidth)
            }
            buttonsDictionary[titleString] = button
        }
    }
    @objc func moreOptionButtonClick(moreOptionButton : MoreOptionButton) {
         PKKLineParamters.KLineType = PKKLineType.enumValue(string: moreOptionButton.moreOptionButtonType.rawValue)
        moreBtn.titleString = moreOptionButton.titleString
        moreBtn.setTitleColor(PKKLineTheme.BtnSelectedColor, for: .normal)
        let topView : PKKLineTopButtonsView = superview as! PKKLineTopButtonsView
        topView.topButtonClick(button: moreBtn)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
   
    }
}
enum PKIndexSUBViewType : Int {
    case Main
    case Sub
}
//"index"的按钮群
class PKIndexOptionButtonsView: PKOptionButtonsView {
    weak var indexBtn : PKOptionButton!
    var buttonBeClickedBlock : ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        createSubViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func createSubViews() {
        let mainView = PKIndexMainView()
        addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(30)
        }
        let subView = PKIndexSubView()
        addSubview(subView)
        subView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mainView.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        buttonBeClickedBlock = {
            str in
           mainView.changeButtonUIByStr(str)
            subView.changeButtonUIByStr(str)
        }
    }

   
    class PKIndexMainView: PKIndexSUBView {
        init() {
            super.init(frame: .zero)
            type = .Main
          //  NotificationCenter.default.addObserver(self, selector: #selector(changeButtonUI(_:)), name: PKKLineParamters.FullScreenRightViewButtonClickNot, object: nil)
        }
        //PKKLineContainerView环境中才会调用此方法
        @objc func changeButtonUI(_ not : Notification) {
            let type : IndexOptionButtonType = not.object as! IndexOptionButtonType
            if let button = indexButtonDictionary[type.rawValue] {
                selectMainnbutton(button)
            }
        }
        @objc func changeButtonUIByStr(_ str : String) {
            if let button = indexButtonDictionary[str] {
                selectMainnbutton(button)
            }
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    class PKIndexSubView: PKIndexSUBView {
        init() {
            super.init(frame: .zero)
            type = .Sub
        //    NotificationCenter.default.addObserver(self, selector: #selector(changeButtonUI(_:)), name: PKKLineParamters.FullScreenRightViewButtonClickNot, object: nil)
            
        }
        //PKKLineContainerView环境中才会调用此方法
        @objc func changeButtonUI(_ not : Notification) {
            let type : IndexOptionButtonType = not.object as! IndexOptionButtonType
            if let button = indexButtonDictionary[type.rawValue] {
                selectSubbutton(button)
            }
        }
        @objc func changeButtonUIByStr(_ str : String) {
            if let button = indexButtonDictionary[str] {
                selectSubbutton(button)
            }
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    
}

class PKIndexSUBView: UIView {
    var pVerticalLine : UILabel?
    var titleArray : [String]!
    var indexButtonDictionary = [String : IndexOptionBaseButton]()
    
    //当前选择的"Main"  button
    var selectedMainButton : IndexOptionBaseButton?
    //当前选择的"Sub"  button
    var selectedSubButton : IndexOptionBaseButton?
   var type : PKIndexSUBViewType?{
        didSet{
            if type == .Main {
                titleArray = ["MA","BOLL"]
            }else{
                titleArray = ["MACD","KDJ","RSI"]
            }
            setUPUI()
            
        }
    }
    convenience init(type : PKIndexSUBViewType) {
        self.init(frame: .zero)
        self.type = type
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUPUI() {
        createPreLabels()
        createButtons()
      
    }

    func createPreLabels() {
        //"Main"标签
        let mainLabel = UILabel()
        mainLabel.font = UIFont.systemFont(ofSize: 12)
        mainLabel.textColor = PKKLineTheme.OptionButtonsViewLabelBgColor
        if type == .Main {
            mainLabel.text = String.localized_b2b_index_main
        }else{
            mainLabel.text = String.localized_b2b_index_sub
        }
        mainLabel.textAlignment = .center
        addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(50)
        }
        //竖线
        let verticalLine = UILabel()
        verticalLine.backgroundColor = PKKLineTheme.BtnNormalColor
        addSubview(verticalLine)
        verticalLine.snp.makeConstraints { make in
            make.left.equalTo(mainLabel.snp.right)
            //  make.top.bottom.equalToSuperview().offset(4)
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.width.equalTo(0.5)
        }
        pVerticalLine = verticalLine
    }
    func createButtons() {
        var preBtn : IndexOptionButton?
        for i in 0..<titleArray.count {
            let button = IndexOptionButton()
            button.addTarget(self, action: #selector(IndexOptionButtonClick(_:)), for: .touchUpInside)
            let titleString = titleArray[i]
            button.titleString = titleString
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            addSubview(button)
            
            button.snp.makeConstraints { make in
                if i == 0{
                    make.left.equalTo(pVerticalLine!.snp.right)
                    if type == .Main{
                        IndexOptionButtonClick(button)
                    }else{
                        
                    }
                }else{
                    make.left.equalTo(preBtn!.snp.right)
                }
                preBtn = button
                make.top.bottom.equalToSuperview()
                make.width.equalTo(60)
            }
            indexButtonDictionary[titleString] = button
        }
        
        let hideButton = IndexHideButton()
        addSubview(hideButton)
        if type == .Main {
            hideButton.indexOptionButtonType = IndexOptionButtonType.enumValue("MainHide")
        }else{
            hideButton.indexOptionButtonType = IndexOptionButtonType.enumValue("SubHide")
            IndexOptionButtonClick(hideButton)
        }
        indexButtonDictionary[hideButton.indexOptionButtonType.rawValue] = hideButton
        hideButton.addTarget(self, action: #selector(IndexOptionButtonClick(_:)), for: .touchUpInside)
        hideButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(60)
        }
    }
    //  case MA = "MA", BOLL = "BOLL", MainHide = "MainHide", MACD = "MACD", KDJ = "KDJ", RSI = "RSI", WR = "WR" , SubHide = "SubHide"
    //”Index“模块  按钮群的点击事件
    @objc func IndexOptionButtonClick(_ button : IndexOptionBaseButton) {
        let topView : PKKLineTopButtonsView? = superview?.superview as? PKKLineTopButtonsView
        let indexOptionButtonsView : PKIndexOptionButtonsView? = superview as? PKIndexOptionButtonsView
        topView?.topButtonClick(button: (indexOptionButtonsView?.indexBtn)!)
        
        switch button.indexOptionButtonType {
            
        case .MA?:
            selectMainnbutton(button)
            
            break
        case .BOLL?:
            selectMainnbutton(button)
            break
        case .MainHide?:
//            PKKLineParamters.KLineMAType = PKKLineMAType.enumValue(string: "Close")
//            selectedMainButton?.isSelected = false
            selectMainnbutton(button)
            break
        case .MACD?:
            selectSubbutton(button)
            break
        case .KDJ?:
            selectSubbutton(button)
            break
        case .RSI?:
            selectSubbutton(button)
            break
        case .WR?:
            selectSubbutton(button)
            break
        case .SubHide?:
//            PKKLineParamters.AccessoryType = PKKLineAccessoryType.enumValue(string: "Close")
//            selectedSubButton?.isSelected = false
            selectSubbutton(button)
            break
        default:
            break
            
            
        }
        
    }
    //切换当前选择的”Main“  button
    func selectMainnbutton(_ button: IndexOptionBaseButton)  {
     //   PKKLineParamters.KLineMAType = PKKLineMAType.enumValue(string: button.titleLabel!.text!)
       
        if button.isKind(of: IndexHideButton.self) {
             PKKLineParamters.KLineMAType = PKKLineMAType.enumValue(string: "Close")
             selectedMainButton?.isSelected = false
        }else{
              PKKLineParamters.KLineMAType = PKKLineMAType.enumValue(string: button.indexOptionButtonType.rawValue)
        selectedMainButton?.isSelected = false
        button.isSelected = true
        selectedMainButton = button
        }
    }
    //切换当前选择的”Sub“  button
    func selectSubbutton(_ button: IndexOptionBaseButton)  {
      //  PKKLineParamters.AccessoryType = PKKLineAccessoryType.enumValue(string: button.titleLabel!.text!)
        
        if button.isKind(of: IndexHideButton.self) {
             PKKLineParamters.AccessoryType = PKKLineAccessoryType.enumValue(string: "Close")
            selectedSubButton?.isSelected = false
        }else{
             PKKLineParamters.AccessoryType = PKKLineAccessoryType.enumValue(string: button.indexOptionButtonType.rawValue)
            selectedSubButton?.isSelected = false
            button.isSelected = true
            selectedSubButton = button
        }
    }
    
}

class MoreOptionButton: UIButton {
    fileprivate var moreOptionButtonType : MoreOptionButtonType!
    var moreOptionButtonTypeValueStr : String!
    var titleString : String?{
        didSet{
            setTitle(titleString, for: .normal)
            moreOptionButtonTypeValueStr = translateChineseToEnglish(titleString!)
            moreOptionButtonType = MoreOptionButtonType.init(rawValue: moreOptionButtonTypeValueStr)
            titleLabel?.font = UIFont.systemFont(ofSize: 12)
        }
    }
    
}
class IndexOptionBaseButton: UIButton {
     var indexOptionButtonType : IndexOptionButtonType!
}

class IndexOptionButton: IndexOptionBaseButton {
    override var isSelected: Bool{
        didSet{
      
        }
    }
    
    var titleString : String?{
        didSet{
            setTitle(titleString, for: .normal)
            setTitle(titleString, for: .selected)
            setTitleColor(PKKLineTheme.BtnNormalColor, for: .normal)
            setTitleColor(PKKLineTheme.BtnSelectedColor, for: .selected)
            indexOptionButtonType = IndexOptionButtonType.enumValue(titleString!)
        }
    }
    
    
    
}
class IndexHideButton: IndexOptionBaseButton {
    convenience init() {
        self.init(frame: .zero)
        titleLabel?.font = UIFont.systemFont(ofSize: 12)
        setTitle(String.localized_hide, for: .normal)
        setTitle(String.localized_hide, for: .selected)
        setTitleColor(PKKLineTheme.BtnNormalColor, for: .normal)
        setTitleColor(PKKLineTheme.BtnNormalColor, for: .selected)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

