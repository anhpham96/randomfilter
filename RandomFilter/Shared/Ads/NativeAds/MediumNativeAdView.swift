//
//  MediumNativeAdView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 21/4/26.
//


import UIKit
import GoogleMobileAds


final class MediumNativeAdView: NativeAdView {

    // MARK: - UI
    private let iconImageView = UIImageView()
    private let headlineLabel = UILabel()
    private let bodyLabel = UILabel()
    private let callToActionButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        bindAssets()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupLayout()
        bindAssets()
    }

    private func setupUI() {
        backgroundColor = UIColor.secondarySystemBackground
        layer.cornerRadius = 12
        clipsToBounds = true

        // MARK: - Headline
        headlineLabel.font = .boldSystemFont(ofSize: 14)
        headlineLabel.numberOfLines = 1

        // MARK: - Body
        bodyLabel.font = .systemFont(ofSize: 12)
        bodyLabel.textColor = .secondaryLabel
        bodyLabel.numberOfLines = 2

        // MARK: - CTA
        callToActionButton.backgroundColor = .systemBlue
        callToActionButton.setTitleColor(.white, for: .normal)
        callToActionButton.layer.cornerRadius = 8
        callToActionButton.clipsToBounds = true
        callToActionButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)

        // MARK: - Icon (main visual instead of video)
        iconImageView.layer.cornerRadius = 8
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFill

        addSubview(iconImageView)
        addSubview(headlineLabel)
        addSubview(bodyLabel)
        addSubview(callToActionButton)
    }

    private func setupLayout() {

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        callToActionButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            // MARK: - Icon (main visual)
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            iconImageView.widthAnchor.constraint(equalToConstant: 44),
            iconImageView.heightAnchor.constraint(equalToConstant: 44),

            // MARK: - Headline
            headlineLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            headlineLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            headlineLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            // MARK: - Body
            bodyLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 2),
            bodyLabel.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            // MARK: - CTA
            callToActionButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 8),
            callToActionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            callToActionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            callToActionButton.heightAnchor.constraint(equalToConstant: 30),

            callToActionButton.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10)
        ])
    }

    private func bindAssets() {
        headlineView = headlineLabel
        bodyView = bodyLabel
        callToActionView = callToActionButton
        iconView = iconImageView
    }

    func configure(with nativeAd: NativeAd) {
        self.nativeAd = nativeAd

        headlineLabel.text = nativeAd.headline
        bodyLabel.text = nativeAd.body
        callToActionButton.setTitle(nativeAd.callToAction, for: .normal)

        iconImageView.image = nativeAd.icon?.image
    }
}

extension MediumNativeAdView: NativeAdConfigurable {}
