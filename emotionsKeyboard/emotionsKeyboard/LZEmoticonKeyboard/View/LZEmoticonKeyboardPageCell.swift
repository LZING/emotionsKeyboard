//
//  LZEmoticonKeyboardPageCell.swift
//  emotionsKeyboard
//
//  Created by lzing on 16/3/31.
//  Copyright © 2016年 LZING. All rights reserved.
//

import UIKit

//MARK: - protocol
protocol LZEmoticonKeyboardPageCellDelegate : NSObjectProtocol {
    ///  按钮点击方法
    func emoticonKeyboardPageCell(cell : LZEmoticonKeyboardPageCell, didSelectEmoticon emoticon : LZEmoticonModel)
    /// 删除按钮点击事件
    func emoticonKeyboardPageCellDeleteButtonDidClick()
}

class LZEmoticonKeyboardPageCell: UICollectionViewCell {
    //MARK: - attribute
    /// 代理
    weak var delegate : LZEmoticonKeyboardPageCellDelegate?
    /// 模型数据
    var emoticons : [LZEmoticonModel]? {
        didSet {
            guard let emoticonModels = emoticons else {
                // 没有模型数据
                LZPrint(msg: "没有模型数据")
                return
            }
            // 先隐藏所有按钮
            for button in emoticonButtons {
                button.hidden = true
            }
            // 设置按钮的图片,要显示图片或者emoji的按钮
            for (index, emoticon) in emoticonModels.enumerate() {
                // 找到对应的按钮
                let emoticonButton = emoticonButtons[index]
                emoticonButton.hidden = false
                // 传递模型数据
                emoticonButton.emoticon = emoticon
            }
        }
    }
    
    var indexPath : NSIndexPath? {
        didSet {
            debugLabel.text = "第 \(indexPath!.section) 组,第 \(indexPath!.item) 个cell"
            // 只有第0组才显示最近使用label
            recentLabel.hidden = indexPath?.section != 0
        }
    }
    
    ///  记录20个表情按钮
    private var emoticonButtons : [LZEmoticonButton] = [LZEmoticonButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ///  重新布局子控件
        relayoutButtons()
    }
    
    private func relayoutButtons() {
        let marginLR : CGFloat = 3
        let marginBottom : CGFloat = 26
        // 计算宽度
        let width = (frame.width - 2 * marginLR) / CGFloat(LZEmoticonColumnOfPage)
        // 计算高度
        let height = (frame.height - marginBottom) / CGFloat(LZEmoticonRowOfPage)
        // 遍历
        for (index, button) in contentView.subviews.enumerate() {
            // 计算按钮在哪一列
            let column = index % LZEmoticonColumnOfPage
            // 计算按钮在哪一行
            let row = index / LZEmoticonColumnOfPage
            let frame = CGRect(x: marginLR + CGFloat(column) * width, y: CGFloat(row) * height, width: width, height: height)
            button.frame = frame
        }
    }
    
    private func prepareUI() {
        //  添加20个按钮
        addEmoticonButtons()
        //  添加删除按钮
        contentView.addSubview(deleteBtn)
        //  添加最近使用Label与设置约束
        setupRecentLabel()
    }
    
    ///  添加按钮方法
    private func addEmoticonButtons() {
        for _ in 0..<LZEmoticonNumberOfPage {
            let emoticonButton = LZEmoticonButton(type: UIButtonType.Custom)
            emoticonButton.titleLabel?.font = UIFont.systemFontOfSize(32)
            contentView.addSubview(emoticonButton)
            emoticonButtons.append(emoticonButton)
            // 增加点击事件
            emoticonButton.addTarget(self, action: "emoticonButtonDidClick:", forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    //MARK: - buttonDidClick
    ///  按钮点击事件
    @objc private func emoticonButtonDidClick(emoticonButton : LZEmoticonButton) {
        delegate?.emoticonKeyboardPageCell(self, didSelectEmoticon: emoticonButton.emoticon!)
    }
    
    @objc private func deleteBtnDidClick() {
        delegate?.emoticonKeyboardPageCellDeleteButtonDidClick()
    }
    
    ///  添加最近使用Label与设置约束
    private func setupRecentLabel() {
        addSubview(recentLabel)
        recentLabel.translatesAutoresizingMaskIntoConstraints = false
        // 设置约束
        addConstraint(NSLayoutConstraint(item: recentLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: recentLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: recentLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 26))
    }
    
    //MARK: - lazy
    private lazy var debugLabel : UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFontOfSize(18)
        label.textColor = UIColor.redColor()
        label.frame = CGRect(x: 0, y: 0, width: 300, height: 170)
        label.numberOfLines = 0
        self.addSubview(label)
        
        return label
    }()
    
    ///  删除按钮
    private lazy var deleteBtn : UIButton = {
        let deleteButton = UIButton(type: UIButtonType.Custom)
        deleteButton.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
        deleteButton.addTarget(self, action: "deleteBtnDidClick", forControlEvents: UIControlEvents.TouchUpInside)
        return deleteButton
    }()
    
    /// 最近使用Label
    private lazy var recentLabel : UILabel = {
        let recentLabel = UILabel()
        recentLabel.text = "最近使用表情"
        recentLabel.textColor = UIColor.lightGrayColor()
        recentLabel.font = UIFont.systemFontOfSize(12)
        recentLabel.sizeToFit()
        return recentLabel
    }()
}
