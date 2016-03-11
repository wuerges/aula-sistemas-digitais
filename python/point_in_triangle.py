from PIL import Image

class P:
    def __init__(self, x, y):
        self.x = x
        self.y = y


def sign(p1, p2, p3):
    return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y);

def insideT(pt, t):
    (v1, v2, v3) = t
    b1 = sign(pt, v1, v2) < 0
    b2 = sign(pt, v2, v3) < 0
    b3 = sign(pt, v3, v1) < 0

    return b1 == b2 and b2 == b3

t1 = (P(10, 10), P(200,100) , P(300,300))
t2 = (P(400, 400), P(700,400) , P(700,600))

triangles = [t1, t2]

img = Image.new("RGB", (800, 600))


for x in range(800):
    for y in range(600):
        for t in triangles:
            if insideT(P(x, y), t):
                img.putpixel((x,y), (255,255,255))

img.save("output.png", "PNG")
