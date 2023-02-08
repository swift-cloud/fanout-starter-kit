import Compute

let router = Router()

router.get("/stream") { req, res in
    guard req.isUpgradeWebsocketRequest() else {
        return try await res.status(400).send("Invalid websocket request")
    }
    try req.upgradeWebsocket(to: .fanout)
}

router.post("/stream") { req, res in
    let message = try await req.fanoutMessage()

    console.log("event:", message.event.rawValue, "content:", message.content)

    console.log("grip-sig:", req.headers[.gripSig] ?? "null")

    if message.event == .open {
        return try await res.meta("user", UUID().uuidString).send(fanout: .open, .subscribe(to: "test"))
    }

    console.log("meta-user:", req.meta("user") ?? "(null)")

    try await res.send(fanout: .ack)
}

router.post("/message") { req, res in
    let token = try ConfigStore(name: "env")["fanout_token"]!
    let client = FanoutClient(token: token)
    let content = try await req.body.text()
    let data = try await client.publish(content, to: "test")
    try await res.proxy(data)
}

try await router.listen()
