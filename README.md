
Bitcoin Core 
==============

This is a bitcoin core docker container designed to run behind Six910Pay Server


## To run on mainnet

```
docker run --name bitcoind --log-opt max-size=50m -v /bitcoin-data:/data --restart=always -d ulboralabs/bitcoin-core bitcoind

```


## To run on testnet

```
docker run --name bitcoind-testnet --log-opt max-size=50m -v /bitcoin-test-data:/data --restart=always -d ulboralabs/bitcoin-core bitcoind -testnet

```