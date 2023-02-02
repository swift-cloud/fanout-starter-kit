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

    try req.unsafe_verifyFanoutRequest()

    let message = try await req.fanoutMessage()

    console.log("event:", message.event.rawValue, "content:", message.content)

    console.log("grip-sig:", req.headers[.gripSig] ?? "null")

    if message.event == .open {
        return try await res.send(fanout: .open, .subscribe(to: "test"))
    }

    try await res.send(fanout: .ack)
}

try await router.listen()
