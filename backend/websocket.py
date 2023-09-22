import asyncio
import websockets
import json

async def websocket_server(websocket, path):
    print("Websocket connection is done")
    while True:
        message = await websocket.recv()
        # Process the received message
        # Perform any desired actions based on the message
        message_object = json.loads(message)
        # Example: Send a response back to the client
        if message_object["type"] == 'message':
            response = { 'message': message_object["message"],
                         'author': message_object["author"],}
        await websocket.send(json.dumps(response))

start_server = websockets.serve(websocket_server, 'localhost', 8765)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()