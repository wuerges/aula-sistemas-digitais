with open('memory.list', 'w') as f:
    for i in range(10):
        for j in range(20):
            f.write("%x\n" % (i*(256) +j))
