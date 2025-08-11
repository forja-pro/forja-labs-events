# Guia Completo de UI Tests em Swift/SwiftUI

## O que são UI Tests?

UI Tests (Testes de Interface do Usuário) testam a aplicação **do ponto de vista do usuário final**. Eles simulam toques, swipes, digitação e verificam se a interface responde corretamente.

## Diferenças: Unit Tests vs UI Tests

| Aspecto | Unit Tests | UI Tests |
|---------|------------|----------|
| **O que testa** | Lógica interna | Interface e fluxos |
| **Velocidade** | Muito rápido (ms) | Lento (segundos) |
| **Isolamento** | Componentes isolados | App completa |
| **Mocks** | Usa mocks | App real |
| **Quando executar** | A cada mudança | Antes de releases |

## Estrutura de um UI Test

```swift
final class MyUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
    }
    
    func testSomething() throws {
        // Given - Estado inicial
        let button = app.buttons["my_button"]
        
        // When - Ação do usuário  
        button.tap()
        
        // Then - Verificação
        let result = app.staticTexts["result"]
        XCTAssertTrue(result.exists)
    }
}
```

## Elementos XCUIElement

### 1. Encontrar Elementos

```swift
// Por accessibility identifier (recomendado)
app.buttons["login_button"]
app.staticTexts["welcome_label"]
app.textFields["email_field"]

// Por label/texto
app.buttons["Login"]
app.staticTexts["Welcome!"]

// Por tipo
app.buttons.firstMatch
app.textFields.element(boundBy: 0)

// Por predicado
app.buttons.matching(identifier: "submit").firstMatch
```

### 2. Tipos de Elementos Comuns

```swift
app.buttons["identifier"]           // Botões
app.staticTexts["identifier"]       // Textos/Labels
app.textFields["identifier"]        // Campos de texto
app.secureTextFields["identifier"]  // Campos de senha
app.images["identifier"]            // Imagens
app.scrollViews["identifier"]       // ScrollViews
app.tables["identifier"]            // Tabelas
app.cells["identifier"]             // Células
app.navigationBars["title"]         // Barras de navegação
app.alerts["title"]                 // Alertas
app.activityIndicators.firstMatch   // Loading indicators
```

### 3. Ações de Usuário

```swift
// Tocar
element.tap()
element.doubleTap()
element.press(forDuration: 2.0)

// Swipe/Arrastar
element.swipeUp()
element.swipeDown() 
element.swipeLeft()
element.swipeRight()

// Digitar
textField.tap()
textField.typeText("Hello World")
textField.clearText() // Extension customizada

// Scroll
scrollView.swipeUp()
table.swipeUp()
```

### 4. Verificações (Assertions)

```swift
// Existência
XCTAssertTrue(element.exists)
XCTAssertFalse(element.exists)

// Espera com timeout
XCTAssertTrue(element.waitForExistence(timeout: 5))

// Propriedades
XCTAssertTrue(element.isEnabled)
XCTAssertTrue(element.isSelected)
XCTAssertTrue(element.isHittable)

// Texto/Label
XCTAssertEqual(element.label, "Expected Text")
XCTAssertTrue(element.label.contains("Partial"))

// Valor
XCTAssertEqual(textField.value as? String, "Expected")
```

## Accessibility Identifiers

**Muito importante!** Use identificadores de acessibilidade para localizar elementos:

```swift
// Na SwiftUI View:
Text("Hello")
    .accessibilityIdentifier("welcome_text")
    .accessibilityLabel("Welcome message")

Button("Login") { }
    .accessibilityIdentifier("login_button")
    .accessibilityLabel("Login button")

// No UI Test:
let welcomeText = app.staticTexts["welcome_text"]
let loginButton = app.buttons["login_button"]
```

## Boas Práticas para UI Tests

### 1. Identificadores Consistentes
```swift
// ❌ Ruim - usar texto que pode mudar
app.buttons["Entrar"]

// ✅ Bom - usar identificador estável
app.buttons["login_button"]
```

### 2. Timeouts Apropriados
```swift
// Elementos que carregam rapidamente
XCTAssertTrue(button.waitForExistence(timeout: 2))

// Elementos que fazem rede
XCTAssertTrue(content.waitForExistence(timeout: 10))

// Loading muito demorado
XCTAssertTrue(result.waitForExistence(timeout: 30))
```

### 3. Setup e Teardown
```swift
override func setUpWithError() throws {
    continueAfterFailure = false // Parar no primeiro erro
    app = XCUIApplication()
    app.launchArguments = ["UI_TESTING"] // Flag especial
    app.launch()
}

override func tearDownWithError() throws {
    app.terminate() // Limpar estado
    app = nil
}
```

### 4. Estados da App
```swift
// Configurar estado inicial
app.launchArguments = ["SKIP_ONBOARDING", "MOCK_DATA"]
app.launchEnvironment = ["API_URL": "http://mock.api"]
```

## Padrões Avançados

### 1. Page Object Pattern
```swift
struct LoginPage {
    let app: XCUIApplication
    
    var emailField: XCUIElement {
        app.textFields["email_field"]
    }
    
    var passwordField: XCUIElement {
        app.secureTextFields["password_field"]
    }
    
    var loginButton: XCUIElement {
        app.buttons["login_button"]
    }
    
    func login(email: String, password: String) {
        emailField.tap()
        emailField.typeText(email)
        
        passwordField.tap()
        passwordField.typeText(password)
        
        loginButton.tap()
    }
}
```

