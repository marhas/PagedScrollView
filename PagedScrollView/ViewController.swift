//
//  ViewController.swift
//  PagedScrollView
//
//  Created by Marcel Hasselaar on 2017-12-13.
//  Copyright © 2017 Marcel Hasselaar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let portfolioWidthToContainingViewFactor = CGFloat(0.85)
    private let portfolioHeightToContainingViewFactor = CGFloat(0.6)

    fileprivate var scrollView: UIScrollView!
    fileprivate let pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .blue
        pageControl.numberOfPages = 5
        view.addSubview(pageControl)
        pageControl.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pageControl.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 50).isActive = true

        let pannableView = UIView()
        scrollView = EventCatchingScrollView(catchingUIEventsIn: pannableView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        scrollView.isPagingEnabled = true
        scrollView.clipsToBounds = false
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: portfolioWidthToContainingViewFactor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: portfolioHeightToContainingViewFactor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: pageControl.topAnchor).isActive = true
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        pannableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pannableView)
        pannableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pannableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pannableView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        pannableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        pannableView.isUserInteractionEnabled = false

        let portfolioColors: [UIColor] = [.green, .yellow, .blue, .orange, .red]

        var horizontalAnchor: NSLayoutAnchor = scrollView.leftAnchor
        for x in 0..<5 {
            let portfolioSpacingContainerView = UIView()
            portfolioSpacingContainerView.translatesAutoresizingMaskIntoConstraints = false
            portfolioSpacingContainerView.backgroundColor = .white
            let portfolioView = UIView()
            portfolioView.translatesAutoresizingMaskIntoConstraints = false
            portfolioSpacingContainerView.addSubview(portfolioView)
            portfolioView.widthAnchor.constraint(equalTo: portfolioSpacingContainerView.widthAnchor, multiplier: 0.94).isActive = true
            portfolioView.centerXAnchor.constraint(equalTo: portfolioSpacingContainerView.centerXAnchor).isActive = true
            portfolioView.topAnchor.constraint(equalTo: portfolioSpacingContainerView.topAnchor).isActive = true
            portfolioView.bottomAnchor.constraint(equalTo: portfolioSpacingContainerView.bottomAnchor).isActive = true

            let button = UIButton(type: .roundedRect)
            button.translatesAutoresizingMaskIntoConstraints = false
            portfolioView.addSubview(button)
            button.setTitle("I'm a button. Tap me!", for: .normal)
            button.backgroundColor = portfolioColors[5 - x - 1]
            button.bottomAnchor.constraint(equalTo: portfolioView.bottomAnchor, constant: -20).isActive = true
            button.centerXAnchor.constraint(equalTo: portfolioView.centerXAnchor).isActive = true
            button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)

            scrollView.addSubview(portfolioSpacingContainerView)
            portfolioView.backgroundColor = portfolioColors[x]
            portfolioSpacingContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: portfolioWidthToContainingViewFactor).isActive = true
            portfolioSpacingContainerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
            portfolioSpacingContainerView.leftAnchor.constraint(equalTo: horizontalAnchor).isActive = true
            portfolioSpacingContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            portfolioSpacingContainerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
            horizontalAnchor = portfolioSpacingContainerView.rightAnchor
        }
        horizontalAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
    }

    @objc
    func buttonPressed(sender: Any) {
        print("Button pressed: \(sender)")
    }
}

extension ViewController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageSize = scrollView.contentSize.width / CGFloat(pageControl.numberOfPages)
        let currentPage = Int((scrollView.contentOffset.x + pageSize/2) / pageSize)
        pageControl.currentPage = currentPage
    }
}

class EventCatchingScrollView: UIScrollView {

    let referenceView: UIView

    init(catchingUIEventsIn view: UIView) {
        self.referenceView = view
        super.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let translatedPoint = convert(point, to: referenceView)
        return referenceView.point(inside: translatedPoint, with: event)
    }
}
