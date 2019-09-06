import UIKit

class BankWithdrawalViewController: UIViewController { }

protocol P2pTransferViewModelProtocol { }
struct P2pTransferViewModel: P2pTransferViewModelProtocol {
    init(receiver: Person) { }
}
class P2pTransferViewController: UIViewController {
    var viewModel: P2pTransferViewModelProtocol

    init(viewModel: P2pTransferViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: "", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class DepositViewController: UIViewController { }
class PaymentViewController: UIViewController { }

struct Person {
    var name: String
    var age: Int
}

struct Statement {
    var transaction: TransactionType

    enum TransactionType: String, Codable {
        case deposit = "DEPOSIT"
        case payment = "PAYMENT_QR_CODE"
        case p2pTransfer = "P2P_TRANSFER"
        case withdrawal = "WITHDRAWAL"
    }
}

let type = Statement.TransactionType.deposit

protocol StatementNavigation {
    func nextScreen() -> UIViewController
}

struct StatementNavigationWithdrawal: StatementNavigation {
    func nextScreen() -> UIViewController {
        return BankWithdrawalViewController()
    }
}

struct StatementNavigationP2pTransfer: StatementNavigation {
    var receiver: Person

    init(receiver: Person) {
        self.receiver = receiver
    }

    func nextScreen() -> UIViewController {
        let viewModel = P2pTransferViewModel(receiver: receiver)
        return P2pTransferViewController(viewModel: viewModel)
    }
}

struct StatementNavigationDeposit: StatementNavigation {
    func nextScreen() -> UIViewController {
        return DepositViewController()
    }
}

struct StatementNavigationPayment: StatementNavigation {
    func nextScreen() -> UIViewController {
        return PaymentViewController()
    }
}

let person = Person(name: "Felipe", age: 29)

func returnNextReceiptScreenPolymorphism(withType type: Statement.TransactionType) -> UIViewController? {
    let variables = [Statement.TransactionType.withdrawal : StatementNavigationWithdrawal().nextScreen(),
                     .payment : StatementNavigationPayment().nextScreen(),
                     .deposit: StatementNavigationDeposit().nextScreen(),
                     .p2pTransfer: StatementNavigationP2pTransfer(receiver: person).nextScreen()]

	return variables[type]
}

func returnNextReceiptScreen(withType type: Statement.TransactionType) -> UIViewController? {
    switch type {
    case .p2pTransfer:
        let viewModel = P2pTransferViewModel(receiver: person)
        return P2pTransferViewController(viewModel: viewModel)

    case .deposit:
        return DepositViewController()

    case .payment:
        return PaymentViewController()

    case .withdrawal:
        return BankWithdrawalViewController()

    @unknown default:
        return nil
    }
}

