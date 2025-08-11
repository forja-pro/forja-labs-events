#!/bin/bash

# Fixed VIP Architecture Template Installer
echo "🔧 Installing Fixed VIP Architecture Template for Xcode..."

# Remove old template if exists
TEMPLATE_DIR="$HOME/Library/Developer/Xcode/Templates/Custom/VIP Scene.xctemplate"
if [ -d "$TEMPLATE_DIR" ]; then
    echo "🗑️  Removing old template..."
    rm -rf "$TEMPLATE_DIR"
fi

# Create fresh template directory
mkdir -p "$TEMPLATE_DIR"
echo "📁 Created template directory: $TEMPLATE_DIR"

# Create FIXED TemplateInfo.plist
cat > "$TEMPLATE_DIR/TemplateInfo.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Kind</key>
	<string>Xcode.IDEFoundation.TextSubstitutionFileTemplateKind</string>
	<key>Description</key>
	<string>Creates a complete VIP architecture scene with all necessary files</string>
	<key>Summary</key>
	<string>VIP Scene with View, ViewModel, Presenter, Interactor, Worker, Router, and Models</string>
	<key>SortOrder</key>
	<string>1</string>
	<key>AllowedTypes</key>
	<array>
		<string>public.swift-source</string>
	</array>
	<key>DefaultCompletionName</key>
	<string>___VARIABLE_sceneName___</string>
	<key>Options</key>
	<array>
		<dict>
			<key>Description</key>
			<string>The name of your scene (e.g., UserProfile)</string>
			<key>Identifier</key>
			<string>sceneName</string>
			<key>Name</key>
			<string>Scene Name:</string>
			<key>NotPersisted</key>
			<true/>
			<key>Required</key>
			<true/>
			<key>Type</key>
			<string>text</string>
		</dict>
	</array>
	<key>Template Author</key>
	<string>VIP Architecture</string>
</dict>
</plist>
EOF

# Create all template files
echo "📝 Creating template files..."

# 1. View
cat > "$TEMPLATE_DIR/___VARIABLE_sceneName___View.swift" << 'EOF'
//___FILEHEADER___

import SwiftUI

struct ___VARIABLE_sceneName___View: View {
    @StateObject private var viewModel: ___VARIABLE_sceneName___ViewModel
    
    init(viewModel: ___VARIABLE_sceneName___ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("___VARIABLE_sceneName___ View")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else {
                    VStack(spacing: 16) {
                        Text(viewModel.title.isEmpty ? "Hello World!" : viewModel.title)
                            .font(.title2)
                        
                        Text(viewModel.subtitle.isEmpty ? "Welcome to ___VARIABLE_sceneName___" : viewModel.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("___VARIABLE_sceneName___")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.loadData()
        }
    }
}

// MARK: - Factory Method for Creation

extension ___VARIABLE_sceneName___View {
    static func create() -> ___VARIABLE_sceneName___View {
        return ___VARIABLE_sceneName___Router.createModule()
    }
}

#Preview {
    ___VARIABLE_sceneName___View.create()
}
EOF

# 2. ViewModel
cat > "$TEMPLATE_DIR/___VARIABLE_sceneName___ViewModel.swift" << 'EOF'
//___FILEHEADER___

import Foundation
import SwiftUI

class ___VARIABLE_sceneName___ViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var subtitle: String = ""
    @Published var isLoading: Bool = false
    
    private let interactor: ___VARIABLE_sceneName___BusinessLogic
    private let router: ___VARIABLE_sceneName___RoutingLogic
    
    init(interactor: ___VARIABLE_sceneName___BusinessLogic, router: ___VARIABLE_sceneName___RoutingLogic) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - User Actions
    func loadData() {
        Task {
            let request = ___VARIABLE_sceneName___.LoadData.Request()
            await interactor.loadData(request: request)
        }
    }
}
EOF

# 3. Presenter
cat > "$TEMPLATE_DIR/___VARIABLE_sceneName___Presenter.swift" << 'EOF'
//___FILEHEADER___

import Foundation

protocol ___VARIABLE_sceneName___PresentationLogic {
    func presentData(response: ___VARIABLE_sceneName___.LoadData.Response)
    func presentLoadingState()
    func presentError(error: Error)
}

class ___VARIABLE_sceneName___Presenter: ___VARIABLE_sceneName___PresentationLogic {
    var viewModel: ___VARIABLE_sceneName___ViewModel?
    
    // MARK: - Presentation Logic
    
    func presentData(response: ___VARIABLE_sceneName___.LoadData.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel?.isLoading = false
            self?.viewModel?.title = response.title
            self?.viewModel?.subtitle = response.subtitle
        }
    }
    
    func presentLoadingState() {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel?.isLoading = true
        }
    }
    
    func presentError(error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel?.isLoading = false
            // Handle error presentation
            print("Error: \(error.localizedDescription)")
        }
    }
}
EOF

# 4. Interactor
cat > "$TEMPLATE_DIR/___VARIABLE_sceneName___Interactor.swift" << 'EOF'
//___FILEHEADER___

