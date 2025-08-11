import XCTest

// MARK: - Extensions úteis para UI Tests

extension XCUIElement {
    
    /// Limpa o texto de um campo e digita novo texto
    func clearAndType(_ text: String) {
        tap()
        
        // Selecionar todo o texto
        press(forDuration: 1.0)
        
        // Verificar se apareceu menu de contexto
        if app.menuItems["Select All"].exists {
            app.menuItems["Select All"].tap()
        }
        
        // Digitar novo texto (substitui o selecionado)
        typeText(text)
    }
    
    /// Verifica se elemento existe e está visível
    var isVisible: Bool {
        return exists && isHittable
    }
    
    /// Scroll até o elemento ficar visível
    func scrollToElement(in scrollView: XCUIElement) {
        while !isVisible && scrollView.exists {
            scrollView.swipeUp()
        }
    }
    
    /// Toca no elemento com retry se falhar
    func tapWithRetry(timeout: Double = 5.0) {
        let startTime = Date()
        
        while Date().timeIntervalSince(startTime) < timeout {
            if exists && isHittable {
                tap()
                return
            }
            Thread.sleep(forTimeInterval: 0.1)
        }
        
        XCTFail("Não foi possível tocar no elemento após \(timeout) segundos")
    }
    
    /// Aguarda elemento aparecer com mensagem customizada
    func waitForExistence(timeout: TimeInterval, description: String) -> Bool {
        let result = waitForExistence(timeout: timeout)
        if !result {
            XCTFail("Elemento '\(description)' não apareceu em \(timeout) segundos")
        }
        return result
    }
    
    /// Aguarda elemento desaparecer
    func waitForDisappearance(timeout: TimeInterval = 5.0) {
        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        let waiter = XCTWaiter()
        let result = waiter.wait(for: [expectation], timeout: timeout)
        
        if result != .completed {
            XCTFail("Elemento não desapareceu em \(timeout) segundos")
        }
    }
}

extension XCUIApplication {
    
    /// Aguarda a aplicação carregar completamente
    func waitForLaunch(timeout: TimeInterval = 10.0) {
        let launchExpectation = expectation(description: "App should launch")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if self.state == .runningForeground {
                launchExpectation.fulfill()
            }
        }
        
        wait(for: [launchExpectation], timeout: timeout)
    }
    
    /// Tira screenshot com nome personalizado
    func takeScreenshot(named name: String, attachToTest: XCTestCase? = nil) {
        let screenshot = self.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        
        if let testCase = attachToTest {
            testCase.add(attachment)
        }
    }
    
    /// Força orientação da tela
    func forceOrientation(_ orientation: UIDeviceOrientation) {
        XCUIDevice.shared.orientation = orientation
        Thread.sleep(forTimeInterval: 1.0) // Aguardar rotação
    }
}

// MARK: - Page Object Base Class

class BasePage {
    let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    /// Verifica se a página está carregada
    func isLoaded() -> Bool {
        fatalError("Subclasses devem implementar isLoaded()")
    }
    
    /// Aguarda a página carregar
    @discardableResult
    func waitForLoad(timeout: TimeInterval = 10) -> Bool {
        let startTime = Date()
        
        while Date().timeIntervalSince(startTime) < timeout {
            if isLoaded() {
                return true
            }
            Thread.sleep(forTimeInterval: 0.1)
        }
        
        XCTFail("Página não carregou em \(timeout) segundos")
        return false
    }
    
    /// Tira screenshot da página
    func takeScreenshot(named name: String? = nil) {
        let screenshotName = name ?? String(describing: type(of: self))
        app.takeScreenshot(named: screenshotName)
    }
}

// MARK: - Exemplo de Page Object para ArticleDetail

class ArticleDetailPage: BasePage {
    
    // MARK: - Elements
    
    var titleLabel: XCUIElement {
        app.staticTexts["article_title"]
    }
    
    var authorLabel: XCUIElement {
        app.staticTexts["article_author"]
    }
    
    var loadingIndicator: XCUIElement {
        app.activityIndicators["loading_progress"]
    }
    
    var loadingText: XCUIElement {
        app.staticTexts["loading_text"]
    }
    
    var navigationBar: XCUIElement {
        app.navigationBars["Article"]
    }
    
    var scrollView: XCUIElement {
        app.scrollViews["article_detail_view"]
    }
    
    // MARK: - States
    
    override func isLoaded() -> Bool {
        return navigationBar.exists && (titleLabel.exists || loadingIndicator.exists)
    }
    
    var isShowingLoadingState: Bool {
        return loadingIndicator.exists && loadingText.exists
    }
    
    var isShowingContent: Bool {
        return titleLabel.exists && authorLabel.exists && !loadingIndicator.exists
    }
    
