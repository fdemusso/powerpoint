from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
import pyautogui
import uvicorn

app = FastAPI()

pyautogui.FAILSAFE = False


@app.post("/next")
def next_slide():
    pyautogui.press("right")
    return {"ok": True}


@app.post("/prev")
def prev_slide():
    pyautogui.press("left")
    return {"ok": True}


app.mount("/", StaticFiles(directory="static", html=True), name="static")


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
