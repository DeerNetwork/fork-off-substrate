download:
    #!/bin/bash
    tag=$(curl -fsSL https://api.github.com/repos/DeerNetwork/deer-node/tags | jq -r '.[1].name')
    proxy=https://ghproxy.com/
    wget -O data/runtime.wasm ${proxy}https://github.com/DeerNetwork/deer-node/releases/download/${tag}/deer_runtime.compact.wasm
    wget -O data/binary ${proxy}https://github.com/DeerNetwork/deer-node/releases/download/${tag}/deer-node
    chmod +x data/binary

fork origin="testnet" fork="testnet":
    #!/bin/bash
    if [[ ! -f data/binary ]]; then
        just download
    fi
    export HTTP_RPC_ENDPOINT=https://{{origin}}-rpc.deernetwork.vip
    export ORIG_CHAIN={{origin}} FORK_CHAIN={{fork}} QUICK_MODE=true
    node index.js

launch:
    ./data/binary --base-path ./data/chain  --chain ./data/fork.json --alice