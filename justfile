set dotenv-load := true

download ver="":
    #!/bin/bash
    tag={{ver}}
    if [ -z "$tag" ]; then
        tag=$(curl -fsSL https://api.github.com/repos/DeerNetwork/deer-node/tags | jq -r '.[1].name')
    fi
    wget -O data/runtime.wasm ${PROXY}https://github.com/DeerNetwork/deer-node/releases/download/${tag}/deer_runtime.compact.wasm
    wget -O data/binary ${PROXY}https://github.com/DeerNetwork/deer-node/releases/download/${tag}/deer-node
    chmod +x data/binary

fork origin="testnet" fork="testnet":
    #!/bin/bash
    if [[ ! -f data/binary ]]; then
        just download
    fi
    export HTTP_RPC_ENDPOINT=https://{{origin}}-rpc.deernetwork.vip
    export ORIG_CHAIN={{origin}} FORK_CHAIN={{fork}}
    node index.js

launch:
    ./data/binary --base-path ./data/chain  --chain ./data/fork.json --alice