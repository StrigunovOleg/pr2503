import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var createPassButton: UIButton!
    
    private var pass = ""
    
    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
            } else {
                self.view.backgroundColor = .white
            }
        }
    }
    
    @IBAction func onBut(_ sender: Any) {
        isBlack.toggle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPassButton.setTitle("CREATE", for: .normal)
        createPassButton.tintColor = .black
        createPassButton.addTarget(self, action: #selector(startCreatePass), for: .touchUpInside)
        
        textField.isSecureTextEntry = false
        textField.textColor = .blue
        textField.text = pass
        
        indicator.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    func bruteForce(passwordToUnlock: String) {
        let queue = DispatchQueue.global(qos: .default)
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }
        
        var password: String = ""
        
        queue.async {
            // Will strangely ends at 0000 instead of ~~~
            while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
                password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
                // Your stuff here
                print(password)
                DispatchQueue.main.async { [self] in
                    self.resultLabel.text = password
                    if password == self.pass {
                        indicator.isHidden = true
                        textField.isSecureTextEntry = true
                    }
                }
                // Your stuff here
            }
            
        }

        print(password)
        self.resultLabel.text = password
    }
    
    @objc func startCreatePass() {
        pass = generatePassword(length: 3)
        indicator.isHidden = false
        indicator.startAnimating()
        textField.text = pass
        bruteForce(passwordToUnlock: pass)
    }
    
    func generatePassword(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var password = ""
        for _ in 0..<length {
            password.append(characters.randomElement()!)
        }
        return password
    }
}



extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }



    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
}

func indexOf(character: Character, _ array: [String]) -> Int {
    return array.firstIndex(of: String(character))!
}

func characterAt(index: Int, _ array: [String]) -> Character {
    return index < array.count ? Character(array[index])
                               : Character("")
}

func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
    var str: String = string

    if str.count <= 0 {
        str.append(characterAt(index: 0, array))
    }
    else {
        str.replace(at: str.count - 1,
                    with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

        if indexOf(character: str.last!, array) == 0 {
            str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
        }
    }

    return str
}



