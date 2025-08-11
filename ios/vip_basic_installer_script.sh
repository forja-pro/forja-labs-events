#!/bin/bash

# VIP Basic Architecture Template Installer
echo "🔧 Installing VIP Basic Architecture Template# MARK: - Factory Method for Creation

extension ___VARIABLE_sceneName___View {
    static func create() -> ___VARIABLE_sceneName___View {
        let interactor = ___VARIABLE_sceneName___Interactor()
        let viewModel = ___VARIABLE_sceneName___ViewModel(interactor: interactor)
        
        interactor.viewModel = viewModel
        
        return ___VARIABLE_sceneName___View(viewModel: viewModel)
    }
}ode..."

# Remove old template if exists
TEMPLATE_DIR="$HOME/Library/Developer/Xcode/Templates/Custom/VIP Basic Scene.xctemplate"
if [ -d "$TEMPLATE_DIR" ]; then
    echo "🗑️  Removing old basic template..."
    rm -rf "$TEMPLATE_DIR"
fi

# Create fresh template directory
mkdir -p "$TEMPLATE_DIR"
echo "📁 Created template directory: $TEMPLATE_DIR"

# Create TemplateInfo.plist for Basic VIP
cat > "$TEMPLATE_DIR/TemplateInfo.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Kind</key>
	<string>Xcode.IDEFoundation.TextSubstitutionFileTemplateKind</string>
	<key>Description</key>
	<string>Creates a basic VIP architecture scene with core components only</string>
	<key>Summary</key>
	<string>VIP Basic Scene with View, ViewModel, Interactor, and Models (minimal core)</string>
	<key>SortOrder</key>
	<string>2</string>
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
			<string>The name of your scene (e.g., Settings)</string>
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
	<string>VIP Basic Architecture</string>
</dict>
</plist>
EOF

# Create all template files
echo "📝 Creating basic template files..."

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
                        
                        Text(viewModel.message.isEmpty ? "Welcome to ___VARIABLE_sceneName___" : viewModel.message)
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
        let interactor = ___VARIABLE_sceneName___Interactor()
        let viewModel = ___VARIABLE_sceneName___ViewModel(interactor: interactor)
        
        interactor.viewModel = viewModel
        
        return ___VARIABLE_sceneName___View(viewModel: viewModel)
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
    @Published var message: String = ""
    @Published var isLoading: Bool = false
    
    private let interactor: ___VARIABLE_sceneName___BusinessLogic
    
    init(interactor: ___VARIABLE_sceneName___BusinessLogic) {
        self.interactor = interactor
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

# 3. Interactor (Basic - No Worker, Direct ViewModel Updates)
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
    var viewModel: ___VARIABLE_sceneName___ViewModel?
    
    // MARK: - Data Store
    var data: ___VARIABLE_sceneName___Entity?
    
    // MARK: - Business Logic
    
    func loadData(request: ___VARIABLE_sceneName___.LoadData.Request) async {
        viewModel?.isLoading = true
        
        // Simulate some processing time
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Create sample data (no external dependencies)
        let entity = ___VARIABLE_sceneName___Entity(
            id: 1,
            title: "___VARIABLE_sceneName___ Title",
            message: "This is a basic VIP implementation"
        )
        
        self.data = entity
        
        // Direct update to ViewModel
        viewModel?.title = entity.title
        viewModel?.message = entity.message
        viewModel?.isLoading = false
    }
}
EOF

# 4. Models (Basic)
cat > "$TEMPLATE_DIR/___VARIABLE_sceneName___Models.swift" << 'EOF'
//___FILEHEADER___

import Foundation

enum ___VARIABLE_sceneName___ {
    enum LoadData {
        struct Request {
            // Add request parameters as needed
        }
    }
}

struct ___VARIABLE_sceneName___Entity: Identifiable, Codable {
    let id: Int
    let title: String
    let message: String
}
EOF

echo ""
echo "✅ VIP Basic template installed successfully!"
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
echo "   3. Select 'VIP Basic Scene'"
echo "   4. Enter scene name: 'Settings'"
echo ""
echo "🎉 VIP Basic Template ready to go!"
echo ""
echo "💡 Key differences from VIP Full Scene:"
echo "   • No Worker layer (no external dependencies)"
echo "   • No Presenter layer (direct ViewModel updates)"
echo "   • No Router layer (simple factory pattern)"
echo "   • Minimal VIP core: View + ViewModel + Interactor + Models"
echo "   • Perfect for simple screens, settings, forms"
