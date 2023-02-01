import Compute

let router = Router()

router.use { req, _ in
    console.log(req.method, req.url.path)
}

router.get("/stream") { req, res in
    guard req.isFanoutRequest() else {
        return try await res.status(400).send("Invalid websocket request")
    }
    try req.upgradeWebsocket(backend: "self", behavior: .fanout)
}

router.post("/stream") { req, res in
    try await res.status(200).send(
        FanoutMessage.open,
        FanoutMessage.subscribe(to: "test")
    )
}

try await router.listen()
