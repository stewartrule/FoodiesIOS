import Foundation

protocol Effects<State, Action> {
    associatedtype State
    associatedtype Action
    func handle(_ state: State, _ action: Action) async -> Action?
}

protocol Reducer<State, Action> {
    associatedtype State
    associatedtype Action
    func handle(_ state: State, _ action: Action) -> State
}

@Observable
@dynamicMemberLookup
public final class Store<State, Action> {
    private var state: State
    private let reducer: any Reducer<State, Action>
    private let effects: any Effects<State, Action>

    init(
        state: State,
        reducer: any Reducer<State, Action>,
        effects: any Effects<State, Action>
    ) {
        self.state = state
        self.reducer = reducer
        self.effects = effects
    }

    subscript<T>(dynamicMember keyPath: KeyPath<State, T>) -> T {
        state[keyPath: keyPath]
    }

    func send(_ action: Action) {
        state = reducer.handle(state, action)

        Task {
            if let nextAction = await effects.handle(state, action) {
                DispatchQueue.main.sync {
                    send(nextAction)
                }
            }
        }
    }
}
