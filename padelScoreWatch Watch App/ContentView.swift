import SwiftUI
import WatchKit

@main
struct TennisScoreApp: App {
    var body: some Scene {
        WindowGroup {
            TennisContentView()
        }
    }
}


struct TennisContentView: View {
    @State private var player1Score = 0
    @State private var player2Score = 0
    @State private var player1Sets = 0
    @State private var player2Sets = 0
    @State private var runtimeSession: WKExtendedRuntimeSession?
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                HStack {
                    VStack {
                        Text("\(player1Sets)")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                            .offset(y: -30) // Move up a little
                    }
                    .gesture(
                            LongPressGesture(minimumDuration: 2.0) // 2 seconds
                                .onEnded { _ in
                                    player1Sets = 0
                                    player2Sets = 0
                                    player1Score = 0
                                    player2Score = 0
                                }
                        )
                    .highPriorityGesture(
                        TapGesture(count: 2)
                            .onEnded {
                                addSet(isP1: true, isSum: false) // Double tap: Decrease
                            }
                    )
                    
                    .onTapGesture {
                        addSet(isP1: true) // Single tap: Increase
                    }
                    

                    Spacer()

                    VStack {
                        Text("\(player2Sets)")
                            .font(.system(size: 60))
                            .foregroundColor(.red)
                            .offset(y: -30) // Move up a little
                        
                    }
                    .highPriorityGesture(
                        TapGesture(count: 4)
                            .onEnded {
                                player1Score = 0
                                player2Score = 0
                            }
                    )
                    .highPriorityGesture(
                        TapGesture(count: 2)
                            .onEnded {
                                addSet(isP1: false, isSum: false) // Double tap: Decrease
                            }
                    )
                    .onTapGesture {
                        addSet(isP1: false) // Single tap: Increase
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Scoring Areas
                HStack(spacing: 0) {
                    // Left Side: Player 1
                    Rectangle()
                        .foregroundColor(.blue.opacity(0.2))
                        .overlay(
                            VStack {
                                showScoreText(score: player1Score)
                                    .font(.system(size: 70))
                                    .offset(y: -30) // Move up a little
                            }
                            .foregroundColor(.blue)
                        )
                        .highPriorityGesture(
                            TapGesture(count: 2)
                                .onEnded {
                                    addPoint(isP1: true, isSum: false)
                                }
                        )
                        .onTapGesture {
                            addPoint(isP1: true, isSum: true)
                        }

                    // Right Side: Player 2
                    Rectangle()
                        .foregroundColor(.red.opacity(0.2))
                        .overlay(
                            VStack {
                                showScoreText(score: player2Score)
                                    .font(.system(size: 70))
                                    .offset(y: -30) // Move up a little
                            }
                            .foregroundColor(.red)
                        )
                        .highPriorityGesture(
                            TapGesture(count: 2)
                                .onEnded {
                                    addPoint(isP1: false, isSum: false)
                                }
                        )
                        .onTapGesture {
                            addPoint(isP1: false, isSum: true)
                        }
                }
                .edgesIgnoringSafeArea(.all)
                
            }
        }
        .onAppear {
                   startExtendedRuntimeSession()
               }
               .onDisappear {
                   endExtendedRuntimeSession()
               }
    }

    func addSet(isP1:Bool = true, isSum:Bool = true){
        if isP1 {
            player1Sets += isSum ? 1 : -1
        } else {
            player2Sets += isSum ? 1 : -1
        }
    }
    func addPoint(isP1:Bool = true, isSum:Bool = true){
        if isP1 {
            player1Score += isSum ? 1 : -1
        } else {
            player2Score += isSum ? 1 : -1
        }
        
        if (player1Score == 4){
            player1Sets += 1
            player1Score = 0
            player2Score = 0
        } else if (player2Score == 4){
            player2Sets += 1
            player1Score = 0
            player2Score = 0
        }
    }
    
    func showScoreText(score: Int) -> some View {
        switch score {
            case 0: Text("0")
            case 1: Text("15")
            case 2: Text("30")
            case 3: Text("40")
        default:
            Text("0")
        }
        
    }

    func resetOpponentScore(opponentScore: Int) {
        if opponentScore != 0 {
            player1Score = 0
            player2Score = 0
        }
    }
    
    private func startExtendedRuntimeSession() {
            runtimeSession = WKExtendedRuntimeSession()
            runtimeSession?.start()
        }

        private func endExtendedRuntimeSession() {
            runtimeSession?.invalidate()
            runtimeSession = nil
        }
}