### 2. Esperas Customizadas
```swift
func waitForElementToDisappear(_ element: XCUIElement, timeout: TimeInterval = 5) {
    let predicate = NSPredicate(format: "exists == false")
    let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
    wait(for: [expectation], timeout: timeout)
}
```

### 3. Screenshots para Debug
```swift
func testWithScreenshots() throws {
    // Screenshot inicial
    let screenshot1 = app.screenshot()
    let attachment1 = XCTAttachment(screenshot: screenshot1)
    attachment1.name = "Initial State"
    add(attachment1)
    
    // Ação
    button.tap()
    
    // Screenshot após ação
    let screenshot2 = app.screenshot()
    let attachment2 = XCTAttachment(screenshot: screenshot2)
    attachment2.name = "After Button Tap"
    add(attachment2)
}
```

## Cenários Comuns de UI Tests

### 1. Fluxo de Login
```swift
func testLoginFlow() throws {
    app.textFields["email"].tap()
    app.textFields["email"].typeText("user@example.com")
    
    app.secureTextFields["password"].tap()
    app.secureTextFields["password"].typeText("password123")
    
    app.buttons["login_button"].tap()
    
    let welcomeMessage = app.staticTexts["welcome_message"]
    XCTAssertTrue(welcomeMessage.waitForExistence(timeout: 5))
}
```

### 2. Navegação entre Telas
```swift
func testNavigationFlow() throws {
    // Tela inicial
    let listItem = app.cells["article_1"]
    listItem.tap()
    
    // Tela de detalhes
    let detailTitle = app.navigationBars["Article Details"]
    XCTAssertTrue(detailTitle.waitForExistence(timeout: 3))
    
    // Voltar
    app.navigationBars.buttons.firstMatch.tap()
    
    // Verificar se voltou
    XCTAssertTrue(listItem.exists)
}
```

### 3. Formulários
```swift
func testFormSubmission() throws {
    app.textFields["name"].tap()
    app.textFields["name"].typeText("João Silva")
    
    app.textFields["email"].tap()
    app.textFields["email"].typeText("joao@example.com")
    
    // Picker/Dropdown
    app.buttons["category_picker"].tap()
    app.pickerWheels.firstMatch.adjust(toPickerWheelValue: "Technology")
    app.buttons["Done"].tap()
    
    // Submit
    app.buttons["submit_button"].tap()
    
    let successMessage = app.alerts["Success"]
    XCTAssertTrue(successMessage.waitForExistence(timeout: 5))
}
```

### 4. Listas e Scroll
```swift
func testListScrolling() throws {
    let table = app.tables.firstMatch
    
    // Scroll para baixo
    table.swipeUp()
    
    // Procurar item específico
    let targetCell = table.cells["item_10"]
    
    // Scroll até encontrar o item
    while !targetCell.exists {
        table.swipeUp()
    }
    
    XCTAssertTrue(targetCell.exists)
    targetCell.tap()
}
```

## Debugging UI Tests

### 1. Pausar execução para inspecionar
```swift
func testWithDebug() throws {
    let button = app.buttons["my_button"]
    
    // Pausar aqui para inspecionar no simulator
    sleep(10) // ou breakpoint
    
    button.tap()
}
```

### 2. Imprimir hierarquia de elementos
```swift
func testDebugHierarchy() throws {
    print("=== HIERARQUIA DE ELEMENTOS ===")
    print(app.debugDescription)
    
    // Ou elementos específicos
    print("Botões disponíveis:")
    app.buttons.allElementsBoundByIndex.forEach { button in
        print("- \(button.identifier): '\(button.label)'")
    }
}
```

### 3. Verificar se elemento existe
```swift
func testElementExists() throws {
    let button = app.buttons["my_button"]
    
    if button.exists {
        print("✅ Botão encontrado!")
        button.tap()
    } else {
        print("❌ Botão não encontrado!")
        print("Botões disponíveis: \(app.buttons.allElementsBoundByIndex.map { $0.identifier })")
        XCTFail("Botão esperado não foi encontrado")
    }
}
```

## Executando UI Tests

### Via Xcode
- `Cmd + U` - Executa todos os testes
- `Cmd + Ctrl + U` - Executa apenas testes do arquivo atual
- Botão ▶️ ao lado de cada teste - Executa teste específico

### Via linha de comando
```bash
# Todos os UI Tests
xcodebuild test -project YourApp.xcodeproj -scheme YourApp -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:YourAppUITests

# Teste específico
xcodebuild test -project YourApp.xcodeproj -scheme YourApp -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:YourAppUITests/ArticleDetailUITests/testArticleDetailScreenLoads
```

## Quando Usar UI Tests

### ✅ Use UI Tests para:
- Fluxos críticos de negócio (login, compra, cadastro)
- Navegação entre telas principais
- Formulários importantes
- Integrações críticas
- Testes de regressão em features chave

### ❌ Não use UI Tests para:
- Lógica de negócio (use unit tests)
- Validações simples
- Testes que mudam frequentemente
- Performance detalhada
- Cobertura completa (muito lento)

## Resumo Final

UI Tests são **complementares** aos Unit Tests:

1. **Unit Tests (70%)**: Lógica rápida e confiável
2. **Integration Tests (20%)**: Componentes trabalhando juntos  
3. **UI Tests (10%)**: Fluxos críticos do usuário

Com essa base, você pode criar UI Tests robustos que garantem que sua app funciona perfeitamente para os usuários! 🚀