import Foundation

protocol ___VARIABLE_sceneName___BusinessLogic {
    func loadData(request: ___VARIABLE_sceneName___.LoadData.Request) async
}

protocol ___VARIABLE_sceneName___DataStore {
    var data: ___VARIABLE_sceneName___Entity? { get set }
}

@MainActor
class ___VARIABLE_sceneName___Interactor: ___VARIABLE_sceneName___BusinessLogic, ___VARIABLE_sceneName___DataStore {
    var presenter: ___VARIABLE_sceneName___PresentationLogic?
    var worker: ___VARIABLE_sceneName___WorkerLogic?
    
    // MARK: - Data Store
    var data: ___VARIABLE_sceneName___Entity?
    
    // MARK: - Business Logic
    
    func loadData(request: ___VARIABLE_sceneName___.LoadData.Request) async {
        presenter?.presentLoadingState()
        
        do {
            guard let worker = worker else {
                return
            }
            
            let entity = try await worker.fetchData()
            self.data = entity
            
            let response = ___VARIABLE_sceneName___.LoadData.Response(
                title: entity.title,
                subtitle: entity.subtitle
            )
            presenter?.presentData(response: response)
            
        } catch {
            presenter?.presentError(error: error)
        }
    }
}
EOF

# 5. Worker
cat > "$TEMPLATE_DIR/___VARIABLE_sceneName___Worker.swift" << 'EOF'
//___FILEHEADER___

import Foundation

protocol ___VARIABLE_sceneName___WorkerLogic {
    func fetchData() async throws -> ___VARIABLE_sceneName___Entity
}

class ___VARIABLE_sceneName___Worker: ___VARIABLE_sceneName___WorkerLogic {
    
    func fetchData() async throws -> ___VARIABLE_sceneName___Entity {
        // Simulate API call delay
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        // Simulate API response
        return ___VARIABLE_sceneName___Entity(
            id: 1,
            title: "Sample ___VARIABLE_sceneName___ Title",
            subtitle: "Sample subtitle"
        )
    }
}
EOF

# 6. Router
cat > "$TEMPLATE_DIR/___VARIABLE_sceneName___Router.swift" << 'EOF'
//___FILEHEADER___

import SwiftUI

protocol ___VARIABLE_sceneName___RoutingLogic {
    func navigateToDetail() -> AnyView?
    func dismiss()
}

protocol ___VARIABLE_sceneName___DataPassing {
    var dataStore: ___VARIABLE_sceneName___DataStore? { get }
}

class ___VARIABLE_sceneName___Router: ___VARIABLE_sceneName___RoutingLogic, ___VARIABLE_sceneName___DataPassing {
    weak var viewController: UIViewController?
    var dataStore: ___VARIABLE_sceneName___DataStore?
    
    // MARK: - Routing Logic
    
    func navigateToDetail() -> AnyView? {
        guard let data = dataStore?.data else { return nil }
        
        // TODO: Navigate to detail view
        return AnyView(
            Text("Detail View for: \(data.title)")
                .padding()
        )
    }
    
    func dismiss() {
        // Handle dismissal
    }
    
    // MARK: - Module Factory
    
    @MainActor
    static func createModule() -> ___VARIABLE_sceneName___View {
        let worker = ___VARIABLE_sceneName___Worker()
        let interactor = ___VARIABLE_sceneName___Interactor()
        let presenter = ___VARIABLE_sceneName___Presenter()
        let router = ___VARIABLE_sceneName___Router()
        
        let viewModel = ___VARIABLE_sceneName___ViewModel(
            interactor: interactor,
            router: router
        )
        
        interactor.worker = worker
        interactor.presenter = presenter
        presenter.viewModel = viewModel
        router.dataStore = interactor
        
        return ___VARIABLE_sceneName___View(viewModel: viewModel)
    }
}
EOF

# 7. Models
cat > "$TEMPLATE_DIR/___VARIABLE_sceneName___Models.swift" << 'EOF'
//___FILEHEADER___

import Foundation

enum ___VARIABLE_sceneName___ {
    enum LoadData {
        struct Request {
            // Add request parameters as needed
        }
        
        struct Response {
            let title: String
            let subtitle: String
        }
    }
}

struct ___VARIABLE_sceneName___Entity: Identifiable, Codable {
    let id: Int
    let title: String
    let subtitle: String
}
EOF

echo ""
echo "✅ Fixed template installed successfully!"
echo "📍 Location: $TEMPLATE_DIR"
echo ""
echo "🔍 Files created:"
ls -1 "$TEMPLATE_DIR" | grep -E "\.swift$|\.plist$"
echo ""
echo "🔄 IMPORTANT: Restart Xcode completely!"
echo ""
echo "📚 To use:"
echo "   1. File → New → File"
echo "   2. Look for 'Custom' section"
echo "   3. Select 'VIP Scene'"
echo "   4. Enter scene name: 'UserProfile'"
echo ""
echo "🎉 VIP Template ready to go!"
