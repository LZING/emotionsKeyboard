//
//  LZEmoticonKeyboard.swift
//  emotionsKeyboard
//
//  Created by lzing on 16/3/31.
//  Copyright © 2016年 LZING. All rights reserved.
//

import UIKit

class LZEmoticonKeyboard: UIView {
    
    //MARK: - attribute
    private let reuseIdentifier = "reuseIdentifier"
    /// 键盘对应的textView
    weak var textView : UITextView?
    
    override init(frame: CGRect) {
        let newFrame = CGRect(x: 0, y: 0, width: UIScreen.width, height: 216)
        super.init(frame: newFrame)
        // 添加子控件
        addSubview()
        // 添加约束
        addConstraint()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///  添加子控件
    private func addSubview() {
        addSubview(collectionView)
        addSubview(emoticonToolBar)
        addSubview(pageControl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 设置itemSize
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = collectionView.frame.size
    }
    
    ///  添加约束
    private func addConstraint() {
        // 关闭autoresizing
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        emoticonToolBar.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        // 设置约束
        // 水平约束
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView" : collectionView]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[emoticonToolBar]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["emoticonToolBar" : emoticonToolBar]))
        // 垂直约束
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-0-[emoticonToolBar(toolBarHeight)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["toolBarHeight" : 44], views: ["collectionView" : collectionView, "emoticonToolBar" : emoticonToolBar]))
        // 设置pageControl约束
        addConstraint(NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: collectionView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 26))
    }
    
    //MARK: - lazy
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        // 滚动方向
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        // 配置colltionView
        let colletionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        colletionView.backgroundColor = UIColor(patternImage: UIImage(named: "emoticon_keyboard_background")!)
        colletionView.bounces = false
        colletionView.pagingEnabled = true
        colletionView.showsHorizontalScrollIndicator = false
        colletionView.showsVerticalScrollIndicator = false
        // 设置代理
        colletionView.delegate = self
        colletionView.dataSource = self
        // 注册cell
        colletionView.registerClass(LZEmoticonKeyboardPageCell.self, forCellWithReuseIdentifier: self.reuseIdentifier)
        return colletionView
    }()
    
    private lazy var emoticonToolBar : LZEmoticonToolBar =  {
        let bar = LZEmoticonToolBar.emotionToolBar()
        bar.delegate = self
        return bar
    }()
    
    private lazy var pageControl : UIPageControl = {
        let pageControl = UIPageControl()
//        成员变量名:_currentPageImage---成员类型:@"UIImage"
        pageControl.setValue(UIImage(named: "compose_keyboard_dot_selected"), forKey: "_currentPageImage")
//        成员变量名:_pageImage---成员类型:@"UIImage"
        pageControl.setValue(UIImage(named: "compose_keyboard_dot_normal"), forKey: "_pageImage")
        return pageControl
    }()
}

//MARK: - <LZEmoticonToolBarDelegate>
extension LZEmoticonKeyboard : LZEmoticonToolBarDelegate {
    func emotionToolBar(toolBar: LZEmoticonToolBar, didSelectType type: LZEmoticonToolBarButtonType) {
        let indexPath = NSIndexPath(forItem: 0, inSection: type.rawValue)
        // 选中item
        collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.Left)
        // 设置pageControl
        setupPageControl(indexPath)
    }
}

//MARK: - <UICollectionViewDelegate,UICollectionViewDataSource>
extension LZEmoticonKeyboard : UICollectionViewDelegate,UICollectionViewDataSource {
    ///  返回组数
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return LZEmoticonPackageManager.sharedEmoticonPackageManager.packages.count
    }
    
    ///  返回每组item个数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LZEmoticonPackageManager.sharedEmoticonPackageManager.packages[section].pageEmoticons.count
    }
    
    ///  返回cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! LZEmoticonKeyboardPageCell
        ///  设置模型数据
        cell.emoticons = LZEmoticonPackageManager.sharedEmoticonPackageManager.packages[indexPath.section].pageEmoticons[indexPath.item];
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    
    ///  监听collectionView滚动
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // 计算参照点
        var refPoint = scrollView.center
        refPoint.x += scrollView.contentOffset.x
        // 判断哪个cell包含这个参照点
        for cell in collectionView.visibleCells() {
            if cell.frame.contains(refPoint) {
                // 显示这个cell所在的组
                let indePath = collectionView.indexPathForCell(cell)!
                // 让toolBar选中按钮
                emoticonToolBar.switchSelectedButtonWithSection(indePath.section)
                // 设置pageControl
                setupPageControl(indePath)
                break
            }
        }
    }
    
    //MARK: - 设置pageControl
    private func setupPageControl(indexPath : NSIndexPath) {
        // 设置当前页码
        pageControl.currentPage = indexPath.item
        pageControl.numberOfPages = LZEmoticonPackageManager.sharedEmoticonPackageManager.packages[indexPath.section].pageEmoticons.count
        // 设置第一页的时候隐藏
        pageControl.hidden = indexPath.section == 0
    }
}

//MARK: - <LZEmoticonKeyboardPageCellDelegate>
extension LZEmoticonKeyboard : LZEmoticonKeyboardPageCellDelegate {
    // 图片按钮点击方法
    func emoticonKeyboardPageCell(cell: LZEmoticonKeyboardPageCell, didSelectEmoticon emoticon: LZEmoticonModel) {
        ///  插入表情
        insertEmoticon(emoticon)
        // 添加最近表情
        LZEmoticonPackageManager.sharedEmoticonPackageManager.addFavourite(emoticon)
    }
    
    // 删除按钮点击方法
    func emoticonKeyboardPageCellDeleteButtonDidClick() {
        textView?.deleteBackward()
    }
    
    ///  插入表情的方法
    private func insertEmoticon(emoticon : LZEmoticonModel) {
        // 没有传入textView
        guard let view = textView else {
            assert(false, "需要传入textView")
            return
        }
        // 添加emoji表情
        if let emoji = emoticon.emoji {
            // 插入表情
            view.insertText(emoji)
            return
        }
        // 图片表情
        if let fullPngPath = emoticon.fullPngPath {
            // 图片->附件->属性文本
            let attachment = LZTextAttachment()
            attachment.chs = emoticon.chs
            attachment.image = UIImage(named: fullPngPath)
            let wh = (view.font?.lineHeight ?? 20) * 0.8
            attachment.bounds = CGRectMake(0, -3, wh, wh)
            // 可变富文本
            let attributeM = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
            // 设置附件属性
            attributeM.addAttribute(NSFontAttributeName , value: view.font!, range: NSRange(location: 0, length: 1))
            // 不能直接替换属性文本,取出老的文本
            let oldAttrM = NSMutableAttributedString(attributedString: view.attributedText)
            // 取出选中的范围
            let oldRange = view.selectedRange
            // 将附件添加到之间老的属性文本中
            oldAttrM.replaceCharactersInRange(oldRange, withAttributedString: attributeM)
            // 设置文本
            view.attributedText = oldAttrM
            // 移动光标到最后
            view.selectedRange = NSRange(location: oldRange.location + 1, length: 0)
        }
    }
}
