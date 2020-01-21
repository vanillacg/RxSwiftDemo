//
//  MKCourseCell.swift
//  CGMK
//
//  Created by chenguang on 2019/5/16.
//  Copyright © 2019 chenguang. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit
import SDWebImage

class MKCourseCell: UITableViewCell {
    lazy var leftImageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel.init()
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        titleLabel.textColor = UIColor.black
        return titleLabel
    }()
    lazy var tagLabel: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = UIColor(hex:0x999999)
        label.layer.borderColor = UIColor.red.cgColor
        label.layer.borderWidth = 0.5
        label.layer.cornerRadius = 2
        return label
    }()
    lazy var feeLabel: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(hex:0x999999)
        return label
    }()
    lazy var commentLabel: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(hex:0x999999)
        return label
    }()
    lazy var timeLabel: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(hex:0x999999)
        return label
    }()
    lazy var sourceLabel: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(hex:0x999999)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }
    
    func buildUI() -> Void {
        addSubview(leftImageView)
        addSubview(titleLabel)
        addSubview(tagLabel)
        addSubview(sourceLabel)
        addSubview(commentLabel)
        addSubview(timeLabel)
        addSubview(feeLabel)

        leftImageView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(60)
            make.height.equalTo(40)
            make.centerY.equalTo(self)
            make.left.equalTo(12)
        }
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(leftImageView.snp.right).offset(10)
            make.top.equalTo(12)
            make.right.equalTo(-12)
        }
        tagLabel.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(14)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(titleLabel)
            make.bottom.equalTo(self).offset(-12)
        }
        sourceLabel.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(14)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(tagLabel.snp_right).offset(4)
            make.bottom.equalTo(self).offset(-12)
        }
        commentLabel.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(14)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(sourceLabel.snp_right).offset(4)
            make.bottom.equalTo(self).offset(-12)
        }
        timeLabel.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(14)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(commentLabel.snp_right).offset(4)
            make.bottom.equalTo(self).offset(-12)
        }
    }
    func installCellData(cellData data:NewsContentItem) -> Void {
        titleLabel.text = data.title
        tagLabel.text = data.label
        commentLabel.text = String(format: "%d评论", data.comment_count)
        sourceLabel.text = data.media_name
        timeLabel.text = dateformatter(date: Double(data.behot_time))
        let u = "https://raw.githubusercontent.com/reference/BDToolKit/master/BDToolKit.png"
//        "http://p9-tt.byteimg.com/img/pgc-image/RlYg3rIFIlB2bA~tplv-tt-cs0:300:196.webp"
//        let url =
        if let url = URL(string: u) {
            leftImageView.kf.setImage(with: ImageResource(downloadURL: url), placeholder: nil, options: nil, progressBlock: nil) { (image, error, type, url) in
                if let image = image {
                    self.leftImageView.image = image
                }
            }
        } else {
            print("----")
        }
//        leftImageView.sd_setImage(with: URL(string: u)) {[weak self] (image, error, CacheType, url) in
//            if let img = image {
//                self?.leftImageView.image = img
//            }
//        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dateformatter(date: Double) -> String {

        let date1:Date = Date() // Same you did before with timeNow variable
        let date2: Date = Date(timeIntervalSince1970: date)

        let calender:Calendar = Calendar.current
        let components: DateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date1, to: date2)
        var returnString:String = ""
        if components.second! < 60 {
            returnString = "刚刚"
        }else if components.minute! >= 1{
            returnString = String(describing: components.minute) + "分钟前"
        }else if components.hour! >= 1{
            returnString = String(describing: components.hour) + "小时前"
        }else if components.day! >= 1{
            returnString = String(describing: components.day) + "天前"
        }else if components.month! >= 1{
            returnString = String(describing: components.month)+"月前"
        }else if components.year! >= 1 {
            returnString = String(describing: components.year)+"年前"
        }
        return returnString
    }
    
}


