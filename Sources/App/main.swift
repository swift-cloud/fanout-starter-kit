import Compute

let router = Router()

router.get("/stream") { req, res in
    guard req.isUpgradeWebsocketRequest() else {
        return try await res.status(400).send("Invalid websocket request")
    }
    try req.upgradeWebsocket(backend: "localhost", behavior: .fanout)
}

router.post("/stream") { req, res in
    guard req.isFanoutRequest() else {
        return try await res.status(400).send("Invalid fanout request")
    }

    let message = try await req.fanoutMessage()

    console.log("message:", message.event.rawValue, message.content)

    console.log("grip-sig:", req.headers[.gripSig] ?? "null")

    if message.event == .open {
        try await res.status(200).send(.open, .subscribe(to: "test"))
    } else {
        try await res.status(200).send(.ack)
    }
}

try await router.listen()