    // MARK: - Actions
    
    func waitForContentToLoad(timeout: TimeInterval = 10) {
        titleLabel.waitForExistence(timeout: timeout, description: "Article title")
        authorLabel.waitForExistence(timeout: timeout, description: "Article author")
    }
    
    func scrollDown() {
        scrollView.swipeUp()
    }
    
    func scrollUp() {
        scrollView.swipeDown()
    }
    
    func tapBackButton() {
        let backButton = navigationBar.buttons.firstMatch
        if backButton.exists {
            backButton.tap()
        }
    }
    
    // MARK: - Assertions
    
    func verifyContent(expectedTitle: String? = nil, expectedAuthor: String? = nil) {
        XCTAssertTrue(titleLabel.exists, "Title should exist")
        XCTAssertTrue(authorLabel.exists, "Author should exist")
        
        if let expectedTitle = expectedTitle {
            XCTAssertTrue(titleLabel.label.contains(expectedTitle), 
                         "Title should contain '\(expectedTitle)'")
        }
        
        if let expectedAuthor = expectedAuthor {
            XCTAssertTrue(authorLabel.label.contains(expectedAuthor), 
                         "Author should contain '\(expectedAuthor)'")
        }
    }
    
    func verifyLoadingState() {
        XCTAssertTrue(loadingIndicator.exists, "Loading indicator should be visible")
        XCTAssertTrue(loadingText.exists, "Loading text should be visible")
    }
    
    func verifyNavigationBar() {
        XCTAssertTrue(navigationBar.exists, "Navigation bar should exist")
        XCTAssertEqual(navigationBar.identifier, "Article", "Navigation title should be 'Article'")
    }
}

// MARK: - Test Utilities

class UITestUtilities {
    
    /// Configurações comuns para todos os UI Tests
    static func setupApp() -> XCUIApplication {
        let app = XCUIApplication()
        
        // Configurações para testes
        app.launchArguments = [
            "UI_TESTING",           // Flag para identificar testes
            "DISABLE_ANIMATIONS",   // Acelerar testes
            "RESET_STATE"           // Estado limpo
        ]
        
        app.launchEnvironment = [
            "MOCK_NETWORK": "true",     // Usar dados mockados
            "API_DELAY": "0.5"          // Delay reduzido para testes
        ]
        
        return app
    }
    
    /// Aguarda loading desaparecer
    static func waitForLoadingToFinish(in app: XCUIApplication, timeout: TimeInterval = 10) {
        let loadingIndicators = app.activityIndicators
        
        for indicator in loadingIndicators.allElementsBoundByIndex {
            indicator.waitForDisappearance(timeout: timeout)
        }
    }
    
    /// Limpa todos os campos de texto na tela
    static func clearAllTextFields(in app: XCUIApplication) {
        let textFields = app.textFields.allElementsBoundByIndex
        let secureFields = app.secureTextFields.allElementsBoundByIndex
        
        (textFields + secureFields).forEach { field in
            if field.exists {
                field.clearAndType("")
            }
        }
    }
    
    /// Debug: lista todos os elementos na tela
    static func debugElements(in app: XCUIApplication, type: String = "all") {
        print("\n=== DEBUG: \(type.uppercased()) ELEMENTS ===")
        
        switch type {
        case "buttons":
            app.buttons.allElementsBoundByIndex.enumerated().forEach { index, button in
                print("\(index): [\(button.identifier)] '\(button.label)'")
            }
        case "texts":
            app.staticTexts.allElementsBoundByIndex.enumerated().forEach { index, text in
                print("\(index): [\(text.identifier)] '\(text.label)'")
            }
        case "textfields":
            app.textFields.allElementsBoundByIndex.enumerated().forEach { index, field in
                print("\(index): [\(field.identifier)] '\(field.placeholderValue ?? field.value as? String ?? "")'")
            }
        default:
            print(app.debugDescription)
        }
        print("=== END DEBUG ===\n")
    }
}

// MARK: - Custom Expectations

extension XCTestCase {
    
    /// Expectativa customizada para aguardar condição
    func waitFor(_ condition: @escaping () -> Bool, 
                 timeout: TimeInterval = 5.0, 
                 description: String = "Condition to be met") {
        
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate { _, _ in condition() }, 
            object: nil
        )
        
        expectation.expectation.description = description
        wait(for: [expectation.expectation], timeout: timeout)
    }
    
    /// Aguarda múltiplas condições
    func waitForAll(_ conditions: [() -> Bool], 
                    timeout: TimeInterval = 5.0, 
                    description: String = "All conditions to be met") {
        
        waitFor({ conditions.allSatisfy { $0() } }, 
                timeout: timeout, 
                description: description)
    }
}
