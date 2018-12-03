//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class Throttler {
    
    private var workItem: DispatchWorkItem = DispatchWorkItem(block: {})
    private var previousRun: Date = Date.distantPast
    private let queue: DispatchQueue
    private let minimumDelay: TimeInterval
    
    init(minimumDelay: TimeInterval, queue: DispatchQueue = DispatchQueue.main) {
        self.minimumDelay = minimumDelay
        self.queue = queue
    }
    
    func throttle(_ block: @escaping () -> Void) {
        // Cancel any existing work item if it has not yet executed
        workItem.cancel()
        
        // Re-assign workItem with the new block task, resetting the previousRun time when it executes
        workItem = DispatchWorkItem() {
            [weak self] in
            self?.previousRun = Date()
            block()
        }
        
        // If the time since the previous run is more than the required minimum delay
        // => execute the workItem immediately
        // else
        // => delay the workItem execution by the minimum delay time
        let delay = previousRun.timeIntervalSinceNow > minimumDelay ? 0 : minimumDelay
        queue.asyncAfter(deadline: .now() + Double(delay), execute: workItem)
    }
}

class MyViewController : UIViewController, UITextFieldDelegate {
    let throttler = Throttler(minimumDelay: 0.5)
    var textField: UITextField!
    
    override func loadView() {
        let view = UIView()
        let sampleTextField = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
        sampleTextField.placeholder = "placeholderText"
        sampleTextField.font = UIFont.systemFont(ofSize: 15)
        sampleTextField.borderStyle = UITextField.BorderStyle.roundedRect
        sampleTextField.autocorrectionType = UITextAutocorrectionType.no
        sampleTextField.keyboardType = UIKeyboardType.default
        sampleTextField.returnKeyType = UIReturnKeyType.done
        sampleTextField.clearButtonMode = UITextField.ViewMode.whileEditing;
        sampleTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        sampleTextField.delegate = self
        textField = sampleTextField
        view.addSubview(sampleTextField)
        view.backgroundColor = .white
        self.view = view
    }
    
    func frequentlyCalledMethod() {
        
        //    Throttling our computationally expensive task will ensure
        //    that it is only run once after 0.5 seconds have elapsed since last being requested,
        //    preventing excessive computation in the case that this method is called with high frequency
        
        throttler.throttle {
            self.computationallyExpensiveTask()
        }
    }
    
    func computationallyExpensiveTask() {
        print("\(textField.text)")
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        frequentlyCalledMethod()
        return true
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
PlaygroundPage.current.needsIndefiniteExecution = true
