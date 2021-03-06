
import UIKit
import OIMUIKit
import RxSwift
import RxCocoa
import SVProgressHUD
import Localize_Swift
import OpenIMSDK

class MainTabViewController: UITabBarController {
    private let _disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var controllers: [UIViewController] = []
        
        let chatNav = UINavigationController.init(rootViewController: ChatListViewController())
        chatNav.tabBarItem.title = "OpenIM"
        chatNav.tabBarItem.image = UIImage.init(named: "tab_home_icon_normal")?.withRenderingMode(.alwaysOriginal)
        chatNav.tabBarItem.selectedImage = UIImage.init(named: "tab_home_icon_selected")?.withRenderingMode(.alwaysOriginal)
        controllers.append(chatNav)
        IMController.shared.totalUnreadSubject.map({ (unread: Int) -> String? in
            var badge: String?
            if unread == 0 {
                badge = nil
            } else if unread > 99 {
                badge = "..."
            } else {
                badge = String(unread)
            }
            return badge
        }).bind(to: chatNav.tabBarItem.rx.badgeValue).disposed(by: _disposeBag)
        
        let contactVC = ContactsViewController()
        contactVC.viewModel.dataSource = self
        let contactNav = UINavigationController.init(rootViewController: contactVC)
        contactNav.tabBarItem.title = "通讯录".localized()
        contactNav.tabBarItem.image = UIImage.init(named: "tab_contact_icon_normal")?.withRenderingMode(.alwaysOriginal)
        contactNav.tabBarItem.selectedImage = UIImage.init(named: "tab_contact_icon_selected")?.withRenderingMode(.alwaysOriginal)
        controllers.append(contactNav)
        IMController.shared.contactUnreadSubject.map({ (unread: Int) -> String? in
            var badge: String?
            if unread == 0 {
                badge = nil
            } else {
                badge = String(unread)
            }
            return badge
        }).bind(to: contactNav.tabBarItem.rx.badgeValue).disposed(by: _disposeBag)
        
        let mineNav = UINavigationController.init(rootViewController: MineViewController())
        mineNav.tabBarItem.title = "我的".localized()
        mineNav.tabBarItem.image = UIImage.init(named: "tab_me_icon_normal")?.withRenderingMode(.alwaysOriginal)
        mineNav.tabBarItem.selectedImage = UIImage.init(named: "tab_me_icon_selected")?.withRenderingMode(.alwaysOriginal)
        controllers.append(mineNav)
        
        self.viewControllers = controllers
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundColor = .white;
        
        self.tabBar.layer.shadowColor = UIColor.black.cgColor;
        self.tabBar.layer.shadowOpacity = 0.08;
        self.tabBar.layer.shadowOffset = CGSize.init(width: 0, height: 0);
        self.tabBar.layer.shadowRadius = 5;

        self.tabBar.backgroundImage = UIImage.init()
        self.tabBar.shadowImage = UIImage.init()
        
        if let uid = UserDefaults.standard.object(forKey: LoginViewModel.IMUidKey) as? String, let token = UserDefaults.standard.object(forKey: LoginViewModel.IMTokenKey) as? String {
            SVProgressHUD.show()
            LoginViewModel.loginIM(uid: uid, token: token) {[weak self] errMsg in
                if errMsg != nil {
                    SVProgressHUD.showError(withStatus: errMsg)
                    self?.presentLoginController()
                } else {
                    SVProgressHUD.dismiss()
                    self?.dismiss(animated: true)
                }
            }
        } else {
            DispatchQueue.main.async {
                self.presentLoginController()
            }
        }
        
        JNNotificationCenter.shared.observeEvent { [weak self] (event: OIMUIKit.EventLogout) in
            LoginViewModel.saveUser(uid: nil, token: nil)
            self?.presentLoginController()
        }.disposed(by: _disposeBag)
    }
    
    private func presentLoginController() {
        let vc = LoginViewController()
        vc.loginBtn.rx.tap.subscribe(onNext: { [weak vc, weak self] in
            guard let controller = vc else { return }
            guard let phone = controller.phone, let pwd = controller.password else { return }
            
            SVProgressHUD.show()
            LoginViewModel.loginDemo(phone: phone, pwd: pwd) {[weak self] errMsg in
                if errMsg != nil {
                    SVProgressHUD.showError(withStatus: errMsg)
                    self?.presentLoginController()
                } else {
                    SVProgressHUD.dismiss()
                    self?.dismiss(animated: true)
                }
            }
        }).disposed(by: _disposeBag)
        
        vc.modalPresentationStyle = .fullScreen
        let nav = UINavigationController.init(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        
        self.present(nav, animated: false)
    }
}

extension MainTabViewController: ContactsDataSource {
    func getFrequentUsers() -> [OIMUserInfo] {
        return []
    }
    
    func setFrequentUsers(_ users: [OIMUserInfo]) {
        
    }
}
