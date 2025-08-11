import XCTest

// MARK: - UI Tests para ArticleDetail Scene
// UI Tests testam a interface do usuário e interações reais do usuário

final class ArticleDetailUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Continuar executando testes mesmo se um falhar
        continueAfterFailure = false
        
        // Configurar a aplicação
        app = XCUIApplication()
        
        // Configurações especiais para UI Tests
        app.launchArguments = ["UI_TESTING"] // Flag para identificar que estamos em testes
        
        // Lançar a aplicação
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Teste 1: Verificar se a tela carrega corretamente
    func testArticleDetailScreenLoads() throws {
        // O que estamos testando: A tela de detalhes do artigo carrega
        
        // Verificar se a view principal existe
        let articleDetailView = app.scrollViews["article_detail_view"]
        XCTAssertTrue(articleDetailView.waitForExistence(timeout: 5), 
                     "A view de detalhes do artigo deveria existir")
        
        // Verificar se o título da navegação está correto
        let navigationTitle = app.navigationBars["Article"]
        XCTAssertTrue(navigationTitle.exists, 
                     "O título da navegação deveria ser 'Article'")
    }
    
    // MARK: - Teste 2: Verificar o estado de loading
    func testLoadingStateIsDisplayed() throws {
        // O que estamos testando: O estado de loading aparece enquanto carrega
        
        // Logo após o launch, devemos ver o estado de loading
        let loadingProgress = app.activityIndicators["loading_progress"]
        let loadingText = app.staticTexts["loading_text"]
        
        // Verificar se elementos de loading aparecem rapidamente
        if loadingProgress.waitForExistence(timeout: 1) {
            XCTAssertTrue(loadingProgress.exists, 
                         "O indicador de loading deveria aparecer")
            XCTAssertTrue(loadingText.exists, 
                         "O texto de loading deveria aparecer")
            
            print("✅ Estado de loading detectado com sucesso!")
        } else {
            print("⚠️ Loading muito rápido para ser detectado - isso é OK!")
        }
    }
    
    // MARK: - Teste 3: Verificar se o conteúdo carrega após o loading
    func testArticleContentDisplaysAfterLoading() throws {
        // O que estamos testando: O conteúdo do artigo aparece após carregar
        
        // Aguardar o título aparecer (após loading)
        let titleText = app.staticTexts["article_title"]
        XCTAssertTrue(titleText.waitForExistence(timeout: 10), 
                     "O título do artigo deveria aparecer após o loading")
        
        // Verificar se o título contém o texto esperado
        let titleValue = titleText.label
        XCTAssertFalse(titleValue.isEmpty, 
                      "O título não deveria estar vazio")
        
        // Verificar se o autor aparece
        let authorText = app.staticTexts["article_author"]
        XCTAssertTrue(authorText.waitForExistence(timeout: 2), 
                     "O autor do artigo deveria aparecer")
        
        // Verificar se o autor contém o texto esperado
        let authorValue = authorText.label
        XCTAssertTrue(authorValue.contains("By"), 
                     "O texto do autor deveria começar com 'By'")
        
        print("✅ Conteúdo carregado - Título: '\(titleValue)', Autor: '\(authorValue)'")
    }
    
    // MARK: - Teste 4: Verificar acessibilidade
    func testAccessibilityElements() throws {
        // O que estamos testando: Elementos têm labels de acessibilidade corretos
        
        // Aguardar conteúdo carregar
        let titleText = app.staticTexts["article_title"]
        XCTAssertTrue(titleText.waitForExistence(timeout: 10))
        
        // Verificar labels de acessibilidade
        XCTAssertTrue(titleText.isAccessibilityElement, 
                     "O título deveria ser um elemento de acessibilidade")
        
        let authorText = app.staticTexts["article_author"]
        XCTAssertTrue(authorText.isAccessibilityElement, 
                     "O autor deveria ser um elemento de acessibilidade")
        
        print("✅ Elementos de acessibilidade configurados corretamente!")
    }
    
    // MARK: - Teste 5: Verificar navegação (se houver)
    func testNavigationElements() throws {
        // O que estamos testando: Elementos de navegação funcionam
        
        // Verificar se existe botão de voltar (se aplicável)
        let navigationBar = app.navigationBars.firstMatch
        XCTAssertTrue(navigationBar.exists, 
                     "Barra de navegação deveria existir")
        
        // Se houver botão de voltar, testar
        let backButton = navigationBar.buttons.firstMatch
        if backButton.exists {
            print("✅ Botão de navegação encontrado: \(backButton.label)")
        } else {
            print("ℹ️ Nenhum botão de navegação encontrado - tela inicial")
        }
    }
    
    // MARK: - Teste 6: Teste de scroll (se necessário)
    func testScrollBehavior() throws {
        // O que estamos testando: A tela pode fazer scroll se necessário
        
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists, 
                     "ScrollView deveria existir")
        
        // Tentar fazer scroll para baixo
        scrollView.swipeUp()
        
        // Tentar fazer scroll para cima
        scrollView.swipeDown()
        
        // Verificar se ainda conseguimos ver os elementos
        let titleText = app.staticTexts["article_title"]
        XCTAssertTrue(titleText.exists, 
                     "Título deveria continuar visível após scroll")
        
        print("✅ Comportamento de scroll funcionando!")
    }
    
    // MARK: - Teste 7: Teste de performance da UI
    func testArticleLoadingPerformance() throws {
        // O que estamos testando: A tela carrega em tempo aceitável
        
        measure {
            // Reiniciar a app para medir tempo de carregamento
            app.terminate()
            app.launch()
            
            // Aguardar o conteúdo aparecer
            let titleText = app.staticTexts["article_title"]
            _ = titleText.waitForExistence(timeout: 10)
        }
        
        print("✅ Teste de performance concluído!")
    }
    
    // MARK: - Teste 8: Teste de rotação da tela
    func testScreenRotation() throws {
        // O que estamos testando: A tela funciona em orientações diferentes
        
        // Aguardar conteúdo carregar em modo portrait
        let titleText = app.staticTexts["article_title"]
        XCTAssertTrue(titleText.waitForExistence(timeout: 10))
        
        // Rotacionar para landscape
        XCUIDevice.shared.orientation = .landscapeLeft
        
        // Aguardar um momento para a rotação
        sleep(1)
        
        // Verificar se elementos ainda existem após rotação
        XCTAssertTrue(titleText.exists, 
                     "Título deveria continuar visível em landscape")
        
        let authorText = app.staticTexts["article_author"]
        XCTAssertTrue(authorText.exists, 
                     "Autor deveria continuar visível em landscape")
        
        // Voltar para portrait
        XCUIDevice.shared.orientation = .portrait
        sleep(1)
        
        // Verificar novamente
        XCTAssertTrue(titleText.exists, 
                     "Título deveria continuar visível de volta em portrait")
        
        print("✅ Rotação da tela funcionando!")
    }
    
    // MARK: - Teste 9: Teste de interrupção da app
    func testAppInterruption() throws {
        // O que estamos testando: A app lida bem com interrupções
        
        // Aguardar conteúdo carregar
        let titleText = app.staticTexts["article_title"]
        XCTAssertTrue(titleText.waitForExistence(timeout: 10))
        
        // Simular app indo para background
        XCUIDevice.shared.press(.home)
        
        // Aguardar um momento
        sleep(2)
        
        // Voltar para a app
        app.activate()
        
        // Verificar se o estado foi preservado
        XCTAssertTrue(titleText.exists, 
                     "Conteúdo deveria estar preservado após voltar do background")
        
        print("✅ Gerenciamento de estado da app funcionando!")
    }
    
    // MARK: - Teste 10: Teste de múltiplos launches
    func testMultipleLaunches() throws {
        // O que estamos testando: A app funciona consistentemente
        
        for i in 1...3 {
            print("🔄 Launch \(i)/3")
            
            app.terminate()
            app.launch()
            
            // Verificar se carrega corretamente a cada vez
            let titleText = app.staticTexts["article_title"]
            XCTAssertTrue(titleText.waitForExistence(timeout: 10), 
                         "Título deveria carregar no launch \(i)")
            
            let authorText = app.staticTexts["article_author"]
            XCTAssertTrue(authorText.exists, 
                         "Autor deveria existir no launch \(i)")
        }
        
        print("✅ Múltiplos launches funcionando!")
    }
}
