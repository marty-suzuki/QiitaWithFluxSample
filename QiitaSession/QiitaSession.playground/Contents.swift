/*:
 > # IMPORTANT: To use **QiitaSession.playground**:
 1. Open **QiitaWithFluxSample.xcodeproj**.
 1. Build the **QiitaSession** scheme (**Product** → **Build**).
 1. Open **QiitaSession** playground in the **Project navigator**.
 1. Show the Debug Area (**View** → **Debug Area** → **Show Debug Area**).
 ---
 */
import PlaygroundSupport
import QiitaSession

PlaygroundPage.current.needsIndefiniteExecution = true

QiitaRequestConfig.baseUrl = "https://qiita.com/api"
let request = ItemsRequest(page: 1, perPage: 3, query: "marty-suzuki")
_ = QiitaSession.shared.send(request)
    .subscribe(
        onNext: { response in
            print(response.elements)
            PlaygroundPage.current.finishExecution()
        },
        onError: { error in
            print(error)
            PlaygroundPage.current.finishExecution()
        }
    )
