import Compute

let router = Router()

router.use { req, _ in
    console.log(req.method, req.url.path)
}

router.get("/stream") { req, res in
    guard req.isUpgradeWebsocketRequest() else {
        console.log("Invalid websocket request")
        return try await res.status(400).send("Invalid websocket request")
    }
    console.log("upgrading websocket...")
    try req.upgradeWebsocket(backend: "localhost", behavior: .fanout)
}

router.post("/stream") { req, res in
    guard req.isFanoutRequest() else {
        console.log("Invalid fanout request")
        return try await res.status(400).send("Invalid fanout request")
    }

    let body = try await req.body.text()

    console.log("body:", body)

    console.log("grip-sig:", req.headers[.gripSig] ?? "null")

    if body.starts(with: "OPEN") {
        try await res.status(200).send(.open, .subscribe(to: "test"))
    } else {
        try await res.status(200).send(.ack)
    }
}

try await router.listen()
