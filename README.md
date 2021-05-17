
#### 效果图
![image](https://github.com/04zhujunjie/ZJJForm/blob/main/ZJJForm.gif)

### 特点：
1、提供基础表单样式，也可以自定义  
2、可对输入的文本进行验证  
3、cell可以根据输入的文本长度，进行高度的自适应       
4、cell的不同样式，只需要根据ZJJFormModel对象进行配置即可        
 
#### 表单用到的枚举：      
```
enum ZJJFormCellStyle  {
    case `default`
    case option
    case value1
    case value2
    case input1
    case input2
    case textView1
    case textView2
    case customIdentifier(String) //自定义Cell的identifier
   
    func cellIdentifier() -> String {
        switch self {
        case .option:
            return kZJJFormTextViewOneCellIdentifier
        case .value1:
            return kZJJFormValueOneCellIdentifier
        case .value2:
            return kZJJFormValueTwoCellIdentifier
        case .input1:
            return kZJJFormInputOneCellIdentifier
        case .input2:
            return kZJJFormInputTwoCellIdentifier
        case.textView1:
            return kZJJFormTextViewOneCellIdentifier
        case.textView2:
            return kZJJFormTextViewTwoCellIdentifier
        case .customIdentifier(let identifier):
            return identifier
        default:
            return kZJJFormValueOneCellIdentifier
        }
    }
}

enum ZJJFormRequiredType {
    case none //非必须
    case required //必须
    case requiredAndStar //必须带红星
}

enum ZJJFormInputReturnDoneType {
    case none //
    case hiddenKeyboard //隐藏键盘
    case next //进入下一个输入框
}

enum ZJJFormInputErrorType {
    case none //不显示
    case line //显示下横线 ，就是横线变色
    case label //显示错误的信息
    case lineAndLabel //显示错误的信息和横线变色
}


enum ZJJFormInputVerifyType {
    case none 
    case editing //编辑的过程中进行验证，验证不通过，显示错误提示（可以继续输入）
    case stopEditing //编辑的过程中进行验证，验证不通过，禁止输入
    case endEdit //编辑结束后，在进行验证，验证不通过，显示错误提示
}

```

#### 表单文本基础设置对象
```
struct ZJJFormText {
    
    var requiredType = ZJJFormRequiredType.none //是否必填
    var key:String = ""  //左边或上边文本
    var value:String = "" //右边值或者输入的
    var serviceKey:String = "" //后台字段key,方便通过serviceKey值，取对应的值
}

```

#### 表单Cell的UI样式对象

```
struct ZJJFormUI {
    var cellHeight:CGFloat = UITableView.automaticDimension //默认使用表格动态布局
    var cellSpace:CGFloat = 0 //cell与tableView两边的边距,左右的边距相等
    var isShowArrow:Bool = false //是否显示箭头>
    var isHiddenLine:Bool = false // 是否隐藏分割线，默认false
    var lineLeftMargin:CGFloat = kZJJFormUIMargin //分割线与左边的边距
    var lineHeight:CGFloat = 0.5 //分割线的高度
    var lineRightMargin:CGFloat = kZJJFormUIMargin //分割线与右边的边距
    var separatorLineColor:UIColor = UIColor(red: 0.42, green: 0.41, blue: 0.47,alpha:0.3)// 分割线颜色
    var errorFont:UIFont = .systemFont(ofSize: 12) //错误提示的字体大小
    var errorColor:UIColor = UIColor.red//错误的时候，错误提示的文本或线条的颜色
    var starColor:UIColor = UIColor.red //🌟的颜色
    var lineBreakMode :NSLineBreakMode = .byCharWrapping
    var keyTextColor:UIColor = .black //左边文本颜色
    var valueTextColor:UIColor = .black //右边边文本颜色
    var keyTextFont:UIFont = .systemFont(ofSize: 16) //左边文本字体的大小
    var valueTextFont:UIFont = .systemFont(ofSize: 16)  //右边文本字体的大小
    var placeholderColor:UIColor = UIColor(red: 0.42, green: 0.41, blue: 0.47,alpha:0.5)  //输入框的placeholder字体颜色
    var placeholderFont:UIFont = .systemFont(ofSize: 14)  //输入框的placeholder字体的大小
    var inputTextAlignment:NSTextAlignment = .right //输入框的文本对齐样式
}
```


#### 如何使用

1、创建ZJJFormModel对象，根据功能来设置model的对象（文本的是ZJJFormBaseModel对象，输入框的是ZJJFormInputModel对象，选项的是ZJJFormOptionModel对象）  
```
class ZJJFormModel{
    var cellStyle:ZJJFormCellStyle = .default //cell的样式
    var model:ZJJFormBaseModel
    init(cellStyle:ZJJFormCellStyle,model:ZJJFormBaseModel) {
        self.cellStyle = cellStyle
        self.model = model
    }
}
```

2、对象的创建

1)、文本显示，创建ZJJFormBaseModel对象

