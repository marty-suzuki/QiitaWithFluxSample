/*:
 > # IMPORTANT: To use **QiitaSession.playground**:
 1. Open **QiitaSession.xcworkspace**.
 1. Build the **QiitaSession** scheme (**Product** → **Build**).
 1. Open **QiitaSession** playground in the **Project navigator**.
 1. Show the Debug Area (**View** → **Debug Area** → **Show Debug Area**).
 ---
 */
import PlaygroundSupport
import QiitaSession
import Result

PlaygroundPage.current.needsIndefiniteExecution = true

let session = QiitaSession(tokenGetter: { nil },
                           baseURL: "https://qiita.com/api")
let request = ItemsRequest(page: 1, perPage: 3, query: "marty-suzuki")
_ = session.send(request) {
    switch $0 {
    case .success(let value):
        print(value.elements)
    case .failure(let anyError):
        print(anyError.error)
    }
    PlaygroundPage.current.finishExecution()
}
