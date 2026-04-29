import requests
from fastapi import FastAPI
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse
import uvicorn
#from opentelemetry import trace
#from opentelemetry.sdk.trace import TracerProvider

#provider = TracerProvider()
#trace.set_tracer_provider(provider)
#tracer = trace.get_tracer(__name__)

print("Loading: user")

app = FastAPI()

@app.get('/user/profile')
def get_user_profile():
    user = {
        "userId": "1234",
        "email": "user@dummy.com",
        "organization": "dummy.com"
    }
    print("get user profile")
    r = requests.get(f"https://jsonplaceholder.typicode.com/todos/1")
    return JSONResponse( content = jsonable_encoder(user) )

@app.get('/user/profile/{id}')
def get_user_by_id(id):
#    user = get_user()
#    tracer.start_as_current_span(f'todos/{id}')
    if (id == '5'):
#        print_trace_data()
        raise Exception('UID Five is not a valid id')
    r = requests.get(f"https://jsonplaceholder.typicode.com/todos/{id}")
    return JSONResponse( content = jsonable_encoder(r.json()) )

if __name__ == '__main__':
    print("Webserver: user.app starting")
    uvicorn.run( app, host='0.0.0.0', port=5000)
