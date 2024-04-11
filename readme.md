# Tonsbridge evm contract

This repo is to build a contract aggregator of TON bridges . You can visit here : [TONSBRIDGE](https://bridge.tonspay.top/)

You can bridge your token between EMV&TON here . 

Tonsbridge is base on official bridges and many 3th part bridges . 

## What bridges Tonsbridge supports now 

- Official-bridges

    - 5 TON + 0.25%

- Fixfloat

## How Tonsbridge works ?

The base logic of Tonsbridge is simple : swap your assert on other chains into accepable bTON or eTON in best price , and bridges it by best brige price. 

- Swap asserts user select into wrapTON

- Find the bridge with best price 

- Brdige it to target chain&wallet .

All steps are decentralized .

## Contract address :

Contract address that you should knows

### BSC chain

```
0xE19618aEFAAC7838E0A8fb084aFbbceb5DE7E14e
```

Using `0x10ed43c718714eb63d5aa57b78b54704e256024e` as univ2 , and `0x582d872a1b094fc48f5de31d3b73f2d9be47def1` as WTON