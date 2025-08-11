# VIP Architecture Templates for iOS

This repository contains two VIP (View-Interactor-Presenter) architecture templates for SwiftUI iOS development. Choose the right template for your use case.

## 📋 Templates Overview

| Template | Components | Use Cases | Complexity |
|----------|------------|-----------|------------|
| **VIP Basic Scene** | View + ViewModel + Interactor + Models | Settings, Forms, Simple Logic | ⭐️ Simple |
| **VIP Full Scene** | View + ViewModel + Interactor + Presenter + Worker + Router + Models | API calls, Complex Data, Navigation | ⭐️⭐️⭐️ Complex |

## 🚀 Installation

### Install Both Templates

```bash
# Install VIP Basic Scene template
chmod +x vip_basic_installer_script.sh
./vip_basic_installer_script.sh

# Install VIP Full Scene template  
chmod +x vip_full_installer_script.sh
./vip_full_installer_script.sh

# ⚠️ Important: Restart Xcode completely after installation
```

### Using the Templates

1. **File → New → File** in Xcode
2. Look for **"Custom"** section
3. Choose your template:
   - **"VIP Basic Scene"** - Minimal core
   - **"VIP Scene"** - Full architecture
4. Enter scene name (e.g., "UserProfile", "Settings")
5. Generate and customize!

## 🎯 When to Use Which Template

### ✅ Use VIP Basic Scene When:

- **Settings screens** - Toggle preferences, user options
- **About pages** - Static content, app information  
- **Simple forms** - Contact forms, feedback
- **Internal calculations** - No external data needed
- **Static content** - Terms of service, help pages
- **User preferences** - Theme selection, notification settings

**Example Use Cases:**
- Settings toggle for dark mode
- About app screen with version info
- Simple contact form
- App tutorial/onboarding content

### ✅ Use VIP Full Scene When:

- **API-heavy screens** - User profiles, data lists
- **Complex data transformation** - Charts, analytics
- **Multi-step flows** - Onboarding, checkout process
- **External services** - Network calls, database operations
- **Navigation logic** - Deep linking, complex routing
- **Data persistence** - Core Data, caching

**Example Use Cases:**
- User profile with API data
- Article list from REST API
- Complex checkout flow
- Photo gallery with cloud sync

## 🏗️ Architecture Comparison

### VIP Basic Scene (4 files)
```
┌─────────────┐
│    View     │ ← SwiftUI UI
└─────┬───────┘
      │
┌─────▼───────┐
│  ViewModel  │ ← @Published properties
└─────┬───────┘
      │
┌─────▼───────┐
│ Interactor  │ ← Business logic + DataStore
└─────┬───────┘
      │
┌─────▼───────┐
│   Models    │ ← Data structures
└─────────────┘
```

### VIP Full Scene (7 files)
```
┌─────────────┐
│    View     │ ← SwiftUI UI
└─────┬───────┘
      │
┌─────▼───────┐
│  ViewModel  │ ← @Published properties
└─────┬───────┘
      │
┌─────▼───────┐    ┌─────────────┐
│ Interactor  │────│   Worker    │ ← External services
└─────┬───────┘    └─────────────┘
      │
┌─────▼───────┐    ┌─────────────┐
│  Presenter  │    │   Router    │ ← Navigation logic
└─────┬───────┘    └─────────────┘
      │
┌─────▼───────┐
│   Models    │ ← Data structures  
└─────────────┘
```

## 📁 Generated Files

### VIP Basic Scene Generates:
- `SceneNameView.swift` - SwiftUI view with basic UI
- `SceneNameViewModel.swift` - Observable object with @Published properties
- `SceneNameInteractor.swift` - Business logic + DataStore protocol
- `SceneNameModels.swift` - Request/Response models and entities

