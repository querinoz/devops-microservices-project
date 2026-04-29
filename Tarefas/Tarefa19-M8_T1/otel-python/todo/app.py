import requests
from fastapi import FastAPI
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse
import uvicorn
from opentelemetry import trace
#from opentelemetry.sdk.trace import TracerProvider

#provider = TracerProvider()
#trace.set_tracer_provider(provider)
#tracer = trace.get_tracer(__name__)

print("Loading: todo")

app = FastAPI()

user_service_host = 'user'

@app.get('/')
def index():
    return "Hello world"

def get_user():
#    tracer.start_as_current_span('get_user')
    r = requests.get(f'http://{user_service_host}:5000/user/profile')
    return JSONResponse( content = jsonable_encoder(r.json()) )

def get_user_by_id(id):
#    tracer.start_as_current_span('get_user')
    r = requests.get(f'http://{user_service_host}:5000/user/profile/{id}')
    return JSONResponse( content = jsonable_encoder(r.json()) )

@app.get('/todo')
def get_todo():
    user = get_user()
    r = requests.get(f'https://jsonplaceholder.typicode.com/todos')
    print("get todo")
    return JSONResponse( content = jsonable_encoder(r.json()) )

@app.get('/todo/{id}')
def get_todo_by_id(id):
    user = get_user()
    #user = get_user_by_id(id) # >> will Error.raise Exception
#    tracer.start_as_current_span(f'todos/{id}')
    if (id == '5'):
        print_trace_data()
        raise Exception('Five is not a valid id')
    r = requests.get(f"https://jsonplaceholder.typicode.com/todos/{id}")
    return JSONResponse( content = jsonable_encoder(r.json()) )

def print_trace_data():
    span_context = trace.get_current_span().get_span_context()
    if span_context:
        trace_id = trace.format_trace_id(span_context.trace_id)
        span_id = trace.format_span_id(span_context.span_id)
        # print to console, your code should write it to logger
        print('trace_id: %s' % trace_id)
        print('span_id: %s' % span_id)

if __name__ == '__main__':
    print("Webserver: todo.app starting")
    uvicorn.run( app, host='0.0.0.0', port=5000 )
