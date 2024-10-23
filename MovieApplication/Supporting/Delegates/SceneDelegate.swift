//
//  SceneDelegate.swift
//  MovieApplication
//
//  Created by João Ângelo on 22/10/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = TabController()
        self.window = window
        self.window?.makeKeyAndVisible()
    }
}