### VIP Full Scene Generates:
- `SceneNameView.swift` - SwiftUI view with comprehensive UI
- `SceneNameViewModel.swift` - Observable object bridging VIP components
- `SceneNameInteractor.swift` - Business logic with Worker integration
- `SceneNamePresenter.swift` - Data formatting and presentation logic
- `SceneNameWorker.swift` - External service handling (API, Database)
- `SceneNameRouter.swift` - Navigation and module factory
- `SceneNameModels.swift` - Complete data model structure

## 🔧 Customization Guide

### Removing Components from Full Scene

If you generated a Full Scene but don't need all components:

#### Remove Worker:
1. Delete `SceneNameWorker.swift`
2. Update Interactor to handle logic directly:
```swift
// Instead of:
let data = try await worker.fetchData()

// Use:
let data = processDataDirectly()
```

#### Remove Presenter:
1. Delete `SceneNamePresenter.swift`
2. Update Interactor to update ViewModel directly:
```swift
// Instead of:
presenter?.presentData(response: response)

// Use:
await MainActor.run {
    viewModel?.title = data.title
}
```

### Adding Components to Basic Scene

If you need to upgrade a Basic Scene:

#### Add Worker:
1. Create `SceneNameWorker.swift`
2. Inject Worker into Interactor
3. Use Worker for external operations

#### Add Presenter:
1. Create `SceneNamePresenter.swift`
2. Add Presenter dependency to Interactor
3. Format data in Presenter before updating ViewModel

## 🎨 Naming Conventions

### Protocol Naming (Semantic approach):
- `BusinessLogic` - For Interactor protocols
- `PresentationLogic` - For Presenter protocols  
- `RoutingLogic` - For Router protocols
- `DataStore` - For state management protocols

### Examples:
```swift
protocol UserProfileBusinessLogic { }
protocol ArticleDetailPresentationLogic { }
protocol SettingsRoutingLogic { }
protocol GameDataStore { }
```

## 🧪 Testing Strategy

### Unit Testing VIP Components:

```swift
// Test Interactor business logic
func testLoadUserProfile() async {
    let interactor = UserProfileInteractor()
    let mockWorker = MockUserProfileWorker()
    interactor.worker = mockWorker
    
    await interactor.loadUserProfile(request: request)
    
    // Assert business logic
}

// Test Presenter formatting
func testPresentUserProfile() {
    let presenter = UserProfilePresenter()
    let mockViewModel = MockUserProfileViewModel()
    presenter.viewModel = mockViewModel
    
    presenter.presentUserProfile(response: response)
    
    // Assert formatted data
}
```

## 🏃‍♂️ Quick Start Examples

### Basic Scene Example (Settings):
```swift
// Generated Settings scene for app preferences
SettingsView.create()
```

### Full Scene Example (User Profile):
```swift  
// Generated UserProfile scene with API integration
UserProfileView.create(userId: 123)
```

## 📚 Architecture Benefits

### ✅ Separation of Concerns
- Each component has a single responsibility
- Easy to test individual components
- Clear data flow patterns

### ✅ Scalability  
- Start with Basic, upgrade to Full when needed
- Consistent patterns across all scenes
- Easy to onboard new team members

### ✅ SwiftUI Integration
- Native SwiftUI patterns with @StateObject
- Proper dependency injection
- Reactive UI updates with @Published

## 🤝 Contributing

When adding new features to templates:

1. **Follow existing patterns** - Use established naming conventions
2. **Test both templates** - Ensure changes work in Basic and Full
3. **Update documentation** - Keep README.md current
4. **Consider use cases** - Will this benefit the target audience?

## 📖 Further Reading

- [Clean Swift/VIP Architecture](https://clean-swift.com)
- [SwiftUI Best Practices](https://developer.apple.com/documentation/swiftui)
- [iOS Architecture Patterns](https://developer.apple.com/documentation/technologies)

---

**Happy coding with VIP architecture! 🚀**

> Choose the right tool for the job - Basic for simplicity, Full for complexity.