```
class ZJJFormBaseModel : NSObject,ZJJFormBlockBaseProtocol {
    var formSelectCellBlock: ZJJFormBaseBlock?
    func formSelectCell(block:@escaping ZJJFormBaseBlock)  {
        self.formSelectCellBlock = block
    }
    var valueType:Int = 0 //自定义标识
    var param:[String:Any?] = [:] //自定义携带的参数
    var formText:ZJJFormText = ZJJFormText()
    var formUI:ZJJFormUI = ZJJFormUI() //UI样式
}
```

2)、输入框显示，创建ZJJFormInputModel对象，其中verify属性是验证类

```
class ZJJFormInputModel: ZJJFormBaseModel,ZJJFormBlockInputProtocol {
    
    var formValueBeginEditingBlock: ZJJFormInputBlock?
    var formValueChangeBlock: ZJJFormInputBlock?
    var formValueDidEndEditBlock: ZJJFormInputBlock?
    var formValueReturnBlock: ZJJFormInputBlock?
    func formValueBeginEditing(block: @escaping ZJJFormInputBlock) {
        self.formValueBeginEditingBlock = block
    }
    func formValueChange(block:@escaping ZJJFormInputBlock)  {
        self.formValueChangeBlock = block
    }
    func formValueDidEndEdit(block:@escaping ZJJFormInputBlock)  {
        self.formValueDidEndEditBlock = block
    }
    func formValueReturn(block: @escaping ZJJFormInputBlock) {
        self.formValueReturnBlock = block
    }
    var maxLength:Int = 255
    var isScrollEnabled:Bool = false //textView，当文字超过视图的边框时，是否允许滑动
    var keyboardType: UIKeyboardType = .default //输入键盘类型
    var returnKeyType:UIReturnKeyType = .default //return键的类型
    var returnDoneType:ZJJFormInputReturnDoneType = .none //设置点击return，要做的事，支持隐藏键盘和跳转到下一个输入框
    var placeholder:String = "" //输入框占位文本
    var verify:ZJJFormVerify = ZJJFormVerify() //校验输入框的类
    var isConsecutiveSpaces:Bool = false //是否连续空格，如果连续两个空格以上，会导致多出一个点代替空格
    var inputAccessoryView:UIView? //键盘上的工具栏
}
```


```
class ZJJFormVerify {
    var errorType:ZJJFormInputErrorType = .none //显示出错的信息类型
    var isBeginEnditingHiddenError:Bool = true //如果有错误提示，是否开始的编辑的时候就隐藏错误提示，true表示隐藏，false表示显示
    var errorMsg:String? //错误的信息提示
    fileprivate(set)   var type:ZJJFormInputVerifyType = .none //验证类型，在什么情况下进行验证
    var verifyValueBlock:ZJJFormInputVerifyValueBlock? //验证回调
    
    init(type:ZJJFormInputVerifyType = .none,errorMsg: String? = nil, verifyValueBlock:ZJJFormInputVerifyValueBlock? = nil){
        self.errorMsg = errorMsg
        self.type = type
        self.verifyValueBlock = verifyValueBlock
    }
}
```

3)、选项显示，创建ZJJFormOptionModel对象，可以结合ZJJPopup来使用，ZJJPopup的具体使用[GitHub地址](https://github.com/04zhujunjie/ZJJPopup)

```
class ZJJFormOptionModel:ZJJFormInputModel {
    var option:ZJJOption = ZJJOption()
}
```

 3、表单的UItableView建议使用ZJJFormTableView或者ZJJFormBaseTableView，设置表单的数据源dataArray

 4、参数的组装和验证，可以使用ZJJFormParam

```
struct ZJJFormParam {
    var isValid:Bool = false //全部的验证是否通过
    var firstErrorMsg:String? //第一个错误的信息提示语
    var param:[String:Any?] = [:] //组装的参数
    var filterArray:[ZJJFormModel] = [] //筛选出来的对象
    init(dataArray:[ZJJFormSectionModel],errorType:ZJJFormInputErrorType = .lineAndLabel,filterServiceKeys:[String] = [],filterValueTypes:[Int] = [])
}

```

#### 自定义cell

1、文本显示，继承ZJJFormBaseCell，并调用以下方法

```
   func setFormBaseCellSubView(keyLabel:UILabel?,valueLabel:UILabel? = nil)
```
2、UITextField的显示，继承ZJJFormTextFieldBaseCell，并调用以下方法
```
func setFormTextFieldCellSubView(keyLabel:UILabel?,textField:UITextField? = nil,errorLabel:UILabel? = nil)
```
3、UITextView的显示，继承ZJJFormTextViewBaseCell，并调用以下方法
```
func setFormTextViewCellSubView(keyLabel:UILabel?,textView:UITextView? = nil,errorLabel:UILabel? = nil)
```
4、选项的显示，可以继承ZJJFormTextFieldBaseCell或者ZJJFormTextViewBaseCell来进行自定义，
建议继承ZJJFormTextViewBaseCell，这样可以直接使用placeholder，需要设置textView的isEditable和isUserInteractionEnabled属性为false
