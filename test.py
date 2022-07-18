# local function get_divs(n)
#     if n==1 then return 1, 1 end
#     for i=math.floor(n/2), 1, -1 do
#         local t_n = n/i
#         if math.floor(t_n) == t_n then
#             return i, n/i
#         end
#     end
# end

# local function calc_pos_and_size(root, size, tot_n, n)
#     local div1, div2 = get_divs(tot_n)
#     local base_size = {math.ceil(size[1]/div1), math.ceil(size[2]/div2)}
#     local grid_pos = {((n-1)%div1), math.floor((n-1)/div1)}
#     local new_pos = {grid_pos[1]*base_size[1]+root[1], root[2], grid_pos[2]*base_size[2]+root[3]}
#     local new_size = {
#         math.min(math.abs(root[1]+size[1]-new_pos[1]), base_size[1]),
#         math.min(math.abs(root[3]+size[2]-new_pos[3]), base_size[2])
#     }
#     return new_pos, new_size
# end

from math import floor, ceil
import pygame as pg
import sys

def get_divs(n):
    for i in range(floor(n/2), 0, -1):
        t_n = n/i
        if floor(t_n) == t_n:
            return i, n/i
    return 1, 1

# def calc_pos_and_size(root, size, n, tot_n, grid_pos=None):
#     div1, div2 = get_divs(tot_n)
#     base_size = (size[0]/div1, size[1]/div2)
#     if not grid_pos:
#         grid_pos = (((n-1)%div1), floor((n-1)/div1))
#         bound = False
#     new_pos = (grid_pos[0]*base_size[0]+root[0], grid_pos[1]*base_size[1]+root[1])
#     next_pos = new_pos[0]+
#     if bound:
#         next_pos, _ = calc_pos_and_size(root, size, n, tot_n, (grid_pos[0]+1, grid_pos[1]+1))
#     new_size = (
#         min(abs(root[0]+size[0]-new_pos[0])),
#         min(abs(root[1]+size[1]-new_pos[1]))
#     )
#     new_pos = [floor(i) for i in new_pos]
#     new_size = [ceil(i) for i in new_size]
#     return new_pos, new_size


def calc_pos_and_size(root, size, tot_n, n=None, grid_pos=None):
    div1, div2 = get_divs(tot_n)
    if size[0] > size[1]:
        div1, div2 = div2, div1
    base_size = (size[0]/div1, size[1]/div2)
    
    if grid_pos == None:
        grid_pos = (((n-1)%div1), floor((n-1)/div1))
    
    new_pos  = (grid_pos[0]*base_size[0]+root[0], grid_pos[1]*base_size[1]+root[1])
    new_pos  = [floor(i) for i in new_pos]
    new_size = [ceil(i) for i in base_size]
    if n != None:
        next_pos, _ = calc_pos_and_size(root, size, tot_n, grid_pos=[grid_pos[0]+1, grid_pos[1]+1])
        new_size = (
            min(abs(new_pos[0]-next_pos[0]), new_size[0]),
            min(abs(new_pos[1]-next_pos[1]), new_size[1])
        )
    return new_pos, new_size

def render(n, size, root, screen):
    rects = []
    for i in range(n):
        r = pg.Rect((0, 0, 0, 0))
        nr_r = calc_pos_and_size(root, size, n, n=i+1)
        r.topleft = nr_r[0]
        r.size = nr_r[1]
        rects.append(r)
    screen.fill((0,0,0))
    print([r for r in rects])
    for i, r in enumerate(rects):
        c = pg.color.Color((0, 0, 0, 0))
        c.hsva = (i+1)/n*360, 100, 100, 100
        pg.draw.rect(screen, c, r)
    pg.display.update()

def main():
    screen = pg.display.set_mode((50, 50), pg.SCALED)
    n, size, root = 1, [5, 5], [0, 0]
    while True:
        for ev in pg.event.get():
            if ev.type == pg.QUIT:
                pg.quit()
                sys.exit()
            if ev.type == pg.KEYDOWN:
                match ev.key:
                    case pg.K_RIGHT:
                        root[0] += 1
                    case pg.K_LEFT:
                        root[0] -= 1
                    case pg.K_DOWN:
                        root[1] += 1
                    case pg.K_UP:
                        root[1] -= 1
                    case pg.K_KP_8:
                        size[1] += 1
                    case pg.K_KP_2:
                        size[1] -= 1
                    case pg.K_KP_4:
                        size[0] -= 1
                    case pg.K_KP_6:
                        size[0] += 1
                    case pg.K_PAGEUP:
                        n += 1
                    case pg.K_PAGEDOWN:
                        n -= 1
        # print(root, size, n)
        render(n, size, root, screen)

if __name__ == '__main__':
    main()