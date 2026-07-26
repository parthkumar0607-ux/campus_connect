from fastapi import WebSocket


class ConnectionManager:
    def __init__(self):
        self.active_connections = {}

    async def connect(
        self,
        team_id: int,
        websocket: WebSocket,
    ):
        await websocket.accept()

        if team_id not in self.active_connections:
            self.active_connections[team_id] = []

        self.active_connections[team_id].append(
            websocket,
        )

    def disconnect(
        self,
        team_id: int,
        websocket: WebSocket,
    ):
        if team_id in self.active_connections:
            self.active_connections[
                team_id
            ].remove(websocket)

    async def broadcast(
        self,
        team_id: int,
        message: dict,
    ):
        if team_id not in self.active_connections:
            return

        for connection in self.active_connections[
            team_id
        ]:
            await connection.send_json(
                message,
            )


manager = ConnectionManager()