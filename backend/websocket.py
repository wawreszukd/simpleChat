import asyncio
import websockets
import json
import requests

api_url='http://localhost:8000/add-message'
async def websocket_server(websocket, path):
    print("Websocket connection is done")
    while True:
        message = await websocket.recv()
        # Process the received message
        # Perform any desired actions based on the message
        message_object = json.loads(message)
        # Example: Send a response back to the client
        if message_object["type"] == 'message':
            print("Got message type message")
            response = {
                'message': message_object["message"],
                'author': message_object["author"],
            }
            requests.post(api_url, json=response)
            await websocket.send(json.dumps(response))

start_server = websockets.serve(websocket_server, 'localhost', 8765)

# Run the WebSocket server continuously
asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()
