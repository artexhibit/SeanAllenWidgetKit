import SwiftUI

struct ContentView: View {
    @State private var newRepo = ""
    @State private var repos: [String] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Ex. igorvolkov/Kursvalut", text: $newRepo)
                        .textInputAutocapitalization(.none)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)
                    
                    Button {
                        if !repos.contains(newRepo) && !newRepo.isEmpty {
                            repos.append(newRepo)
                            UserDefaults.shared.set(repos, forKey: UserDefaults.repoKey)
                            newRepo = ""
                        } else {
                            print("😰 repo already exists or name is empty")
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.green)
                    }
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Saved Repos")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.leading)
                    
                    List(repos, id: \.self) { repo in
                        Text(repo)
                            .swipeActions {
                                Button("Delete") {
                                    if repos.count > 1 {
                                        repos.removeAll{ $0 == repo }
                                        UserDefaults.shared.set(repos, forKey: UserDefaults.repoKey)
                                    } else {
                                        print("😰 there should be at least one repo!")
                                    }
                                }
                                .tint(.red)
                            }
                    }
                }
            }
            .navigationTitle("Repo List")
            .onAppear {
                guard let retrievedRepos = UserDefaults.shared.value(forKey: UserDefaults.repoKey) as? [String] else {
                    let defaultValues = ["artexhibit/Kursvalut"]
                    UserDefaults.shared.setValue(defaultValues, forKey: UserDefaults.repoKey)
                    repos = defaultValues
                    return
                }
                repos = retrievedRepos
            }
        }
    }
}

#Preview {
    ContentView()
}
