from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Medical Health API up and running"}