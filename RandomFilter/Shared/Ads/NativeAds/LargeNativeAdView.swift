import UIKit
import GoogleMobileAds

final class LargeNativeAdView: NativeAdView {

    // MARK: - UI
    private let media = MediaView()
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

    // MARK: - UI
    private func setupUI() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 14
        clipsToBounds = true

        // MEDIA
        media.contentMode = .scaleAspectFill
        media.clipsToBounds = true

        // ICON
        iconImageView.layer.cornerRadius = 8
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFill

        // TEXT
        headlineLabel.font = .boldSystemFont(ofSize: 15)
        headlineLabel.numberOfLines = 2

        bodyLabel.font = .systemFont(ofSize: 13)
        bodyLabel.textColor = .secondaryLabel
        bodyLabel.numberOfLines = 3

        // CTA
        callToActionButton.backgroundColor = .systemBlue
        callToActionButton.setTitleColor(.white, for: .normal)
        callToActionButton.layer.cornerRadius = 10
        callToActionButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)

        addSubview(media)
        addSubview(iconImageView)
        addSubview(headlineLabel)
        addSubview(bodyLabel)
        addSubview(callToActionButton)
    }

    // MARK: - Layout
    private func setupLayout() {
        media.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        callToActionButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // MEDIA
            media.topAnchor.constraint(equalTo: topAnchor),
            media.leadingAnchor.constraint(equalTo: leadingAnchor),
            media.trailingAnchor.constraint(equalTo: trailingAnchor),
            media.heightAnchor.constraint(equalToConstant: 180),

            // ICON
            iconImageView.topAnchor.constraint(equalTo: media.bottomAnchor, constant: 10),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),

            // HEADLINE
            headlineLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            headlineLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            headlineLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            // BODY
            bodyLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 4),
            bodyLabel.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            // CTA
            callToActionButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 10),
            callToActionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            callToActionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            callToActionButton.heightAnchor.constraint(equalToConstant: 36),

            callToActionButton.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10)
        ])
    }

    // MARK: - Bind (CRITICAL)
    private func bindAssets() {
        self.mediaView = media   // ✅ FIX QUAN TRỌNG

        self.headlineView = headlineLabel
        self.bodyView = bodyLabel
        self.callToActionView = callToActionButton
        self.iconView = iconImageView
    }

    // MARK: - Configure
    func configure(with nativeAd: NativeAd) {
        self.nativeAd = nativeAd

        headlineLabel.text = nativeAd.headline
        bodyLabel.text = nativeAd.body
        callToActionButton.setTitle(nativeAd.callToAction, for: .normal)

        iconImageView.image = nativeAd.icon?.image

        media.mediaContent = nativeAd.mediaContent
    }
}

extension LargeNativeAdView: NativeAdConfigurable {}
