//
//  ContentView.swift
//  Viper
//
//  Created by 名前なし on 2022/04/24.
//

import SwiftUI
import Combine

/**
 {
     "users": {
         "users": [
                 {
                     "id": 1,
                     "name": "arai",
                     "age": 43
                 },
                 {
                     "id": 2,
                     "name": "arai",
                     "age": 43
                 }
         ]
     }
 }
 ~  
 */
struct Users: Mockable, Hashable {
    var users: [User]
}

struct User: Mockable, Hashable {
    var id: Int
    var name: String
    var age: Int
}

protocol UserProtocol {
    func getUser()
}
struct UserInteractor: UserProtocol {
    func getUser() {
        
    }
}

struct UserDetailView: View {
    
    let user: User
    
    var body: some View {
        VStack {
            Text(user.name)
            Text("\(user.age)歳")
        }
    }
}

struct ContentViewRouter {
    func navigationLink(user: User) -> some View {
        return NavigationLink(destination: UserDetailView(user: user)) {
            UserRow(user: user)
        }
    }
}

class ContentViewPresenter: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var users: [User] = []
    
    let router = ContentViewRouter()
    
    func addUser() {
        UsersAPI.addUser()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { response in
                self.users =  response.users
            })
            .store(in: &cancellables)
    }
    
    public func load() {
        UsersAPI.fetch()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { response in
                self.users =  response.users
            })
            .store(in: &cancellables)
    }
}


struct UserRow: View {
    
    let user: User
    
    var body: some View {
        Text(user.name)
    }
}

struct ContentView: View {
    
    @StateObject var presenter: ContentViewPresenter
    @State private var disposables = [AnyCancellable]()
    
    init(presenter: ContentViewPresenter = ContentViewPresenter()) {
        _presenter = StateObject(wrappedValue: presenter)
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 0) {
                
                List(presenter.users, id: \.self) { user in
                    presenter.router.navigationLink(user: user)
                }
                Text("追加")
                    .onTapGesture {
                        presenter.addUser()
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .onAppear {
                presenter.load()
            }
        }
        .background(Color.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
