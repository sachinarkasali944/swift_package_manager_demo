import SwiftUI
import MyLibrary   // From the newly added MyLibrary!

struct ContentView: View {
    @State private var name: String = "Swift Developer"
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastStyle: StatusToastStyle = .success
    @State private var isLoading = false
    
    // Instantiate our SPM package formatter
    
    var body: some View {
        ZStack {
            // Elegant background gradient with colors that make Glassmorphism pop
            LinearGradient(
                colors: [.purple, .indigo, .blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 6) {
                    Image(systemName: "square.stack.3d.up.fill")
                        .font(.system(size: 54))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 5)
                    
                    Text("Multi-Package Demo")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("UtilityKit & MyLibrary Integration")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.top, 20)
                
                // 1. GlassCard Container from MyLibrary
                GlassCard {
                    VStack(spacing: 20) {
                        
                        // Input field inside the glass card
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name Input")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white.opacity(0.6))
                            
                            TextField("Enter Name", text: $name)
                                .textFieldStyle(.plain)
                                .padding(12)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .font(.system(.body, design: .rounded))
                        }
                        
                        // Toggle loading state to showcase Shimmering from MyLibrary
                        HStack {
                            Text("Simulated Loader")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                            Spacer()
                            Button(isLoading ? "Stop" : "Shimmer") {
                                withAnimation {
                                    isLoading.toggle()
                                }
                            }
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(8)
                        }
                        
                        if isLoading {
                            // ShimmerPlaceholder from MyLibrary
                            VStack(alignment: .leading, spacing: 8) {
                                ShimmerPlaceholder(height: 14, cornerRadius: 4)
                                ShimmerPlaceholder(width: 150, height: 10, cornerRadius: 4)
                            }
                        } else {
                            Text("Content fully loaded.")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                                .transition(.opacity)
                        }
                    }
                }
                .padding(.horizontal)
                
                // 2. PremiumButton & Toast triggers from MyLibrary
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        // Custom GradientBadge from UtilityKit
                    }
                    
                    VStack(spacing: 12) {
                        PremiumButton("Success Notification", action: {
                            toastStyle = .success
                            toastMessage = "Operation Successful!"
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                showToast = true
                            }
                        }, gradientColors: [.green, .emerald])
                        
                        PremiumButton("Warning Notification", action: {
                            toastStyle = .warning
                            toastMessage = "Connection slow"
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                showToast = true
                            }
                        }, gradientColors: [.orange, .yellow])
                        
                        PremiumButton("Trigger Error Toast", action: {
                            toastStyle = .error
                            toastMessage = "Upload Failed"
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                showToast = true
                            }
                        }, gradientColors: [.red, .pink])
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
        }
        // 3. StatusToast Modifier from MyLibrary
        .statusToast(
            isPresented: $showToast,
            style: toastStyle,
            message: toastMessage,
            subtitle: "Components communicating seamlessly across modules."
        )
    }
}

extension Color {
    static let emerald = Color(red: 16/255, green: 185/255, blue: 129/255)
}

#Preview {
    ContentView()
}
