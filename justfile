download tag:
    #!/bin/bash
    proxy=https://ghproxy.com/
    wget -O data/runtime.wasm ${proxy}https://github.com/DeerNetwork/deer-node/releases/download/{{tag}}/deer_runtime.compact.wasm
    wget -O data/binary ${proxy}https://github.com/DeerNetwork/deer-node/releases/download/{{tag}}/deer-node
    chmod +x data/binary

fork origin="testnet" fork="testnet":
    #!/bin/bash
    export ORIG_CHAIN={{origin}} FORK_CHAIN={{fork}} QUICK_MODE=true
    node index.js
    if [[ "{{fork}}" = "testnet" ]]; then
        cat data/fork.json | \
            jq '.bootNodes = ["/ip4/51.195.4.72/tcp/30666/p2p/12D3KooWPRNCd7bpu5HMhXgj92dgxmXcJLWoNwa7UFQkbFWcopeu"]' | \
            jq '.telemetryEndpoints = []' | \
            sponge  data/fork.json
    fi

launch:
    ./data/binary --base-path ./data/chain  --chain ./data/fork.json --alice