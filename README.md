# Como simular um modulo em Verilog

Suponha um arquivo chamado `arquivo.v`,
comecamos gerando o simulador:

```
$ iverilog arquivo.v
```

Isso produz um arquivo chamado `a.out`, que e' o simulador do circuito.

```
$ ./a.out
```

Ao executar o simulador, caso esteja configurado para
gerar um arquivo de dump, em seguida sera' possivel analisar os sinais com o `gtkwave`:

```
$ gtkwave dump.vcd
```
